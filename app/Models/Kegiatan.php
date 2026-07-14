<?php

namespace App\Models;

use App\Traits\HasDynamicStorageUrls;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

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

    public function pendaftaran(): HasMany
    {
        return $this->hasMany(PendaftaranKegiatan::class, 'kegiatan_id');
    }

    public function getGambarUrlAttribute($value)
    {
        return $this->getDynamicUrl($value);
    }

    public function setGambarUrlAttribute($value)
    {
        $this->attributes['gambar_url'] = $this->cleanStoragePath($value);
    }
}
