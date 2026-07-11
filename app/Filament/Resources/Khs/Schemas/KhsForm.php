<?php

namespace App\Filament\Resources\Khs\Schemas;

use Filament\Forms\Components\Select;
use Filament\Forms\Components\TextInput;
use Filament\Schemas\Components\Section;
use Filament\Schemas\Schema;

class KhsForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                Section::make('Detail Mata Kuliah & Semester')
                    ->description('Kelola data semester, mata kuliah, dan bobot SKS mahasiswa.')
                    ->icon('heroicon-o-academic-cap')
                    ->schema([
                        Select::make('uid')
                            ->relationship('mahasiswa', 'nama')
                            ->searchable()
                            ->preload()
                            ->required()
                            ->label('Mahasiswa')
                            ->prefixIcon('heroicon-o-user'),
                        TextInput::make('kode')
                            ->required()
                            ->label('Kode Mata Kuliah')
                            ->prefixIcon('heroicon-o-hashtag')
                            ->placeholder('Contoh: INF-201'),
                        TextInput::make('mata_kuliah')
                            ->required()
                            ->label('Mata Kuliah')
                            ->prefixIcon('heroicon-o-book-open')
                            ->placeholder('Contoh: Pemrograman Web'),
                        TextInput::make('sks')
                            ->numeric()
                            ->required()
                            ->label('Jumlah SKS')
                            ->prefixIcon('heroicon-o-document-text')
                            ->placeholder('Contoh: 3'),
                        TextInput::make('kelas')
                            ->required()
                            ->label('Kelas')
                            ->prefixIcon('heroicon-o-rectangle-stack')
                            ->placeholder('Contoh: TI-4A'),
                        TextInput::make('tahun_akademik')
                            ->required()
                            ->label('Tahun Akademik')
                            ->prefixIcon('heroicon-o-calendar')
                            ->placeholder('Contoh: 2024/2025'),
                        TextInput::make('semester')
                            ->required()
                            ->label('Semester')
                            ->prefixIcon('heroicon-o-list-bullet')
                            ->placeholder('Contoh: 3 / Ganjil'),
                    ])
                    ->columns(2),

                Section::make('Komponen Nilai KHS')
                    ->description('Masukkan nilai tugas, UTS, dan UAS mahasiswa untuk mata kuliah ini (skala 0 - 100).')
                    ->icon('heroicon-o-clipboard-document-check')
                    ->schema([
                        TextInput::make('tugas')
                            ->numeric()
                            ->step(0.01)
                            ->minValue(0)
                            ->maxValue(100)
                            ->required()
                            ->prefixIcon('heroicon-o-pencil-square')
                            ->placeholder('0.00'),
                        TextInput::make('uts')
                            ->label('UTS')
                            ->numeric()
                            ->step(0.01)
                            ->minValue(0)
                            ->maxValue(100)
                            ->required()
                            ->prefixIcon('heroicon-o-pencil-square')
                            ->placeholder('0.00'),
                        TextInput::make('uas')
                            ->label('UAS')
                            ->numeric()
                            ->step(0.01)
                            ->minValue(0)
                            ->maxValue(100)
                            ->required()
                            ->prefixIcon('heroicon-o-pencil-square')
                            ->placeholder('0.00'),
                    ])
                    ->columns(3),
            ]);
    }
}
