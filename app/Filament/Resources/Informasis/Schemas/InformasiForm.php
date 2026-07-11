<?php

namespace App\Filament\Resources\Informasis\Schemas;

use Filament\Forms\Components\DateTimePicker;
use Filament\Forms\Components\FileUpload;
use Filament\Forms\Components\TextInput;
use Filament\Forms\Components\Textarea;
use Filament\Schemas\Components\Section;
use Filament\Schemas\Schema;

class InformasiForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                Section::make('Informasi Pengumuman')
                    ->description('Kelola pengumuman atau berita akademik yang akan dipublikasikan ke aplikasi mobile.')
                    ->icon('heroicon-o-information-circle')
                    ->schema([
                        TextInput::make('judul')
                            ->required()
                            ->prefixIcon('heroicon-o-document-text')
                            ->placeholder('Judul pengumuman...'),
                        DateTimePicker::make('tanggal')
                            ->label('Tanggal Publikasi')
                            ->prefixIcon('heroicon-o-calendar')
                            ->default(now()),
                        Textarea::make('isi')
                            ->label('Isi Pengumuman')
                            ->rows(6)
                            ->placeholder('Tuliskan detail pengumuman di sini...')
                            ->columnSpanFull()
                            ->required(),
                        FileUpload::make('gambar_url')
                            ->label('Gambar Pendukung')
                            ->disk('public')
                            ->directory('uploads/informasi')
                            ->image()
                            ->columnSpanFull()
                            ->dehydrateStateUsing(fn ($state) => $state ?? ''),
                    ])
                    ->columns(2),
            ]);
    }
}
