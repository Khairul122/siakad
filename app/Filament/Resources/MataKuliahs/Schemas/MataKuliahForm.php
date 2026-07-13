<?php

namespace App\Filament\Resources\MataKuliahs\Schemas;

use Filament\Forms\Components\TextInput;
use Filament\Schemas\Components\Section;
use Filament\Schemas\Schema;

class MataKuliahForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                Section::make('Mata Kuliah')
                    ->description('Kelola master mata kuliah kurikulum program studi.')
                    ->icon('heroicon-o-book-open')
                    ->schema([
                        TextInput::make('kode')
                            ->required()
                            ->unique(ignoreRecord: true)
                            ->label('Kode Mata Kuliah')
                            ->prefixIcon('heroicon-o-hashtag')
                            ->placeholder('Contoh: IF301'),
                        TextInput::make('nama')
                            ->required()
                            ->label('Nama Mata Kuliah')
                            ->prefixIcon('heroicon-o-book-open')
                            ->placeholder('Contoh: Rekayasa Perangkat Lunak'),
                        TextInput::make('sks')
                            ->required()
                            ->numeric()
                            ->minValue(1)
                            ->maxValue(6)
                            ->label('SKS')
                            ->prefixIcon('heroicon-o-scale'),
                        TextInput::make('prodi')
                            ->label('Program Studi')
                            ->prefixIcon('heroicon-o-academic-cap')
                            ->placeholder('Contoh: Teknik Informatika')
                            ->dehydrateStateUsing(fn ($state) => $state ?? ''),
                        TextInput::make('semester_ke')
                            ->required()
                            ->numeric()
                            ->minValue(1)
                            ->maxValue(14)
                            ->label('Semester Ke')
                            ->prefixIcon('heroicon-o-list-bullet'),
                    ])
                    ->columns(2),
            ]);
    }
}
