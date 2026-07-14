<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class KrsMataKuliah extends Model
{
    protected $table = 'krs_mata_kuliah';

    public $timestamps = false;

    protected $fillable = [
        'krs_id',
        'kelas_kuliah_id',
        'nama',
        'kode',
        'sks',
        'kelas',
        'hari',
        'pukul',
        'ruang',
        'status',
    ];

    public function krs(): BelongsTo
    {
        return $this->belongsTo(Krs::class, 'krs_id', 'id');
    }

    public function kelasKuliah(): BelongsTo
    {
        return $this->belongsTo(KelasKuliah::class, 'kelas_kuliah_id', 'id');
    }
}
