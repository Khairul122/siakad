<?php

namespace App\Filament\Resources\Notifikasis\Schemas;

use Filament\Forms\Components\Select;
use Filament\Forms\Components\Textarea;
use Filament\Forms\Components\TextInput;
use Filament\Forms\Components\Toggle;
use Filament\Schemas\Components\Section;
use Filament\Schemas\Schema;

class NotifikasiForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                Section::make('Kirim Notifikasi')
                    ->description('Kirim pengumuman langsung ke seluruh pengguna Sistem Akademik (mahasiswa) atau seluruh Dosen, tanpa perlu memilih penerima satu per satu.')
                    ->icon('heroicon-o-bell')
                    ->schema([
                        Select::make('tipe_user')
                            ->options(['Mahasiswa' => 'Sistem Akademik (Semua Mahasiswa)', 'Dosen' => 'Dosen (Semua Dosen)'])
                            ->required()
                            ->label('Kirim Ke')
                            ->prefixIcon('heroicon-o-users'),
                        TextInput::make('judul')
                            ->required()
                            ->label('Judul Notifikasi')
                            ->prefixIcon('heroicon-o-chat-bubble-left-ellipsis')
                            ->placeholder('Masukkan judul notifikasi...'),
                        Toggle::make('dibaca')
                            ->label('Sudah Dibaca')
                            ->default(false)
                            ->inline(false),
                        Textarea::make('isi')
                            ->label('Isi Notifikasi')
                            ->placeholder('Tulis pesan atau detail pengumuman yang ingin disampaikan...')
                            ->columnSpanFull()
                            ->required(),
                    ])
                    ->columns(2),
            ]);
    }
}
