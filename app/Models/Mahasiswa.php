<?php

namespace App\Models;

use Illuminate\Auth\Authenticatable;
use Illuminate\Contracts\Auth\Authenticatable as AuthenticatableContract;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Notifications\Notifiable;
use Tymon\JWTAuth\Contracts\JWTSubject;

use App\Traits\HasDynamicStorageUrls;

class Mahasiswa extends Model implements AuthenticatableContract, JWTSubject
{
    use Authenticatable, Notifiable, HasDynamicStorageUrls;

    protected $table = 'mahasiswa';
    protected $primaryKey = 'uid';
    public $incrementing = false;
    protected $keyType = 'string';

    protected $fillable = [
        'uid',
        'nama',
        'nim',
        'email',
        'password',
        'no_hp',
        'tanggal_lahir',
        'alamat',
        'photo_url',
        'kelas',
        'angkatan',
        'prodi',
        'dosen_pembimbing_uid',
        'fcm_token',
    ];

    protected $hidden = [
        'password',
    ];

    public function getJWTIdentifier()
    {
        return $this->getKey();
    }

    public function getJWTCustomClaims()
    {
        return ['role' => 'mahasiswa'];
    }

    public function dosenPembimbing(): BelongsTo
    {
        return $this->belongsTo(Dosen::class, 'dosen_pembimbing_uid', 'uid');
    }

    public function jadwalKuliah(): HasMany
    {
        return $this->hasMany(JadwalKuliah::class, 'uid', 'uid');
    }

    public function krs(): HasMany
    {
        return $this->hasMany(Krs::class, 'uid', 'uid');
    }

    public function khs(): HasMany
    {
        return $this->hasMany(Khs::class, 'uid', 'uid');
    }

    public function absensi(): HasMany
    {
        return $this->hasMany(Absensi::class, 'uid', 'uid');
    }

    public function tagihan(): HasMany
    {
        return $this->hasMany(Tagihan::class, 'uid', 'uid');
    }

    public function nilai(): HasMany
    {
        return $this->hasMany(Nilai::class, 'mahasiswa_uid', 'uid');
    }

    public function presensi(): HasMany
    {
        return $this->hasMany(Presensi::class, 'mahasiswa_uid', 'uid');
    }

    public function getPhotoUrlAttribute($value)
    {
        return $this->getDynamicUrl($value);
    }

    public function setPhotoUrlAttribute($value)
    {
        $this->attributes['photo_url'] = $this->cleanStoragePath($value);
    }
}
