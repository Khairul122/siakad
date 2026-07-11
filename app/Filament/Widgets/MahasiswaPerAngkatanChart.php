<?php

namespace App\Filament\Widgets;

use App\Models\Mahasiswa;
use Filament\Widgets\ChartWidget;

class MahasiswaPerAngkatanChart extends ChartWidget
{
    protected ?string $heading = 'Mahasiswa per Angkatan';

    protected function getData(): array
    {
        $data = Mahasiswa::query()
            ->selectRaw('angkatan, count(*) as total')
            ->groupBy('angkatan')
            ->orderBy('angkatan')
            ->pluck('total', 'angkatan');

        return [
            'datasets' => [
                [
                    'label' => 'Mahasiswa',
                    'data' => $data->values()->all(),
                    'backgroundColor' => '#16A085',
                ],
            ],
            'labels' => $data->keys()->all(),
        ];
    }

    protected function getType(): string
    {
        return 'bar';
    }
}
