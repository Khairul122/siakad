<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

use App\Traits\HasDynamicStorageUrls;

class Kegiatan extends Model
{
    use HasDynamicStorageUrls;

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

    public function getGambarUrlAttribute($value)
    {
        return $this->getDynamicUrl($value);
    }

    public function setGambarUrlAttribute($value)
    {
        $this->attributes['gambar_url'] = $this->cleanStoragePath($value);
    }
}
