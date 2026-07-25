<?php

namespace App\Filament\Resources\Dosens\Schemas;

use Filament\Forms\Components\FileUpload;
use Filament\Forms\Components\TextInput;
use Filament\Schemas\Components\Section;
use Filament\Schemas\Schema;

class DosenForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                Section::make('Data Dosen')
                    ->description('Kelola data pribadi, credential login, dan informasi akademik dosen.')
                    ->icon('heroicon-o-academic-cap')
                    ->schema([
                        TextInput::make('uid')
                            ->required()
                            ->disabled(fn (string $operation) => $operation === 'edit')
                            ->dehydrated()
                            ->prefixIcon('heroicon-o-key')
                            ->placeholder('UID Dosen'),
                        TextInput::make('nama')
                            ->required()
                            ->prefixIcon('heroicon-o-user')
                            ->placeholder('Nama Lengkap Dosen'),
                        TextInput::make('nip')
                            ->unique(ignoreRecord: true)
                            ->prefixIcon('heroicon-o-identification')
                            ->placeholder('Nomor Induk Pegawai'),
                        TextInput::make('email')
                            ->label('Email address')
                            ->email()
                            ->required()
                            ->unique(ignoreRecord: true)
                            ->prefixIcon('heroicon-o-envelope')
                            ->placeholder('Alamat Email Aktif'),
                        TextInput::make('password')
                            ->password()
                            ->dehydrateStateUsing(fn ($state) => filled($state) ? bcrypt($state) : null)
                            ->dehydrated(fn ($state) => filled($state))
                            ->required(fn (string $operation) => $operation === 'create')
                            ->prefixIcon('heroicon-o-lock-closed')
                            ->placeholder('Kata Sandi Akun'),
                        TextInput::make('prodi')
                            ->label('Program Studi')
                            ->prefixIcon('heroicon-o-academic-cap')
                            ->placeholder('Contoh: Sistem Informasi')
                            ->dehydrateStateUsing(fn ($state) => $state ?? ''),
                        FileUpload::make('photo_url')
                            ->label('Foto Profil')
                            ->disk('public')
                            ->directory('uploads/dosen')
                            ->image()
                            ->columnSpanFull()
                            ->dehydrateStateUsing(fn ($state) => $state ?? ''),
                        TextInput::make('fcm_token')
                            ->label('FCM Token (Aplikasi)')
                            ->disabled()
                            ->prefixIcon('heroicon-o-device-phone-mobile')
                            ->placeholder('FCM Token Device')
                            ->columnSpanFull(),
                    ])
                    ->columns(2),
            ]);
    }
}
