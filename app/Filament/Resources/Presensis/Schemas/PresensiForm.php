<?php

namespace App\Filament\Resources\Presensis\Schemas;

use App\Models\Mahasiswa;
use Filament\Forms\Components\Select;
use Filament\Forms\Components\TextInput;
use Filament\Schemas\Components\Section;
use Filament\Schemas\Components\Utilities\Get;
use Filament\Schemas\Schema;
use Illuminate\Validation\Rules\Unique;

class PresensiForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                Section::make('Detail Presensi Mahasiswa')
                    ->description('Kelola detail absensi/kehadiran harian mahasiswa.')
                    ->icon('heroicon-o-clipboard-document-list')
                    ->schema([
                        Select::make('mahasiswa_uid')
                            ->relationship('mahasiswa', 'nama')
                            ->searchable()
                            ->preload()
                            ->required()
                            ->label('Mahasiswa')
                            ->prefixIcon('heroicon-o-user')
                            ->live()
                            ->afterStateUpdated(function ($state, callable $set) {
                                $m = Mahasiswa::find($state);
                                if ($m) {
                                    $set('nim', $m->nim);
                                    $set('nama', $m->nama);
                                }
                            })
                            ->unique(
                                table: 'presensi',
                                column: 'mahasiswa_uid',
                                ignoreRecord: true,
                                modifyRuleUsing: function (Unique $rule, Get $get) {
                                    return $rule->where('kelas', $get('kelas'))
                                        ->where('pertemuan', $get('pertemuan'));
                                }
                            ),
                        Select::make('kelas_kuliah_id')
                            ->relationship('kelasKuliah', 'nama_kelas')
                            ->getOptionLabelFromRecordUsing(fn ($record) => "{$record->mataKuliah?->nama} - Kelas {$record->nama_kelas} ({$record->tahun_akademik} smt {$record->semester})")
                            ->searchable()
                            ->preload()
                            ->required()
                            ->label('Kelas Kuliah')
                            ->live()
                            ->afterStateUpdated(function ($state, callable $set) {
                                $kelas = \App\Models\KelasKuliah::with('mataKuliah')->find($state);
                                if ($kelas) {
                                    $set('kelas', "{$kelas->mataKuliah?->nama} - Kelas {$kelas->nama_kelas}");
                                }
                            }),
                        TextInput::make('kelas')
                            ->required()
                            ->label('Label Kelas (otomatis)')
                            ->prefixIcon('heroicon-o-rectangle-stack')
                            ->placeholder('Terisi otomatis dari Kelas Kuliah'),
                        TextInput::make('pertemuan')
                            ->required()
                            ->label('Pertemuan Ke-')
                            ->prefixIcon('heroicon-o-hashtag')
                            ->placeholder('Contoh: 1'),
                        Select::make('keterangan')
                            ->options(['Hadir' => 'Hadir', 'Izin' => 'Izin', 'Sakit' => 'Sakit', 'Alpha' => 'Alpha'])
                            ->default('Alpha')
                            ->required()
                            ->label('Keterangan Kehadiran')
                            ->prefixIcon('heroicon-o-check-circle'),
                        TextInput::make('nim')
                            ->required()
                            ->label('NIM')
                            ->prefixIcon('heroicon-o-identification')
                            ->placeholder('Akan terisi otomatis...'),
                        TextInput::make('nama')
                            ->required()
                            ->label('Nama Lengkap')
                            ->prefixIcon('heroicon-o-user-circle')
                            ->placeholder('Akan terisi otomatis...'),
                    ])
                    ->columns(2),
            ]);
    }
}
