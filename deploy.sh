#!/bin/bash

# Script deployment manual Laravel Backend untuk Server / VPS
# Penggunaan: ./deploy.sh

set -e

echo "🚀 Starting Deployment Process for SIAKAD Backend..."

# 1. Masuk ke direktori project
cd "$(dirname "$0")"

# 2. Aktifkan maintenance mode
echo "🔒 Enabling maintenance mode..."
php artisan down || true

# 3. Pull update terbaru dari Git
echo "📥 Pulling latest updates from Git repository..."
git fetch origin
git reset --hard origin/$(git rev-parse --abbrev-ref HEAD)

# 4. Install dependency composer
echo "📦 Installing composer dependencies..."
composer install --no-dev --prefer-dist --optimize-autoloader --no-interaction

# 5. Jalankan migrasi database
echo "🗄️ Running database migrations..."
php artisan migrate --force

# 6. Cache & Optimasi Laravel
echo "⚡ Caching & Optimizing configuration, routes, and views..."
php artisan config:cache
php artisan route:cache
php artisan view:cache
php artisan event:cache

# 7. Asset upgrade Filament & Swagger
echo "🎨 Upgrading Filament assets & generating Swagger docs..."
php artisan filament:upgrade
php artisan l5-swagger:generate

# 8. Storage link
echo "🔗 Verifying storage link..."
php artisan storage:link || true

# 9. Atur permission folder storage & bootstrap/cache
echo "🔑 Setting folder permissions..."
chmod -R 775 storage bootstrap/cache
chown -R www-data:www-data storage bootstrap/cache || true

# 10. Restart queue worker
echo "🔄 Restarting queue workers..."
php artisan queue:restart || true

# 11. Matikan maintenance mode
echo "🔓 Disabling maintenance mode..."
php artisan up

echo "✅ Deployment completed successfully!"
