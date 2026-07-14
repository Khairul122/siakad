<?php

namespace App\Filament\Resources\Masukans\Schemas;

use Filament\Forms\Components\Select;
use Filament\Forms\Components\Textarea;
use Filament\Forms\Components\TextInput;
use Filament\Schemas\Components\Section;
use Filament\Schemas\Schema;

class MasukanForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                Section::make('Umpan Balik / Masukan Dosen')
                    ->description('Kelola umpan balik, saran, atau kritik dari dosen.')
                    ->icon('heroicon-o-chat-bubble-bottom-center-text')
                    ->schema([
                        Select::make('uid')
                            ->relationship('dosen', 'nama')
                            ->searchable()
                            ->preload()
                            ->required()
                            ->label('Dosen')
                            ->prefixIcon('heroicon-o-user'),
                        TextInput::make('kategori')
                            ->required()
                            ->label('Kategori Masukan')
                            ->prefixIcon('heroicon-o-tag')
                            ->placeholder('Contoh: Sarana Prasarana, Kurikulum'),
                        Textarea::make('pesan')
                            ->required()
                            ->label('Isi Masukan / Pesan')
                            ->placeholder('Tuliskan detail masukan di sini...')
                            ->columnSpanFull(),
                    ])
                    ->columns(2),
            ]);
    }
}
