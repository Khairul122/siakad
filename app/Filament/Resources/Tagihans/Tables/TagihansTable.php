<?php

namespace App\Filament\Resources\Tagihans\Tables;

use Filament\Actions\Action;
use Filament\Actions\BulkActionGroup;
use Filament\Actions\DeleteBulkAction;
use Filament\Actions\EditAction;
use Filament\Support\Icons\Heroicon;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Filters\SelectFilter;
use Filament\Tables\Table;

class TagihansTable
{
    public static function configure(Table $table): Table
    {
        return $table
            ->columns([
                TextColumn::make('mahasiswa.nama')
                    ->label('Mahasiswa')
                    ->searchable(),
                TextColumn::make('jenis')
                    ->searchable(),
                TextColumn::make('nominal')
                    ->money('IDR')
                    ->sortable(),
                TextColumn::make('status')
                    ->badge()
                    ->color(fn (string $state) => match ($state) {
                        'Belum Dibayar' => 'danger',
                        'Menunggu Konfirmasi' => 'warning',
                        'Lunas' => 'success',
                        default => 'gray',
                    }),
                TextColumn::make('jatuh_tempo')
                    ->date()
                    ->sortable(),
            ])
            ->filters([
                SelectFilter::make('status')
                    ->options([
                        'Belum Dibayar' => 'Belum Dibayar',
                        'Menunggu Konfirmasi' => 'Menunggu Konfirmasi',
                        'Lunas' => 'Lunas',
                    ]),
            ])
            ->recordActions([
                EditAction::make(),
                Action::make('konfirmasi')
                    ->label('Konfirmasi')
                    ->icon(Heroicon::OutlinedCheckCircle)
                    ->color('warning')
                    ->visible(fn ($record) => $record->status === 'Belum Dibayar')
                    ->requiresConfirmation()
                    ->action(fn ($record) => $record->update([
                        'status' => 'Menunggu Konfirmasi',
                        'tanggal_konfirmasi' => now()->toDateTimeString(),
                    ])),
                Action::make('lunas')
                    ->label('Tandai Lunas')
                    ->icon(Heroicon::OutlinedCheckBadge)
                    ->color('success')
                    ->visible(fn ($record) => $record->status === 'Menunggu Konfirmasi')
                    ->requiresConfirmation()
                    ->action(fn ($record) => $record->update([
                        'status' => 'Lunas',
                        'tanggal_lunas' => now()->toDateTimeString(),
                    ])),
            ])
            ->toolbarActions([
                BulkActionGroup::make([
                    DeleteBulkAction::make(),
                ]),
            ]);
    }
}
