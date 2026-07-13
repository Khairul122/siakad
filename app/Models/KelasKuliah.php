<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class KelasKuliah extends Model
{
    protected $table = 'kelas_kuliah';

    protected $fillable = [
        'mata_kuliah_id',
        'dosen_uid',
        'nama_kelas',
        'hari',
        'jam_mulai',
        'jam_selesai',
        'ruangan',
        'kuota',
        'tahun_akademik',
        'semester',
    ];

    public function mataKuliah(): BelongsTo
    {
        return $this->belongsTo(MataKuliah::class, 'mata_kuliah_id', 'id');
    }

    public function dosen(): BelongsTo
    {
        return $this->belongsTo(Dosen::class, 'dosen_uid', 'uid');
    }

    public function krsMataKuliah(): HasMany
    {
        return $this->hasMany(KrsMataKuliah::class, 'kelas_kuliah_id', 'id');
    }
}
