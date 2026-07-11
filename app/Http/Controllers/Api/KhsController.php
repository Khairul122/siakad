<?php

namespace App\Http\Controllers\Api;

use App\Models\Khs;

class KhsController extends BaseCrudController
{
    protected string $modelClass = Khs::class;
    protected ?string $ownerColumn = 'uid';
    protected array $fillable = ['tahun_akademik', 'semester', 'kode', 'mata_kuliah', 'sks', 'kelas', 'tugas', 'uts', 'uas'];
    protected array $writeRoles = ['dosen'];
    protected bool $dosenReadsAll = true;
}
