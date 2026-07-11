<?php

namespace App\Filament\Resources\Krs;

use App\Filament\Resources\Krs\Pages\CreateKrs;
use App\Filament\Resources\Krs\Pages\EditKrs;
use App\Filament\Resources\Krs\Pages\ListKrs;
use App\Filament\Resources\Krs\RelationManagers\MataKuliahRelationManager;
use App\Filament\Resources\Krs\Schemas\KrsForm;
use App\Filament\Resources\Krs\Tables\KrsTable;
use App\Models\Krs;
use BackedEnum;
use Filament\Resources\Resource;
use Filament\Schemas\Schema;
use Filament\Support\Icons\Heroicon;
use Filament\Tables\Table;
use UnitEnum;

class KrsResource extends Resource
{
    protected static ?string $model = Krs::class;

    protected static ?string $modelLabel = 'KRS';

    protected static ?string $pluralModelLabel = 'KRS';

    protected static string|BackedEnum|null $navigationIcon = Heroicon::OutlinedClipboardDocumentList;

    protected static string|UnitEnum|null $navigationGroup = 'Akademik';

    protected static ?int $navigationSort = 5;

    public static function form(Schema $schema): Schema
    {
        return KrsForm::configure($schema);
    }

    public static function table(Table $table): Table
    {
        return KrsTable::configure($table);
    }

    public static function getRelations(): array
    {
        return [
            MataKuliahRelationManager::class,
        ];
    }

    public static function getPages(): array
    {
        return [
            'index' => ListKrs::route('/'),
            'create' => CreateKrs::route('/create'),
            'edit' => EditKrs::route('/{record}/edit'),
        ];
    }
}
