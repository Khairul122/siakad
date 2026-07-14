<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Krs extends Model
{
    protected $table = 'krs';

    public $timestamps = false;

    protected $fillable = [
        'uid',
        'tahun_akademik',
        'semester',
        'status',
        'catatan_dosen',
        'disetujui_oleh',
        'disetujui_at',
        'created_at',
    ];

    public function mahasiswa(): BelongsTo
    {
        return $this->belongsTo(Mahasiswa::class, 'uid', 'uid');
    }

    public function mataKuliah(): HasMany
    {
        return $this->hasMany(KrsMataKuliah::class, 'krs_id', 'id');
    }

    public function disetujuiOleh(): BelongsTo
    {
        return $this->belongsTo(Dosen::class, 'disetujui_oleh', 'uid');
    }

    public function totalSks(): int
    {
        return $this->mataKuliah->sum(fn (KrsMataKuliah $mk) => $mk->kelasKuliah?->mataKuliah?->sks ?? 0);
    }
}
