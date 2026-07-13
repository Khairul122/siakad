<?php

namespace App\Filament\Resources\KelasKuliahs\Tables;

use Filament\Actions\BulkActionGroup;
use Filament\Actions\DeleteBulkAction;
use Filament\Actions\EditAction;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Filters\SelectFilter;
use Filament\Tables\Table;

class KelasKuliahsTable
{
    public static function configure(Table $table): Table
    {
        return $table
            ->columns([
                TextColumn::make('mataKuliah.nama')
                    ->label('Mata Kuliah')
                    ->searchable(),
                TextColumn::make('nama_kelas')
                    ->label('Kelas'),
                TextColumn::make('dosen.nama')
                    ->label('Dosen Pengampu')
                    ->searchable(),
                TextColumn::make('hari')
                    ->badge(),
                TextColumn::make('jam_mulai'),
                TextColumn::make('jam_selesai'),
                TextColumn::make('ruangan'),
                TextColumn::make('kuota'),
                TextColumn::make('krs_mata_kuliah_count')
                    ->counts('krsMataKuliah')
                    ->label('Terisi'),
                TextColumn::make('tahun_akademik')
                    ->searchable(),
                TextColumn::make('semester')
                    ->searchable(),
            ])
            ->filters([
                SelectFilter::make('hari')
                    ->options([
                        'Senin' => 'Senin',
                        'Selasa' => 'Selasa',
                        'Rabu' => 'Rabu',
                        'Kamis' => 'Kamis',
                        'Jumat' => 'Jumat',
                        'Sabtu' => 'Sabtu',
                        'Minggu' => 'Minggu',
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
