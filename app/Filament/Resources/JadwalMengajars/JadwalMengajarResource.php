<?php

namespace App\Filament\Resources\JadwalMengajars;

use App\Filament\Resources\JadwalMengajars\Pages\CreateJadwalMengajar;
use App\Filament\Resources\JadwalMengajars\Pages\EditJadwalMengajar;
use App\Filament\Resources\JadwalMengajars\Pages\ListJadwalMengajars;
use App\Filament\Resources\JadwalMengajars\Schemas\JadwalMengajarForm;
use App\Filament\Resources\JadwalMengajars\Tables\JadwalMengajarsTable;
use App\Models\JadwalMengajar;
use BackedEnum;
use Filament\Resources\Resource;
use Filament\Schemas\Schema;
use Filament\Support\Icons\Heroicon;
use Filament\Tables\Table;
use UnitEnum;

class JadwalMengajarResource extends Resource
{
    protected static ?string $model = JadwalMengajar::class;

    protected static ?string $modelLabel = 'Jadwal Mengajar';

    protected static ?string $pluralModelLabel = 'Jadwal Mengajar';

    protected static string|BackedEnum|null $navigationIcon = Heroicon::OutlinedPresentationChartLine;

    protected static string|UnitEnum|null $navigationGroup = 'Akademik';

    protected static ?int $navigationSort = 4;

    protected static ?string $recordTitleAttribute = 'mata_kuliah';

    public static function form(Schema $schema): Schema
    {
        return JadwalMengajarForm::configure($schema);
    }

    public static function table(Table $table): Table
    {
        return JadwalMengajarsTable::configure($table);
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
            'index' => ListJadwalMengajars::route('/'),
            'create' => CreateJadwalMengajar::route('/create'),
            'edit' => EditJadwalMengajar::route('/{record}/edit'),
        ];
    }
}
