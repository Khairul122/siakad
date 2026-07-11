<?php

namespace App\Filament\Widgets;

use App\Models\Tagihan;
use Filament\Widgets\ChartWidget;

class TagihanStatusChart extends ChartWidget
{
    protected ?string $heading = 'Status Tagihan';

    protected function getData(): array
    {
        $counts = Tagihan::query()
            ->selectRaw('status, count(*) as total')
            ->groupBy('status')
            ->pluck('total', 'status');

        $labels = ['Belum Dibayar', 'Menunggu Konfirmasi', 'Lunas'];
        $colors = ['#E74C3C', '#F39C12', '#27AE60'];

        return [
            'datasets' => [
                [
                    'label' => 'Tagihan',
                    'data' => collect($labels)->map(fn ($label) => $counts->get($label, 0))->all(),
                    'backgroundColor' => $colors,
                ],
            ],
            'labels' => $labels,
        ];
    }

    protected function getType(): string
    {
        return 'doughnut';
    }
}
