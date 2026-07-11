<?php

namespace App\Filament\Resources\Khs\Tables;

use Filament\Actions\BulkActionGroup;
use Filament\Actions\DeleteBulkAction;
use Filament\Actions\EditAction;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Table;

class KhsTable
{
    public static function configure(Table $table): Table
    {
        return $table
            ->columns([
                TextColumn::make('mahasiswa.nama')
                    ->label('Mahasiswa')
                    ->searchable(),
                TextColumn::make('tahun_akademik')
                    ->searchable(),
                TextColumn::make('semester')
                    ->searchable(),
                TextColumn::make('mata_kuliah')
                    ->searchable(),
                TextColumn::make('sks')
                    ->numeric()
                    ->sortable(),
                TextColumn::make('kelas')
                    ->searchable(),
                TextColumn::make('tugas')
                    ->numeric()
                    ->sortable(),
                TextColumn::make('uts')
                    ->numeric()
                    ->sortable(),
                TextColumn::make('uas')
                    ->numeric()
                    ->sortable(),
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
