<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Notifikasi extends Model
{
    protected $table = 'notifikasi';

    public $timestamps = false;

    protected $fillable = [
        'uid',
        'tipe_user',
        'judul',
        'isi',
        'dibaca',
    ];

    protected $casts = [
        'dibaca' => 'boolean',
    ];
}
