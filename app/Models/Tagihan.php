<?php

namespace App\Models;

use App\Traits\HasDynamicStorageUrls;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Tagihan extends Model
{
    use HasDynamicStorageUrls;

    protected $table = 'tagihan';

    public $timestamps = false;

    protected $fillable = [
        'uid',
        'jenis',
        'nominal',
        'status',
        'jatuh_tempo',
        'metode_pembayaran',
        'bank_tujuan',
        'no_rekening',
        'bukti_url',
        'catatan',
        'tanggal_konfirmasi',
        'tanggal_lunas',
    ];

    public function mahasiswa(): BelongsTo
    {
        return $this->belongsTo(Mahasiswa::class, 'uid', 'uid');
    }

    public function getBuktiUrlAttribute($value)
    {
        return $this->getDynamicUrl($value);
    }

    public function setBuktiUrlAttribute($value)
    {
        $this->attributes['bukti_url'] = $this->cleanStoragePath($value);
    }
}
