<?php

namespace App\Filament\Widgets;

use App\Models\Dosen;
use App\Models\Informasi;
use App\Models\Mahasiswa;
use App\Models\Tagihan;
use Filament\Widgets\StatsOverviewWidget as BaseWidget;
use Filament\Widgets\StatsOverviewWidget\Stat;

class StatsOverviewWidget extends BaseWidget
{
    protected function getStats(): array
    {
        $awalBulan = now()->startOfMonth()->toDateTimeString();

        return [
            Stat::make('Total Mahasiswa', Mahasiswa::count())
                ->icon('heroicon-o-academic-cap')
                ->color('primary'),

            Stat::make('Total Dosen', Dosen::count())
                ->icon('heroicon-o-user-group')
                ->color('info'),

            Stat::make('Tagihan Belum Lunas', Tagihan::whereIn('status', ['Belum Dibayar', 'Menunggu Konfirmasi'])->count())
                ->icon('heroicon-o-banknotes')
                ->color('danger'),

            Stat::make('Tagihan Lunas Bulan Ini', Tagihan::where('status', 'Lunas')->where('tanggal_lunas', '>=', $awalBulan)->count())
                ->icon('heroicon-o-check-badge')
                ->color('success'),

            Stat::make('Informasi Terbit', Informasi::count())
                ->icon('heroicon-o-newspaper')
                ->color('gray'),
        ];
    }
}
