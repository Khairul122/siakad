<?php

namespace App\Filament\Resources\JadwalKuliahs\Schemas;

use Filament\Forms\Components\Select;
use Filament\Forms\Components\Textarea;
use Filament\Forms\Components\TextInput;
use Filament\Schemas\Components\Section;
use Filament\Schemas\Schema;

class JadwalKuliahForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                Section::make('Jadwal Kuliah Mahasiswa')
                    ->description('Kelola detail jadwal perkuliahan untuk setiap mahasiswa.')
                    ->icon('heroicon-o-calendar-days')
                    ->schema([
                        Select::make('uid')
                            ->relationship('mahasiswa', 'nama')
                            ->searchable()
                            ->preload()
                            ->required()
                            ->label('Mahasiswa')
                            ->prefixIcon('heroicon-o-user'),
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
                        TextInput::make('mata_kuliah')
                            ->required()
                            ->label('Mata Kuliah')
                            ->prefixIcon('heroicon-o-book-open')
                            ->placeholder('Contoh: Rekayasa Perangkat Lunak'),
                        TextInput::make('ruangan')
                            ->prefixIcon('heroicon-o-building-office')
                            ->placeholder('Contoh: Ruang 302 / Lab 1')
                            ->dehydrateStateUsing(fn ($state) => $state ?? ''),
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
                        Textarea::make('keterangan')
                            ->columnSpanFull()
                            ->placeholder('Tambahkan catatan atau keterangan jadwal...')
                            ->dehydrateStateUsing(fn ($state) => $state ?? ''),
                    ])
                    ->columns(2),
            ]);
    }
}
