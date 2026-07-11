<?php

namespace App\Filament\Resources\Khs\Pages;

use App\Filament\Resources\Khs\KhsResource;
use Filament\Actions\DeleteAction;
use Filament\Resources\Pages\EditRecord;

class EditKhs extends EditRecord
{
    protected static string $resource = KhsResource::class;

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
