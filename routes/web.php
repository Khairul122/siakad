<?php

use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return response()->json([
        'status' => 'success',
        'message' => 'SIAKAD Backend API is running.',
        'documentation' => url('/api/documentation'),
    ]);
});

/**
 * Web Artisan Runner khusus untuk Deployment di FTP / Shared Hosting
 * Akses: https://siakad-backend.domain.com/deploy-runner/{secret}?action=migrate|link|optimize|swagger|all
 */
Route::get('/deploy-runner/{secret}', function ($secret) {
    $expectedSecret = env('DEPLOY_SECRET_KEY', 'siakad_secret_deploy_123');

    if ($secret !== $expectedSecret) {
        return response()->json(['error' => 'Unauthorized access. Secret key invalid.'], 403);
    }

    $action = request()->query('action', 'all');
    $output = [];

    try {
        if ($action === 'migrate' || $action === 'all') {
            Artisan::call('migrate', ['--force' => true]);
            $output['migrate'] = Artisan::output();
        }

        if ($action === 'link' || $action === 'all') {
            Artisan::call('storage:link');
            $output['storage_link'] = Artisan::output();
        }

        if ($action === 'optimize' || $action === 'all') {
            Artisan::call('config:cache');
            Artisan::call('route:cache');
            Artisan::call('view:cache');
            Artisan::call('event:cache');
            $output['optimize'] = 'Configuration, route, view, and event cached successfully.';
        }

        if ($action === 'swagger' || $action === 'all') {
            Artisan::call('l5-swagger:generate');
            $output['swagger'] = 'Swagger documentation generated successfully.';
        }

        if ($action === 'clear') {
            Artisan::call('config:clear');
            Artisan::call('cache:clear');
            Artisan::call('route:clear');
            Artisan::call('view:clear');
            $output['clear'] = 'All caches cleared successfully.';
        }

        return response()->json([
            'status' => 'success',
            'executed_action' => $action,
            'details' => $output,
        ]);
    } catch (\Throwable $e) {
        return response()->json([
            'status' => 'error',
            'message' => $e->getMessage(),
        ], 500);
    }
});
