<?php

namespace App\Filament\Resources\Krs\RelationManagers;

use App\Models\KelasKuliah;
use Filament\Actions\CreateAction;
use Filament\Actions\DeleteAction;
use Filament\Actions\EditAction;
use Filament\Forms\Components\Select;
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
                Select::make('kelas_kuliah_id')
                    ->relationship('kelasKuliah', 'nama_kelas')
                    ->getOptionLabelFromRecordUsing(fn ($record) => "{$record->mataKuliah?->nama} - Kelas {$record->nama_kelas} ({$record->hari} {$record->jam_mulai}-{$record->jam_selesai})")
                    ->searchable()
                    ->preload()
                    ->required()
                    ->label('Kelas Kuliah')
                    ->helperText('Pilih kelas yang ditawarkan — nama, kode, SKS, dan jadwal akan mengikuti data kelas ini.'),
            ]);
    }

    public function table(Table $table): Table
    {
        return $table
            ->recordTitleAttribute('nama')
            ->columns([
                TextColumn::make('nama')
                    ->label('Mata Kuliah')
                    ->searchable(),
                TextColumn::make('kode'),
                TextColumn::make('sks'),
                TextColumn::make('kelas')
                    ->label('Kelas'),
                TextColumn::make('hari'),
                TextColumn::make('pukul'),
                TextColumn::make('ruang'),
            ])
            ->headerActions([
                CreateAction::make()
                    ->mutateFormDataUsing(function (array $data): array {
                        $kelas = KelasKuliah::with('mataKuliah')->find($data['kelas_kuliah_id']);

                        return array_merge($data, [
                            'nama' => $kelas?->mataKuliah?->nama ?? '',
                            'kode' => $kelas?->mataKuliah?->kode ?? '',
                            'sks' => (string) ($kelas?->mataKuliah?->sks ?? ''),
                            'kelas' => $kelas?->nama_kelas ?? '',
                            'hari' => $kelas?->hari ?? '',
                            'pukul' => $kelas ? "{$kelas->jam_mulai}-{$kelas->jam_selesai}" : '',
                            'ruang' => $kelas?->ruangan ?? '',
                            'status' => '',
                        ]);
                    }),
            ])
            ->recordActions([
                EditAction::make(),
                DeleteAction::make(),
            ]);
    }
}
