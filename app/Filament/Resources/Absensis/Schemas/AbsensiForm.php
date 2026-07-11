<?php

namespace App\Filament\Resources\Absensis\Schemas;

use Filament\Forms\Components\DatePicker;
use Filament\Forms\Components\Select;
use Filament\Forms\Components\Textarea;
use Filament\Forms\Components\TextInput;
use Filament\Schemas\Components\Section;
use Filament\Schemas\Schema;

class AbsensiForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                Section::make('Informasi Absensi Mahasiswa')
                    ->description('Pencatatan kehadiran mahasiswa untuk setiap mata kuliah dan pertemuan.')
                    ->icon('heroicon-o-check-circle')
                    ->schema([
                        Select::make('uid')
                            ->relationship('mahasiswa', 'nama')
                            ->searchable()
                            ->preload()
                            ->required()
                            ->label('Mahasiswa')
                            ->prefixIcon('heroicon-o-user'),
                        Select::make('matkul')
                            ->options([
                                'algoritma' => 'Algoritma',
                                'basis_data' => 'Basis Data',
                                'mobile_computing' => 'Mobile Computing',
                                'rekayasa_web' => 'Rekayasa Web',
                                'sistem_operasi' => 'Sistem Operasi',
                                'statistik' => 'Statistik',
                            ])
                            ->required()
                            ->label('Mata Kuliah')
                            ->prefixIcon('heroicon-o-book-open'),
                        TextInput::make('pertemuan')
                            ->required()
                            ->numeric()
                            ->label('Pertemuan Ke-')
                            ->prefixIcon('heroicon-o-hashtag')
                            ->placeholder('Contoh: 1'),
                        DatePicker::make('tanggal')
                            ->required()
                            ->label('Tanggal Absen')
                            ->prefixIcon('heroicon-o-calendar'),
                        TextInput::make('ruangan')
                            ->prefixIcon('heroicon-o-building-office')
                            ->placeholder('Contoh: Lab Komputer 3')
                            ->dehydrateStateUsing(fn ($state) => $state ?? ''),
                        TextInput::make('dosen')
                            ->label('Dosen Pengajar')
                            ->prefixIcon('heroicon-o-academic-cap')
                            ->placeholder('Nama Dosen')
                            ->dehydrateStateUsing(fn ($state) => $state ?? ''),
                        Textarea::make('keterangan')
                            ->columnSpanFull()
                            ->placeholder('Keterangan absensi (jika ada)...')
                            ->dehydrateStateUsing(fn ($state) => $state ?? ''),
                    ])
                    ->columns(2),
            ]);
    }
}
