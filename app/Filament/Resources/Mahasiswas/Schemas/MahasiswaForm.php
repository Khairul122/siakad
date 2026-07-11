<?php

namespace App\Filament\Resources\Mahasiswas\Schemas;

use App\Models\Dosen;
use Filament\Forms\Components\DatePicker;
use Filament\Forms\Components\FileUpload;
use Filament\Forms\Components\Select;
use Filament\Forms\Components\TextInput;
use Filament\Forms\Components\Textarea;
use Filament\Schemas\Components\Section;
use Filament\Schemas\Schema;

class MahasiswaForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                Section::make('Data Pribadi')
                    ->description('Kelola data pribadi, kontak, dan credential login mahasiswa.')
                    ->icon('heroicon-o-user')
                    ->schema([
                        TextInput::make('uid')
                            ->required()
                            ->disabled(fn (string $operation) => $operation === 'edit')
                            ->dehydrated()
                            ->prefixIcon('heroicon-o-key')
                            ->placeholder('UID Mahasiswa'),
                        TextInput::make('nama')
                            ->required()
                            ->prefixIcon('heroicon-o-user')
                            ->placeholder('Nama Lengkap Mahasiswa'),
                        TextInput::make('nim')
                            ->required()
                            ->label('NIM')
                            ->unique(ignoreRecord: true)
                            ->prefixIcon('heroicon-o-identification')
                            ->placeholder('Nomor Induk Mahasiswa'),
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
                        TextInput::make('no_hp')
                            ->label('No. Handphone')
                            ->prefixIcon('heroicon-o-phone')
                            ->placeholder('Contoh: 0812XXXXXXXX')
                            ->dehydrateStateUsing(fn ($state) => $state ?? ''),
                        DatePicker::make('tanggal_lahir')
                            ->label('Tanggal Lahir')
                            ->prefixIcon('heroicon-o-calendar')
                            ->native(false)
                            ->dehydrateStateUsing(fn ($state) => $state ?? ''),
                        FileUpload::make('photo_url')
                            ->label('Foto Profil')
                            ->disk('public')
                            ->directory('uploads/mahasiswa')
                            ->image()
                            ->dehydrateStateUsing(fn ($state) => $state ?? ''),
                        Textarea::make('alamat')
                            ->placeholder('Alamat Lengkap Rumah/Kost...')
                            ->columnSpanFull(),
                    ])
                    ->columns(2),
                Section::make('Data Akademik')
                    ->description('Kelola kelas, angkatan, program studi, dan dosen pembimbing akademik.')
                    ->icon('heroicon-o-academic-cap')
                    ->schema([
                        TextInput::make('kelas')
                            ->label('Kelas')
                            ->prefixIcon('heroicon-o-rectangle-stack')
                            ->placeholder('Contoh: TI-3B')
                            ->dehydrateStateUsing(fn ($state) => $state ?? ''),
                        TextInput::make('angkatan')
                            ->label('Angkatan')
                            ->prefixIcon('heroicon-o-users')
                            ->placeholder('Contoh: 2023')
                            ->dehydrateStateUsing(fn ($state) => $state ?? ''),
                        TextInput::make('prodi')
                            ->label('Program Studi')
                            ->prefixIcon('heroicon-o-academic-cap')
                            ->placeholder('Contoh: Teknik Informatika')
                            ->dehydrateStateUsing(fn ($state) => $state ?? ''),
                        Select::make('dosen_pembimbing_uid')
                            ->relationship('dosenPembimbing', 'nama')
                            ->searchable()
                            ->preload()
                            ->label('Dosen Pembimbing')
                            ->prefixIcon('heroicon-o-user-group'),
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
