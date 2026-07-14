<?php

namespace App\Filament\Resources\Kegiatans\Schemas;

use Filament\Forms\Components\DateTimePicker;
use Filament\Forms\Components\FileUpload;
use Filament\Forms\Components\Select;
use Filament\Forms\Components\Textarea;
use Filament\Forms\Components\TextInput;
use Filament\Schemas\Components\Section;
use Filament\Schemas\Schema;

class KegiatanForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                Section::make('Informasi Kegiatan / Event')
                    ->description('Kelola detail agenda kegiatan atau seminar kampus.')
                    ->icon('heroicon-o-sparkles')
                    ->maxWidth('full')
                    ->schema([
                        TextInput::make('judul')
                            ->required()
                            ->prefixIcon('heroicon-o-document-text')
                            ->placeholder('Nama atau judul kegiatan...'),
                        DateTimePicker::make('tanggal')
                            ->prefixIcon('heroicon-o-calendar')
                            ->default(now()),
                        TextInput::make('lokasi')
                            ->prefixIcon('heroicon-o-map-pin')
                            ->placeholder('Gedung Serbaguna, Zoom, dll.')
                            ->dehydrateStateUsing(fn ($state) => $state ?? ''),
                        Select::make('status')
                            ->options([
                                'Akan Datang' => 'Akan Datang',
                                'Berlangsung' => 'Berlangsung',
                                'Selesai' => 'Selesai',
                            ])
                            ->required()
                            ->prefixIcon('heroicon-o-check-circle')
                            ->dehydrateStateUsing(fn ($state) => $state ?? 'Akan Datang'),
                        TextInput::make('pemateri')
                            ->prefixIcon('heroicon-o-user')
                            ->placeholder('Nama pengisi acara/pemateri')
                            ->dehydrateStateUsing(fn ($state) => $state ?? ''),
                        TextInput::make('kuota')
                            ->numeric()
                            ->prefixIcon('heroicon-o-users')
                            ->placeholder('Contoh: 100')
                            ->dehydrateStateUsing(fn ($state) => $state ?? ''),
                        Textarea::make('deskripsi')
                            ->rows(4)
                            ->placeholder('Tuliskan detail deskripsi kegiatan...')
                            ->columnSpanFull(),
                        FileUpload::make('gambar_url')
                            ->label('Pamflet / Flyer Kegiatan')
                            ->disk('public')
                            ->directory('uploads/kegiatan')
                            ->image()
                            ->columnSpanFull()
                            ->dehydrateStateUsing(fn ($state) => $state ?? ''),
                    ])
                    ->columns(2),
            ]);
    }
}
