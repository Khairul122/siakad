<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Kegiatan extends Model
{
    protected $table = 'kegiatan';
    public $timestamps = false;

    protected $fillable = [
        'judul',
        'deskripsi',
        'tanggal',
        'gambar_url',
        'lokasi',
        'status',
        'pemateri',
        'kuota',
    ];
}
