<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Absensi extends Model
{
    protected $table = 'absensi';
    public $timestamps = false;

    protected $fillable = [
        'uid',
        'matkul',
        'pertemuan',
        'tanggal',
        'keterangan',
        'ruangan',
        'dosen',
    ];

    public function mahasiswa(): BelongsTo
    {
        return $this->belongsTo(Mahasiswa::class, 'uid', 'uid');
    }
}
