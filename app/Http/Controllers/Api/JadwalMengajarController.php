<?php

namespace App\Http\Controllers\Api;

use App\Models\JadwalMengajar;

class JadwalMengajarController extends BaseCrudController
{
    protected string $modelClass = JadwalMengajar::class;
    protected ?string $ownerColumn = 'uid';
    protected array $fillable = ['hari', 'mata_kuliah', 'jam_mulai', 'jam_selesai', 'ruangan', 'keterangan'];
    protected array $writeRoles = ['dosen'];
}
