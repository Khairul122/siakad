<?php

namespace App\Filament\Resources\Notifikasis\Schemas;

use App\Models\Dosen;
use App\Models\Mahasiswa;
use Filament\Forms\Components\Select;
use Filament\Forms\Components\TextInput;
use Filament\Forms\Components\Textarea;
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
                    ->description('Buat dan kirim pesan notifikasi push ke dosen atau mahasiswa.')
                    ->icon('heroicon-o-bell')
                    ->schema([
                        Select::make('tipe_user')
                            ->options(['Mahasiswa' => 'Mahasiswa', 'Dosen' => 'Dosen'])
                            ->required()
                            ->live()
                            ->label('Tipe Penerima')
                            ->prefixIcon('heroicon-o-users'),
                        Select::make('uid')
                            ->label('Penerima Notifikasi')
                            ->options(function (callable $get) {
                                return $get('tipe_user') === 'Dosen'
                                    ? Dosen::query()->pluck('nama', 'uid')
                                    : Mahasiswa::query()->pluck('nama', 'uid');
                            })
                            ->searchable()
                            ->required()
                            ->prefixIcon('heroicon-o-user'),
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
