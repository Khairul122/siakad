<?php

namespace App\Filament\Resources\Krs\Pages;

use App\Filament\Resources\Krs\KrsResource;
use Filament\Resources\Pages\CreateRecord;

class CreateKrs extends CreateRecord
{
    protected static string $resource = KrsResource::class;

    public function getMaxContentWidth(): string
    {
        return 'full';
    }
}
