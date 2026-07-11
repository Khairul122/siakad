<?php

namespace App\Filament\Resources\Masukans\Pages;

use App\Filament\Resources\Masukans\MasukanResource;
use Filament\Actions\DeleteAction;
use Filament\Resources\Pages\EditRecord;

class EditMasukan extends EditRecord
{
    protected static string $resource = MasukanResource::class;

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
