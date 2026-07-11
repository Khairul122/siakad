<?php

namespace App\Filament\Resources\Nilais\Schemas;

use App\Models\Mahasiswa;
use Filament\Forms\Components\Select;
use Filament\Forms\Components\TextInput;
use Filament\Schemas\Components\Section;
use Filament\Schemas\Components\Utilities\Get;
use Filament\Schemas\Schema;
use Illuminate\Validation\Rules\Unique;

class NilaiForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                Section::make('Informasi Mahasiswa & Kelas')
                    ->description('Pilih mahasiswa dan masukkan informasi kelas untuk penilaian.')
                    ->icon('heroicon-o-user-group')
                    ->schema([
                        Select::make('mahasiswa_uid')
                            ->relationship('mahasiswa', 'nama')
                            ->searchable()
                            ->preload()
                            ->required()
                            ->label('Mahasiswa')
                            ->prefixIcon('heroicon-o-user')
                            ->live()
                            ->afterStateUpdated(function ($state, callable $set) {
                                $m = Mahasiswa::find($state);
                                if ($m) {
                                    $set('nim', $m->nim);
                                    $set('nama', $m->nama);
                                }
                            })
                            ->unique(
                                table: 'nilai',
                                column: 'mahasiswa_uid',
                                ignoreRecord: true,
                                modifyRuleUsing: function (Unique $rule, Get $get) {
                                    return $rule->where('kelas', $get('kelas'));
                                }
                            ),
                        TextInput::make('kelas')
                            ->required()
                            ->label('Kelas')
                            ->prefixIcon('heroicon-o-rectangle-stack')
                            ->placeholder('Contoh: TI-3A'),
                        TextInput::make('nim')
                            ->required()
                            ->label('NIM')
                            ->prefixIcon('heroicon-o-identification')
                            ->placeholder('Akan terisi otomatis...'),
                        TextInput::make('nama')
                            ->required()
                            ->label('Nama Lengkap')
                            ->prefixIcon('heroicon-o-user-circle')
                            ->placeholder('Akan terisi otomatis...'),
                    ])
                    ->columns(2),

                Section::make('Komponen Nilai Akhir')
                    ->description('Masukkan nilai UTS, UAS, dan tugas (skala 0 - 100).')
                    ->icon('heroicon-o-calculator')
                    ->schema([
                        TextInput::make('tugas')
                            ->numeric()
                            ->integer()
                            ->required()
                            ->minValue(0)
                            ->maxValue(100)
                            ->prefixIcon('heroicon-o-pencil-square')
                            ->placeholder('0'),
                        TextInput::make('uts')
                            ->label('UTS')
                            ->numeric()
                            ->integer()
                            ->required()
                            ->minValue(0)
                            ->maxValue(100)
                            ->prefixIcon('heroicon-o-pencil-square')
                            ->placeholder('0'),
                        TextInput::make('uas')
                            ->label('UAS')
                            ->numeric()
                            ->integer()
                            ->required()
                            ->minValue(0)
                            ->maxValue(100)
                            ->prefixIcon('heroicon-o-pencil-square')
                            ->placeholder('0'),
                    ])
                    ->columns(3),
            ]);
    }
}
