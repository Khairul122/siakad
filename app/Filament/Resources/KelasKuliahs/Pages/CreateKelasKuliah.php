<?php

namespace App\Filament\Resources\KelasKuliahs\Pages;

use App\Filament\Resources\KelasKuliahs\KelasKuliahResource;
use Filament\Resources\Pages\CreateRecord;

class CreateKelasKuliah extends CreateRecord
{
    protected static string $resource = KelasKuliahResource::class;

    public function getMaxContentWidth(): string
    {
        return 'full';
    }
}
