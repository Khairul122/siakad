<?php

namespace App\Http\Controllers\Api;

use App\Models\Informasi;

class InformasiController extends BaseCrudController
{
    protected string $modelClass = Informasi::class;
    protected ?string $ownerColumn = null;
    protected array $fillable = ['judul', 'isi', 'tanggal', 'gambar_url'];
    protected array $writeRoles = ['dosen'];
}
