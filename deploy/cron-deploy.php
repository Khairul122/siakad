<?php

/**
 * Cron-triggered deploy runner for shared hosting without SSH access.
 * Runs every N minutes via cPanel Cron Jobs. Picks up a new build uploaded
 * over FTP (vendor-deploy.zip + deploy.flag), extracts vendor without shell
 * access, then runs migrate/cache commands in-process via the Artisan kernel.
 */

$root = dirname(__DIR__);
$flagFile = $root . '/storage/app/deploy.flag';
$stateFile = $root . '/storage/app/deploy.state';
$zipPath = $root . '/vendor-deploy.zip';

if (!file_exists($flagFile)) {
    exit(0);
}

$flagSha = trim(file_get_contents($flagFile));
$lastSha = file_exists($stateFile) ? trim(file_get_contents($stateFile)) : '';

if ($flagSha === '' || $flagSha === $lastSha) {
    exit(0);
}

echo "[" . date('Y-m-d H:i:s') . "] Deploying {$flagSha}\n";

if (file_exists($zipPath)) {
    $zip = new ZipArchive;
    if ($zip->open($zipPath) === true) {
        $zip->extractTo($root);
        $zip->close();
        unlink($zipPath);
        echo "vendor-deploy.zip extracted\n";
    } else {
        fwrite(STDERR, "Failed to open vendor-deploy.zip\n");
        exit(1);
    }
}

require $root . '/vendor/autoload.php';

$app = require $root . '/bootstrap/app.php';
/** @var Illuminate\Foundation\Console\Kernel $kernel */
$kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

// First deploy only: generate APP_KEY / JWT secret if not set yet.
// Guarded by emptiness check so a real key is never regenerated on later
// deploys (that would invalidate sessions and existing JWTs).
if (empty(env('APP_KEY'))) {
    $kernel->call('key:generate', ['--force' => true]);
    echo "APP_KEY generated\n";
}
if (empty(env('JWT_SECRET'))) {
    $kernel->call('jwt:secret', ['--force' => true]);
    echo "JWT_SECRET generated\n";
}

// FTP can't transfer symlinks, so public/storage never arrives with the
// build. Recreate it on every deploy in case a full_resync wiped it, or if
// it exists as a real directory instead of a symlink (e.g. left over from
// a stray FTP upload) — Laravel's storage:link silently no-ops in that case.
$publicStoragePath = $root . '/public/storage';
if (!is_link($publicStoragePath)) {
    if (is_dir($publicStoragePath)) {
        rename($publicStoragePath, $publicStoragePath . '.bak-' . time());
    }
    @mkdir($root . '/storage/app/public', 0755, true);
    // Not using artisan's storage:link here: on hosts with exec() disabled
    // (common shared-hosting hardening) Illuminate\Filesystem\Filesystem::link()
    // fails with "Call to undefined function exec()". PHP's own symlink()
    // is a different function and works fine even when exec() is blocked.
    if (symlink($root . '/storage/app/public', $publicStoragePath)) {
        echo "storage symlink recreated\n";
    } else {
        fwrite(STDERR, "Failed to create storage symlink\n");
    }
}

$kernel->call('migrate', ['--force' => true]);
echo $kernel->output();

$kernel->call('config:cache');
$kernel->call('route:cache');
$kernel->call('view:cache');
$kernel->call('l5-swagger:generate');

file_put_contents($stateFile, $flagSha);

echo "[" . date('Y-m-d H:i:s') . "] Deploy {$flagSha} complete\n";
