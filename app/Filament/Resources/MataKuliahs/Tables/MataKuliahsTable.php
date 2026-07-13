<?php

namespace App\Filament\Resources\MataKuliahs\Tables;

use Filament\Actions\BulkActionGroup;
use Filament\Actions\DeleteBulkAction;
use Filament\Actions\EditAction;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Table;

class MataKuliahsTable
{
    public static function configure(Table $table): Table
    {
        return $table
            ->columns([
                TextColumn::make('kode')
                    ->searchable(),
                TextColumn::make('nama')
                    ->searchable(),
                TextColumn::make('sks'),
                TextColumn::make('prodi')
                    ->searchable(),
                TextColumn::make('semester_ke')
                    ->label('Semester Ke'),
            ])
            ->filters([
                //
            ])
            ->recordActions([
                EditAction::make(),
            ])
            ->toolbarActions([
                BulkActionGroup::make([
                    DeleteBulkAction::make(),
                ]),
            ]);
    }
}
