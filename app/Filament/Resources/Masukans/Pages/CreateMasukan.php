<?php

namespace App\Filament\Resources\Masukans\Pages;

use App\Filament\Resources\Masukans\MasukanResource;
use Filament\Resources\Pages\CreateRecord;

class CreateMasukan extends CreateRecord
{
    protected static string $resource = MasukanResource::class;

    public function getMaxContentWidth(): string
    {
        return 'full';
    }
}
