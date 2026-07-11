<?php

namespace App\Http\Controllers\Api;

use App\Models\JadwalKuliah;

class JadwalKuliahController extends BaseCrudController
{
    protected string $modelClass = JadwalKuliah::class;
    protected ?string $ownerColumn = 'uid';
    protected array $fillable = ['hari', 'mata_kuliah', 'jam_mulai', 'jam_selesai', 'ruangan', 'keterangan'];
    protected array $writeRoles = ['mahasiswa'];
    protected bool $dosenReadsAll = true;
}
