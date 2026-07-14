<?php

namespace App\Filament\Resources\Tagihans\Schemas;

use Filament\Forms\Components\DatePicker;
use Filament\Forms\Components\DateTimePicker;
use Filament\Forms\Components\FileUpload;
use Filament\Forms\Components\Select;
use Filament\Forms\Components\Textarea;
use Filament\Forms\Components\TextInput;
use Filament\Schemas\Components\Section;
use Filament\Schemas\Schema;

class TagihanForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                Section::make('Rincian Tagihan')
                    ->description('Kelola detail tagihan akademik mahasiswa seperti jenis, nominal, dan status.')
                    ->icon('heroicon-o-credit-card')
                    ->schema([
                        Select::make('uid')
                            ->relationship('mahasiswa', 'nama')
                            ->searchable()
                            ->preload()
                            ->required()
                            ->label('Mahasiswa')
                            ->prefixIcon('heroicon-o-user'),
                        TextInput::make('jenis')
                            ->required()
                            ->label('Jenis Tagihan')
                            ->prefixIcon('heroicon-o-tag')
                            ->placeholder('Contoh: UKT Semester Ganjil, SPP Bulan Juli'),
                        TextInput::make('nominal')
                            ->numeric()
                            ->required()
                            ->prefix('Rp')
                            ->placeholder('Contoh: 3000000'),
                        Select::make('status')
                            ->options([
                                'Belum Dibayar' => 'Belum Dibayar',
                                'Menunggu Konfirmasi' => 'Menunggu Konfirmasi',
                                'Lunas' => 'Lunas',
                            ])
                            ->default('Belum Dibayar')
                            ->required()
                            ->prefixIcon('heroicon-o-check-circle'),
                        DatePicker::make('jatuh_tempo')
                            ->label('Jatuh Tempo')
                            ->prefixIcon('heroicon-o-calendar'),
                        Textarea::make('catatan')
                            ->label('Catatan Tagihan')
                            ->placeholder('Catatan atau petunjuk pembayaran...')
                            ->columnSpanFull(),
                    ])
                    ->columns(2),

                Section::make('Informasi Transaksi & Pembayaran')
                    ->description('Rincian metode pembayaran dan bukti transfer yang diunggah oleh mahasiswa.')
                    ->icon('heroicon-o-banknotes')
                    ->schema([
                        TextInput::make('metode_pembayaran')
                            ->label('Metode Pembayaran')
                            ->prefixIcon('heroicon-o-credit-card')
                            ->placeholder('Contoh: Transfer Bank, E-Wallet')
                            ->dehydrateStateUsing(fn ($state) => $state ?? ''),
                        TextInput::make('bank_tujuan')
                            ->label('Bank Tujuan')
                            ->prefixIcon('heroicon-o-building-library')
                            ->placeholder('Contoh: Bank Mandiri, BNI')
                            ->dehydrateStateUsing(fn ($state) => $state ?? ''),
                        TextInput::make('no_rekening')
                            ->label('No. Rekening Tujuan')
                            ->prefixIcon('heroicon-o-identification')
                            ->placeholder('Contoh: 13200xxxxxxxx')
                            ->dehydrateStateUsing(fn ($state) => $state ?? ''),
                        DateTimePicker::make('tanggal_konfirmasi')
                            ->label('Tanggal Konfirmasi')
                            ->disabled()
                            ->prefixIcon('heroicon-o-clock')
                            ->native(false)
                            ->dehydrated(false),
                        DateTimePicker::make('tanggal_lunas')
                            ->label('Tanggal Lunas')
                            ->disabled()
                            ->prefixIcon('heroicon-o-clock')
                            ->native(false)
                            ->dehydrated(false),
                        FileUpload::make('bukti_url')
                            ->label('Bukti Transfer / Pembayaran')
                            ->disk('public')
                            ->directory('uploads/tagihan')
                            ->image()
                            ->columnSpanFull()
                            ->dehydrateStateUsing(fn ($state) => $state ?? ''),
                    ])
                    ->columns(2),
            ]);
    }
}
