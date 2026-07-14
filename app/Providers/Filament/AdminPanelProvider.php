<?php

namespace App\Providers\Filament;

use App\Filament\Widgets\MahasiswaPerAngkatanChart;
use App\Filament\Widgets\StatsOverviewWidget;
use App\Filament\Widgets\TagihanStatusChart;
use Filament\Http\Middleware\Authenticate;
use Filament\Http\Middleware\AuthenticateSession;
use Filament\Http\Middleware\DisableBladeIconComponents;
use Filament\Http\Middleware\DispatchServingFilamentEvent;
use Filament\Pages\Dashboard;
use Filament\Panel;
use Filament\PanelProvider;
use Filament\Support\Assets\Css;
use Illuminate\Cookie\Middleware\AddQueuedCookiesToResponse;
use Illuminate\Cookie\Middleware\EncryptCookies;
use Illuminate\Foundation\Http\Middleware\PreventRequestForgery;
use Illuminate\Routing\Middleware\SubstituteBindings;
use Illuminate\Session\Middleware\StartSession;
use Illuminate\View\Middleware\ShareErrorsFromSession;

class AdminPanelProvider extends PanelProvider
{
    public function panel(Panel $panel): Panel
    {
        return $panel
            ->default()
            ->id('admin')
            ->path('admin')
            ->login()
            ->brandName('SIAKAD Admin')
            ->colors([
                'primary' => '#16A085',
                'gray' => '#7F8C8D',
                'danger' => '#E74C3C',
                'success' => '#27AE60',
                'warning' => '#F39C12',
                'info' => '#21ABA5',
            ])
            ->font('Inter')
            ->darkMode(false, isForced: true)
            ->breadcrumbs(false)
            ->sidebarCollapsibleOnDesktop()
            ->navigationGroups([
                'Akademik',
                'Keuangan',
                'Konten',
                'Umpan Balik',
            ])
            ->discoverResources(in: app_path('Filament/Resources'), for: 'App\Filament\Resources')
            ->discoverPages(in: app_path('Filament/Pages'), for: 'App\Filament\Pages')
            ->pages([
                Dashboard::class,
            ])
            ->discoverWidgets(in: app_path('Filament/Widgets'), for: 'App\Filament\Widgets')
            ->widgets([
                StatsOverviewWidget::class,
                MahasiswaPerAngkatanChart::class,
                TagihanStatusChart::class,
            ])
            ->middleware([
                EncryptCookies::class,
                AddQueuedCookiesToResponse::class,
                StartSession::class,
                AuthenticateSession::class,
                ShareErrorsFromSession::class,
                PreventRequestForgery::class,
                SubstituteBindings::class,
                DisableBladeIconComponents::class,
                DispatchServingFilamentEvent::class,
            ])
            ->authMiddleware([
                Authenticate::class,
            ])
            ->assets([
                Css::make('custom-stylesheet', public_path('css/custom.css')),
            ]);
    }
}
