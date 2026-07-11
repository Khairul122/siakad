<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class OtpRequest extends Model
{
    protected $table = 'otp_requests';
    protected $primaryKey = 'email';
    public $incrementing = false;
    protected $keyType = 'string';
    public $timestamps = false;

    protected $fillable = [
        'email',
        'otp',
        'expired_at',
        'used',
    ];

    protected $casts = [
        'used' => 'boolean',
        'expired_at' => 'integer',
    ];
}
