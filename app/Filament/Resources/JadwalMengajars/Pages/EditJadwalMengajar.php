<?php

namespace App\Filament\Resources\JadwalMengajars\Pages;

use App\Filament\Resources\JadwalMengajars\JadwalMengajarResource;
use Filament\Actions\DeleteAction;
use Filament\Resources\Pages\EditRecord;

class EditJadwalMengajar extends EditRecord
{
    protected static string $resource = JadwalMengajarResource::class;

    public function getMaxContentWidth(): string
    {
        return 'full';
    }

    protected function getHeaderActions(): array
    {
        return [
            DeleteAction::make(),
        ];
    }
}
