<?php

namespace App\Filament\Resources\Masukans;

use App\Filament\Resources\Masukans\Pages\CreateMasukan;
use App\Filament\Resources\Masukans\Pages\EditMasukan;
use App\Filament\Resources\Masukans\Pages\ListMasukans;
use App\Filament\Resources\Masukans\Schemas\MasukanForm;
use App\Filament\Resources\Masukans\Tables\MasukansTable;
use App\Models\Masukan;
use BackedEnum;
use Filament\Resources\Resource;
use Filament\Schemas\Schema;
use Filament\Support\Icons\Heroicon;
use Filament\Tables\Table;
use UnitEnum;

class MasukanResource extends Resource
{
    protected static ?string $model = Masukan::class;

    protected static ?string $modelLabel = 'Masukan';

    protected static ?string $pluralModelLabel = 'Masukan';

    protected static string|BackedEnum|null $navigationIcon = Heroicon::OutlinedChatBubbleLeftRight;

    protected static string|UnitEnum|null $navigationGroup = 'Umpan Balik';

    protected static ?int $navigationSort = 1;

    public static function form(Schema $schema): Schema
    {
        return MasukanForm::configure($schema);
    }

    public static function table(Table $table): Table
    {
        return MasukansTable::configure($table);
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
            'index' => ListMasukans::route('/'),
            'create' => CreateMasukan::route('/create'),
            'edit' => EditMasukan::route('/{record}/edit'),
        ];
    }
}
