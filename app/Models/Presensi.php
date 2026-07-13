<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Presensi extends Model
{
    protected $table = 'presensi';
    public $timestamps = false;

    protected $fillable = [
        'kelas',
        'kelas_kuliah_id',
        'pertemuan',
        'mahasiswa_uid',
        'nim',
        'nama',
        'keterangan',
    ];

    public function mahasiswa(): BelongsTo
    {
        return $this->belongsTo(Mahasiswa::class, 'mahasiswa_uid', 'uid');
    }

    public function kelasKuliah(): BelongsTo
    {
        return $this->belongsTo(KelasKuliah::class, 'kelas_kuliah_id', 'id');
    }
}
