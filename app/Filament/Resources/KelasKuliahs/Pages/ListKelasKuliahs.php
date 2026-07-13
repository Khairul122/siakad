<?php

namespace App\Filament\Resources\KelasKuliahs\Pages;

use App\Filament\Resources\KelasKuliahs\KelasKuliahResource;
use Filament\Actions\CreateAction;
use Filament\Resources\Pages\ListRecords;

class ListKelasKuliahs extends ListRecords
{
    protected static string $resource = KelasKuliahResource::class;

    protected function getHeaderActions(): array
    {
        return [
            CreateAction::make(),
        ];
    }
}
