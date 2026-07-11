<?php

namespace App\Filament\Resources\JadwalMengajars\Pages;

use App\Filament\Resources\JadwalMengajars\JadwalMengajarResource;
use Filament\Resources\Pages\CreateRecord;

class CreateJadwalMengajar extends CreateRecord
{
    protected static string $resource = JadwalMengajarResource::class;

    public function getMaxContentWidth(): string
    {
        return 'full';
    }
}
