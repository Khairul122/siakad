<?php

namespace App\Traits;

trait HasDynamicStorageUrls
{
    /**
     * Helper to get full storage URL for a relative path.
     */
    protected function getDynamicUrl(?string $value): ?string
    {
        if (! $value) {
            return null;
        }

        $relativePath = $value;

        // If it is a full URL, check if it points to local storage
        if (filter_var($value, FILTER_VALIDATE_URL)) {
            $path = parse_url($value, PHP_URL_PATH);
            if (str_starts_with($path, '/storage/')) {
                $relativePath = substr($path, strlen('/storage/'));
            } else {
                // Return external URLs as-is
                return $value;
            }
        }

        if (request()->is('api/*') || request()->is('api') || request()->expectsJson()) {
            // Build from the host the client actually hit, not the static
            // APP_URL config — avoids stale/dev-tunnel URLs being returned
            // when APP_URL drifts out of sync with the real deployed domain.
            return rtrim(request()->getSchemeAndHttpHost(), '/').'/storage/'.$relativePath;
        }

        return $relativePath;
    }

    /**
     * Helper to store only relative path for storage URLs.
     */
    protected function cleanStoragePath(?string $value): ?string
    {
        if ($value && filter_var($value, FILTER_VALIDATE_URL)) {
            $path = parse_url($value, PHP_URL_PATH);
            if (str_starts_with($path, '/storage/')) {
                return substr($path, strlen('/storage/'));
            }
        }

        return $value;
    }
}
