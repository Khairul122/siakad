<?php

namespace App\Http\Controllers\Api;

use App\Models\Kegiatan;

class KegiatanController extends BaseCrudController
{
    protected string $modelClass = Kegiatan::class;
    protected ?string $ownerColumn = null;
    protected array $fillable = ['judul', 'deskripsi', 'tanggal', 'gambar_url', 'lokasi', 'status', 'pemateri', 'kuota'];
    protected array $writeRoles = ['dosen'];
}
