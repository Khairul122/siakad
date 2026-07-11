<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class JadwalMengajar extends Model
{
    protected $table = 'jadwal_mengajar';
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

    public function dosen(): BelongsTo
    {
        return $this->belongsTo(Dosen::class, 'uid', 'uid');
    }
}
