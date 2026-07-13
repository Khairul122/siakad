<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class MataKuliah extends Model
{
    protected $table = 'mata_kuliah';

    protected $fillable = [
        'kode',
        'nama',
        'sks',
        'prodi',
        'semester_ke',
    ];

    public function kelasKuliah(): HasMany
    {
        return $this->hasMany(KelasKuliah::class, 'mata_kuliah_id', 'id');
    }
}
