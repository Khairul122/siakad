<?php

namespace App\Filament\Resources\JadwalMengajars\Schemas;

use Filament\Forms\Components\Select;
use Filament\Forms\Components\Textarea;
use Filament\Forms\Components\TextInput;
use Filament\Schemas\Components\Section;
use Filament\Schemas\Schema;

class JadwalMengajarForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                Section::make('Jadwal Mengajar Dosen')
                    ->description('Kelola detail jadwal mengajar untuk setiap dosen.')
                    ->icon('heroicon-o-presentation-chart-bar')
                    ->schema([
                        Select::make('uid')
                            ->relationship('dosen', 'nama')
                            ->searchable()
                            ->preload()
                            ->required()
                            ->label('Dosen')
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
                            ->placeholder('Contoh: Pemrograman Mobile'),
                        TextInput::make('ruangan')
                            ->prefixIcon('heroicon-o-building-office')
                            ->placeholder('Contoh: Ruang 405 / Lab RPL')
                            ->dehydrateStateUsing(fn ($state) => $state ?? ''),
                        TextInput::make('jam_mulai')
                            ->required()
                            ->placeholder('08:00')
                            ->helperText('Format 24 jam (HH:MM)')
                            ->prefixIcon('heroicon-o-clock'),
                        TextInput::make('jam_selesai')
                            ->required()
                            ->placeholder('10:30')
                            ->helperText('Format 24 jam (HH:MM)')
                            ->prefixIcon('heroicon-o-clock'),
                        Textarea::make('keterangan')
                            ->columnSpanFull()
                            ->placeholder('Tambahkan catatan atau keterangan mengajar...')
                            ->dehydrateStateUsing(fn ($state) => $state ?? ''),
                    ])
                    ->columns(2),
            ]);
    }
}
