<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class JadwalKuliah extends Model
{
    protected $table = 'jadwal_kuliah';
    public $timestamps = false;

    protected $fillable = [
        'uid',
        'hari',
        'mata_kuliah',
        'jam_mulai',
        'jam_selesai',
        'ruangan',
        'keterangan',
    ];

    public function mahasiswa(): BelongsTo
    {
        return $this->belongsTo(Mahasiswa::class, 'uid', 'uid');
    }
}
