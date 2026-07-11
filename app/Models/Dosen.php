<?php

namespace App\Models;

use Illuminate\Auth\Authenticatable;
use Illuminate\Contracts\Auth\Authenticatable as AuthenticatableContract;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Notifications\Notifiable;
use Tymon\JWTAuth\Contracts\JWTSubject;

use App\Traits\HasDynamicStorageUrls;

class Dosen extends Model implements AuthenticatableContract, JWTSubject
{
    use Authenticatable, Notifiable, HasDynamicStorageUrls;

    protected $table = 'dosen';
    protected $primaryKey = 'uid';
    public $incrementing = false;
    protected $keyType = 'string';

    protected $fillable = [
        'uid',
        'nama',
        'nip',
        'email',
        'password',
        'photo_url',
        'prodi',
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
        return ['role' => 'dosen'];
    }

    public function jadwalMengajar(): HasMany
    {
        return $this->hasMany(JadwalMengajar::class, 'uid', 'uid');
    }

    public function mahasiswaBimbingan(): HasMany
    {
        return $this->hasMany(Mahasiswa::class, 'dosen_pembimbing_uid', 'uid');
    }

    public function masukan(): HasMany
    {
        return $this->hasMany(Masukan::class, 'uid', 'uid');
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
