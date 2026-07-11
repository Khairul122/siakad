<?php

namespace App\Filament\Resources\Mahasiswas\Tables;

use App\Models\Mahasiswa;
use Filament\Actions\BulkActionGroup;
use Filament\Actions\DeleteBulkAction;
use Filament\Actions\EditAction;
use Filament\Tables\Columns\ImageColumn;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Filters\SelectFilter;
use Filament\Tables\Table;

class MahasiswasTable
{
    public static function configure(Table $table): Table
    {
        return $table
            ->columns([
                ImageColumn::make('photo_url')
                    ->label('Foto')
                    ->disk('public')
                    ->circular(),
                TextColumn::make('nim')
                    ->label('NIM')
                    ->searchable()
                    ->copyable()
                    ->sortable(),
                TextColumn::make('nama')
                    ->label('Nama Lengkap')
                    ->searchable()
                    ->sortable(),
                TextColumn::make('email')
                    ->label('Email')
                    ->searchable()
                    ->copyable()
                    ->sortable(),
                TextColumn::make('kelas')
                    ->label('Kelas')
                    ->searchable()
                    ->sortable(),
                TextColumn::make('angkatan')
                    ->label('Angkatan')
                    ->searchable()
                    ->sortable(),
                TextColumn::make('prodi')
                    ->label('Program Studi')
                    ->searchable()
                    ->sortable(),
                TextColumn::make('dosenPembimbing.nama')
                    ->label('Dosen Pembimbing')
                    ->searchable()
                    ->sortable(),
                TextColumn::make('created_at')
                    ->dateTime()
                    ->sortable()
                    ->toggleable(isToggledHiddenByDefault: true),
                TextColumn::make('updated_at')
                    ->dateTime()
                    ->sortable()
                    ->toggleable(isToggledHiddenByDefault: true),
            ])
            ->filters([
                SelectFilter::make('prodi')
                    ->options(fn () => Mahasiswa::query()->distinct()->pluck('prodi', 'prodi')->filter()->all()),
                SelectFilter::make('angkatan')
                    ->options(fn () => Mahasiswa::query()->distinct()->pluck('angkatan', 'angkatan')->filter()->all()),
                SelectFilter::make('kelas')
                    ->options(fn () => Mahasiswa::query()->distinct()->pluck('kelas', 'kelas')->filter()->all()),
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
