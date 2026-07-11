<?php

namespace App\Filament\Resources\JadwalKuliahs;

use App\Filament\Resources\JadwalKuliahs\Pages\CreateJadwalKuliah;
use App\Filament\Resources\JadwalKuliahs\Pages\EditJadwalKuliah;
use App\Filament\Resources\JadwalKuliahs\Pages\ListJadwalKuliahs;
use App\Filament\Resources\JadwalKuliahs\Schemas\JadwalKuliahForm;
use App\Filament\Resources\JadwalKuliahs\Tables\JadwalKuliahsTable;
use App\Models\JadwalKuliah;
use BackedEnum;
use Filament\Resources\Resource;
use Filament\Schemas\Schema;
use Filament\Support\Icons\Heroicon;
use Filament\Tables\Table;
use UnitEnum;

class JadwalKuliahResource extends Resource
{
    protected static ?string $model = JadwalKuliah::class;

    protected static ?string $modelLabel = 'Jadwal Kuliah';

    protected static ?string $pluralModelLabel = 'Jadwal Kuliah';

    protected static string|BackedEnum|null $navigationIcon = Heroicon::OutlinedCalendarDays;

    protected static string|UnitEnum|null $navigationGroup = 'Akademik';

    protected static ?int $navigationSort = 3;

    protected static ?string $recordTitleAttribute = 'mata_kuliah';

    public static function form(Schema $schema): Schema
    {
        return JadwalKuliahForm::configure($schema);
    }

    public static function table(Table $table): Table
    {
        return JadwalKuliahsTable::configure($table);
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
            'index' => ListJadwalKuliahs::route('/'),
            'create' => CreateJadwalKuliah::route('/create'),
            'edit' => EditJadwalKuliah::route('/{record}/edit'),
        ];
    }
}
