<?php

namespace App\Filament\Resources\Absensis\Tables;

use Filament\Actions\BulkActionGroup;
use Filament\Actions\DeleteBulkAction;
use Filament\Actions\EditAction;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Filters\SelectFilter;
use Filament\Tables\Table;

class AbsensisTable
{
    public static function configure(Table $table): Table
    {
        return $table
            ->columns([
                TextColumn::make('mahasiswa.nama')
                    ->label('Mahasiswa')
                    ->searchable()
                    ->sortable(),
                TextColumn::make('matkul')
                    ->label('Mata Kuliah')
                    ->badge()
                    ->color('primary')
                    ->sortable(),
                TextColumn::make('pertemuan')
                    ->label('Pertemuan Ke-')
                    ->searchable()
                    ->sortable(),
                TextColumn::make('tanggal')
                    ->label('Tanggal')
                    ->date()
                    ->sortable(),
                TextColumn::make('ruangan')
                    ->label('Ruangan')
                    ->searchable()
                    ->sortable(),
                TextColumn::make('dosen')
                    ->label('Dosen Pengajar')
                    ->searchable()
                    ->sortable(),
            ])
            ->filters([
                SelectFilter::make('matkul')
                    ->options([
                        'algoritma' => 'Algoritma',
                        'basis_data' => 'Basis Data',
                        'mobile_computing' => 'Mobile Computing',
                        'rekayasa_web' => 'Rekayasa Web',
                        'sistem_operasi' => 'Sistem Operasi',
                        'statistik' => 'Statistik',
                    ]),
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
