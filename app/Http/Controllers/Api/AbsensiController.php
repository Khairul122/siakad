<?php

namespace App\Http\Controllers\Api;

use App\Models\Absensi;

class AbsensiController extends BaseCrudController
{
    protected string $modelClass = Absensi::class;
    protected ?string $ownerColumn = 'uid';
    protected array $fillable = ['matkul', 'pertemuan', 'tanggal', 'keterangan', 'ruangan', 'dosen'];
    protected array $writeRoles = ['mahasiswa'];
    protected bool $dosenReadsAll = true;
}
