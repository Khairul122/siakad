<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Nilai extends Model
{
    protected $table = 'nilai';
    public $timestamps = false;

    protected $fillable = [
        'kelas',
        'kelas_kuliah_id',
        'mahasiswa_uid',
        'nim',
        'nama',
        'tugas',
        'uts',
        'uas',
    ];

    public function mahasiswa(): BelongsTo
    {
        return $this->belongsTo(Mahasiswa::class, 'mahasiswa_uid', 'uid');
    }

    public function kelasKuliah(): BelongsTo
    {
        return $this->belongsTo(KelasKuliah::class, 'kelas_kuliah_id', 'id');
    }

    public function getNilaiAkhirAttribute(): float
    {
        return ($this->tugas * 0.3) + ($this->uts * 0.3) + ($this->uas * 0.4);
    }

    public function getGradeAttribute(): string
    {
        $n = $this->nilai_akhir;
        if ($n >= 85) return 'A';
        if ($n >= 75) return 'B';
        if ($n >= 65) return 'C';
        if ($n >= 55) return 'D';
        return 'E';
    }
}
