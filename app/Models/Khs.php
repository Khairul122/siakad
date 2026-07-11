<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Khs extends Model
{
    protected $table = 'khs';
    public $timestamps = false;

    protected $fillable = [
        'uid',
        'tahun_akademik',
        'semester',
        'kode',
        'mata_kuliah',
        'sks',
        'kelas',
        'tugas',
        'uts',
        'uas',
    ];

    public function mahasiswa(): BelongsTo
    {
        return $this->belongsTo(Mahasiswa::class, 'uid', 'uid');
    }
}
