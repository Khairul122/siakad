<?php

namespace App\Filament\Resources\Krs\Schemas;

use Filament\Forms\Components\DateTimePicker;
use Filament\Forms\Components\Select;
use Filament\Forms\Components\Textarea;
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
                    ->description('Kelola registrasi Kartu Rencana Studi (KRS) mahasiswa. Status normalnya diubah lewat alur persetujuan dosen wali di aplikasi — ubah manual di sini hanya untuk kondisi darurat.')
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
                        Select::make('status')
                            ->options([
                                'diajukan' => 'Diajukan',
                                'disetujui' => 'Disetujui',
                                'ditolak' => 'Ditolak',
                            ])
                            ->required()
                            ->default('diajukan')
                            ->label('Status')
                            ->prefixIcon('heroicon-o-flag'),
                        Select::make('disetujui_oleh')
                            ->relationship('disetujuiOleh', 'nama')
                            ->searchable()
                            ->preload()
                            ->label('Disetujui Oleh (Dosen Wali)')
                            ->prefixIcon('heroicon-o-check-badge'),
                        DateTimePicker::make('disetujui_at')
                            ->label('Tanggal Disetujui')
                            ->prefixIcon('heroicon-o-clock'),
                        Textarea::make('catatan_dosen')
                            ->columnSpanFull()
                            ->label('Catatan Dosen Wali')
                            ->placeholder('Catatan persetujuan/penolakan dari dosen wali...'),
                        DateTimePicker::make('created_at')
                            ->label('Tanggal Dibuat')
                            ->prefixIcon('heroicon-o-clock')
                            ->default(now()),
                    ])
                    ->columns(2),
            ]);
    }
}
