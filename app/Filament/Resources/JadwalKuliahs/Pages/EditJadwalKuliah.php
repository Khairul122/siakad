<?php

namespace App\Filament\Resources\JadwalKuliahs\Pages;

use App\Filament\Resources\JadwalKuliahs\JadwalKuliahResource;
use Filament\Actions\DeleteAction;
use Filament\Resources\Pages\EditRecord;

class EditJadwalKuliah extends EditRecord
{
    protected static string $resource = JadwalKuliahResource::class;

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
