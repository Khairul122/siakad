<?php

namespace App\Filament\Resources\Nilais\Tables;

use Filament\Actions\BulkActionGroup;
use Filament\Actions\DeleteBulkAction;
use Filament\Actions\EditAction;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Table;

class NilaisTable
{
    public static function configure(Table $table): Table
    {
        return $table
            ->columns([
                TextColumn::make('kelas')
                    ->searchable(),
                TextColumn::make('mahasiswa.nama')
                    ->label('Mahasiswa')
                    ->searchable(),
                TextColumn::make('nim')
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
                TextColumn::make('nilai_akhir')
                    ->label('Nilai Akhir')
                    ->numeric(1),
                TextColumn::make('grade')
                    ->badge()
                    ->color(fn (string $state) => match ($state) {
                        'A' => 'success',
                        'B' => 'info',
                        'C' => 'warning',
                        default => 'danger',
                    }),
                TextColumn::make('updated_at')
                    ->dateTime()
                    ->sortable()
                    ->toggleable(isToggledHiddenByDefault: true),
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
