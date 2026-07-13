<?php

namespace App\Filament\Resources\KelasKuliahs\Pages;

use App\Filament\Resources\KelasKuliahs\KelasKuliahResource;
use Filament\Actions\DeleteAction;
use Filament\Resources\Pages\EditRecord;

class EditKelasKuliah extends EditRecord
{
    protected static string $resource = KelasKuliahResource::class;

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
