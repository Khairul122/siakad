<?php

namespace App\Filament\Resources\KelasKuliahs;

use App\Filament\Resources\KelasKuliahs\Pages\CreateKelasKuliah;
use App\Filament\Resources\KelasKuliahs\Pages\EditKelasKuliah;
use App\Filament\Resources\KelasKuliahs\Pages\ListKelasKuliahs;
use App\Filament\Resources\KelasKuliahs\Schemas\KelasKuliahForm;
use App\Filament\Resources\KelasKuliahs\Tables\KelasKuliahsTable;
use App\Models\KelasKuliah;
use BackedEnum;
use Filament\Resources\Resource;
use Filament\Schemas\Schema;
use Filament\Support\Icons\Heroicon;
use Filament\Tables\Table;
use UnitEnum;

class KelasKuliahResource extends Resource
{
    protected static ?string $model = KelasKuliah::class;

    protected static ?string $modelLabel = 'Kelas Kuliah';

    protected static ?string $pluralModelLabel = 'Kelas Kuliah';

    protected static string|BackedEnum|null $navigationIcon = Heroicon::OutlinedCalendarDays;

    protected static string|UnitEnum|null $navigationGroup = 'Akademik';

    protected static ?int $navigationSort = 2;

    public static function form(Schema $schema): Schema
    {
        return KelasKuliahForm::configure($schema);
    }

    public static function table(Table $table): Table
    {
        return KelasKuliahsTable::configure($table);
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
            'index' => ListKelasKuliahs::route('/'),
            'create' => CreateKelasKuliah::route('/create'),
            'edit' => EditKelasKuliah::route('/{record}/edit'),
        ];
    }
}
