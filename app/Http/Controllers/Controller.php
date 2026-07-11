<?php

namespace App\Http\Controllers;

use OpenApi\Attributes as OAT;

#[OAT\Info(
    title: 'SIAKAD REST API',
    version: '1.0.0',
    description: 'REST API untuk Sistem Informasi Akademik, dibangun dari skema siakad.sql. Autentikasi memakai JWT mandiri (register/login sendiri, tidak lagi bergantung pada Firebase).'
)]
#[OAT\Server(url: 'http://localhost:8000', description: 'SIAKAD API server')]
#[OAT\SecurityScheme(securityScheme: 'bearerAuth', type: 'http', scheme: 'bearer', bearerFormat: 'JWT')]
abstract class Controller
{
    //
}
