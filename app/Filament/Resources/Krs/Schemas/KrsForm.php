<?php

namespace App\Filament\Resources\Krs\Schemas;

use Filament\Forms\Components\DateTimePicker;
use Filament\Forms\Components\Select;
use Filament\Forms\Components\TextInput;
use Filament\Schemas\Components\Section;
use Filament\Schemas\Schema;

class KrsForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                Section::make('Kartu Rencana Studi (KRS)')
                    ->description('Kelola registrasi Kartu Rencana Studi (KRS) mahasiswa.')
                    ->icon('heroicon-o-document-text')
                    ->schema([
                        Select::make('uid')
                            ->relationship('mahasiswa', 'nama')
                            ->searchable()
                            ->preload()
                            ->required()
                            ->label('Mahasiswa')
                            ->prefixIcon('heroicon-o-user'),
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
                        DateTimePicker::make('created_at')
                            ->label('Tanggal Dibuat')
                            ->prefixIcon('heroicon-o-clock')
                            ->default(now()),
                    ])
                    ->columns(2),
            ]);
    }
}
