<?php

namespace App\Filament\Resources\Masukans\Pages;

use App\Filament\Resources\Masukans\MasukanResource;
use Filament\Actions\CreateAction;
use Filament\Resources\Pages\ListRecords;

class ListMasukans extends ListRecords
{
    protected static string $resource = MasukanResource::class;

    protected function getHeaderActions(): array
    {
        return [
            CreateAction::make(),
        ];
    }
}
