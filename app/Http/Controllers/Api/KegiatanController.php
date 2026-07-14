<?php

namespace App\Http\Controllers\Api;

use App\Models\Kegiatan;
use Illuminate\Http\Request;

class KegiatanController extends BaseCrudController
{
    protected string $modelClass = Kegiatan::class;

    protected ?string $ownerColumn = null;

    protected array $fillable = ['judul', 'deskripsi', 'tanggal', 'gambar_url', 'lokasi', 'status', 'pemateri', 'kuota'];

    protected array $writeRoles = ['dosen'];

    protected function scopedQuery(Request $request)
    {
        return parent::scopedQuery($request)->withCount('pendaftaran');
    }
}
