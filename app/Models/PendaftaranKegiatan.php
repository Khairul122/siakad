<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class PendaftaranKegiatan extends Model
{
    protected $table = 'pendaftaran_kegiatan';

    public $timestamps = false;

    protected $fillable = [
        'kegiatan_id',
        'uid',
        'nama',
        'nim',
        'prodi',
        'no_hp',
        'status',
    ];

    public function kegiatan(): BelongsTo
    {
        return $this->belongsTo(Kegiatan::class, 'kegiatan_id');
    }

    public function mahasiswa(): BelongsTo
    {
        return $this->belongsTo(Mahasiswa::class, 'uid', 'uid');
    }
}
