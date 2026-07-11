<?php

namespace App\Filament\Resources\Krs\RelationManagers;

use Filament\Actions\CreateAction;
use Filament\Actions\DeleteAction;
use Filament\Actions\EditAction;
use Filament\Forms\Components\TextInput;
use Filament\Resources\RelationManagers\RelationManager;
use Filament\Schemas\Schema;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Table;

class MataKuliahRelationManager extends RelationManager
{
    protected static string $relationship = 'mataKuliah';

    public function form(Schema $schema): Schema
    {
        return $schema
            ->components([
                TextInput::make('nama')
                    ->required(),
                TextInput::make('kode')
                    ->required(),
                TextInput::make('sks')
                    ->dehydrateStateUsing(fn ($state) => $state ?? ''),
                TextInput::make('kelas')
                    ->dehydrateStateUsing(fn ($state) => $state ?? ''),
                TextInput::make('hari')
                    ->dehydrateStateUsing(fn ($state) => $state ?? ''),
                TextInput::make('pukul')
                    ->dehydrateStateUsing(fn ($state) => $state ?? ''),
                TextInput::make('ruang')
                    ->dehydrateStateUsing(fn ($state) => $state ?? ''),
                TextInput::make('status')
                    ->dehydrateStateUsing(fn ($state) => $state ?? ''),
            ]);
    }

    public function table(Table $table): Table
    {
        return $table
            ->columns([
                TextColumn::make('nama')
                    ->searchable(),
                TextColumn::make('kode')
                    ->searchable(),
                TextColumn::make('sks'),
                TextColumn::make('kelas'),
                TextColumn::make('hari'),
                TextColumn::make('pukul'),
                TextColumn::make('ruang'),
                TextColumn::make('status'),
            ])
            ->headerActions([
                CreateAction::make(),
            ])
            ->recordActions([
                EditAction::make(),
                DeleteAction::make(),
            ]);
    }
}
