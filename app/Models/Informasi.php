<?php

namespace App\Models;

use App\Traits\HasDynamicStorageUrls;
use Illuminate\Database\Eloquent\Model;

class Informasi extends Model
{
    use HasDynamicStorageUrls;

    protected $table = 'informasi';

    public $timestamps = false;

    protected $fillable = [
        'judul',
        'isi',
        'tanggal',
        'gambar_url',
    ];

    public function getGambarUrlAttribute($value)
    {
        return $this->getDynamicUrl($value);
    }

    public function setGambarUrlAttribute($value)
    {
        $this->attributes['gambar_url'] = $this->cleanStoragePath($value);
    }
}
