<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Masukan extends Model
{
    protected $table = 'masukan';
    public $timestamps = false;

    protected $fillable = [
        'uid',
        'kategori',
        'pesan',
    ];

    public function dosen(): BelongsTo
    {
        return $this->belongsTo(Dosen::class, 'uid', 'uid');
    }
}
