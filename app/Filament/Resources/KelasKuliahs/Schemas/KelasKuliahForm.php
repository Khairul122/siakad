<?php

namespace App\Filament\Resources\KelasKuliahs\Schemas;

use Filament\Forms\Components\Select;
use Filament\Forms\Components\TextInput;
use Filament\Schemas\Components\Section;
use Filament\Schemas\Schema;

class KelasKuliahForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                Section::make('Kelas Kuliah (Penawaran Mata Kuliah)')
                    ->description('Kelola kelas yang ditawarkan setiap periode — inilah yang dipilih mahasiswa saat mengisi KRS.')
                    ->icon('heroicon-o-calendar-days')
                    ->schema([
                        Select::make('mata_kuliah_id')
                            ->relationship('mataKuliah', 'nama')
                            ->searchable()
                            ->preload()
                            ->required()
                            ->label('Mata Kuliah')
                            ->prefixIcon('heroicon-o-book-open'),
                        Select::make('dosen_uid')
                            ->relationship('dosen', 'nama')
                            ->searchable()
                            ->preload()
                            ->label('Dosen Pengampu')
                            ->prefixIcon('heroicon-o-user'),
                        TextInput::make('nama_kelas')
                            ->required()
                            ->label('Nama Kelas')
                            ->prefixIcon('heroicon-o-identification')
                            ->placeholder('Contoh: A1'),
                        Select::make('hari')
                            ->options([
                                'Senin' => 'Senin',
                                'Selasa' => 'Selasa',
                                'Rabu' => 'Rabu',
                                'Kamis' => 'Kamis',
                                'Jumat' => 'Jumat',
                                'Sabtu' => 'Sabtu',
                                'Minggu' => 'Minggu',
                            ])
                            ->required()
                            ->prefixIcon('heroicon-o-calendar'),
                        TextInput::make('jam_mulai')
                            ->required()
                            ->placeholder('08:00')
                            ->helperText('Format 24 jam (HH:MM)')
                            ->prefixIcon('heroicon-o-clock'),
                        TextInput::make('jam_selesai')
                            ->required()
                            ->placeholder('09:40')
                            ->helperText('Format 24 jam (HH:MM)')
                            ->prefixIcon('heroicon-o-clock'),
                        TextInput::make('ruangan')
                            ->prefixIcon('heroicon-o-building-office')
                            ->placeholder('Contoh: Ruang 302 / Lab 1')
                            ->dehydrateStateUsing(fn ($state) => $state ?? ''),
                        TextInput::make('kuota')
                            ->required()
                            ->numeric()
                            ->minValue(1)
                            ->label('Kuota Peserta')
                            ->prefixIcon('heroicon-o-users'),
                        TextInput::make('tahun_akademik')
                            ->required()
                            ->label('Tahun Akademik')
                            ->prefixIcon('heroicon-o-calendar')
                            ->placeholder('2024/2025'),
                        TextInput::make('semester')
                            ->required()
                            ->label('Semester')
                            ->prefixIcon('heroicon-o-list-bullet')
                            ->placeholder('Contoh: 3'),
                    ])
                    ->columns(2),
            ]);
    }
}
