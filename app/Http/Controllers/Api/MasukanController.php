<?php

namespace App\Http\Controllers\Api;

use App\Models\Masukan;

class MasukanController extends BaseCrudController
{
    protected string $modelClass = Masukan::class;
    protected ?string $ownerColumn = 'uid';
    protected array $fillable = ['kategori', 'pesan'];
    protected array $writeRoles = ['dosen'];
}
