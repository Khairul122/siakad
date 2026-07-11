<?php

namespace App\Filament\Resources\Khs;

use App\Filament\Resources\Khs\Pages\CreateKhs;
use App\Filament\Resources\Khs\Pages\EditKhs;
use App\Filament\Resources\Khs\Pages\ListKhs;
use App\Filament\Resources\Khs\Schemas\KhsForm;
use App\Filament\Resources\Khs\Tables\KhsTable;
use App\Models\Khs;
use BackedEnum;
use Filament\Resources\Resource;
use Filament\Schemas\Schema;
use Filament\Support\Icons\Heroicon;
use Filament\Tables\Table;
use UnitEnum;

class KhsResource extends Resource
{
    protected static ?string $model = Khs::class;

    protected static ?string $modelLabel = 'KHS';

    protected static ?string $pluralModelLabel = 'KHS';

    protected static string|BackedEnum|null $navigationIcon = Heroicon::OutlinedDocumentChartBar;

    protected static string|UnitEnum|null $navigationGroup = 'Akademik';

    protected static ?int $navigationSort = 6;

    public static function form(Schema $schema): Schema
    {
        return KhsForm::configure($schema);
    }

    public static function table(Table $table): Table
    {
        return KhsTable::configure($table);
    }

    public static function getRelations(): array
    {
        return [
            //
        ];
    }

    public static function getPages(): array
    {
        return [
            'index' => ListKhs::route('/'),
            'create' => CreateKhs::route('/create'),
            'edit' => EditKhs::route('/{record}/edit'),
        ];
    }
}
