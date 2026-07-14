<?php

namespace App\Swagger;

use OpenApi\Attributes as OAT;

#[OAT\Schema(
    schema: 'Dosen',
    properties: [
        new OAT\Property(property: 'uid', type: 'string'),
        new OAT\Property(property: 'nama', type: 'string'),
        new OAT\Property(property: 'nip', type: 'string'),
        new OAT\Property(property: 'email', type: 'string', format: 'email'),
        new OAT\Property(property: 'photo_url', type: 'string'),
        new OAT\Property(property: 'prodi', type: 'string'),
    ]
)]
#[OAT\Tag(name: 'Dosen', description: 'Profil dosen')]
#[OAT\Get(
    path: '/api/dosen',
    tags: ['Dosen'],
    summary: 'Daftar semua dosen',
    security: [['bearerAuth' => []]],
    responses: [new OAT\Response(response: 200, description: 'Daftar dosen')]
)]
#[OAT\Get(
    path: '/api/dosen/{uid}',
    tags: ['Dosen'],
    summary: 'Detail profil dosen',
    security: [['bearerAuth' => []]],
    parameters: [new OAT\Parameter(name: 'uid', in: 'path', required: true, schema: new OAT\Schema(type: 'string'))],
    responses: [
        new OAT\Response(response: 200, description: 'Detail dosen', content: new OAT\JsonContent(ref: '#/components/schemas/Dosen')),
        new OAT\Response(response: 404, description: 'Tidak ditemukan'),
    ]
)]
#[OAT\Put(
    path: '/api/dosen/{uid}',
    tags: ['Dosen'],
    summary: 'Ubah profil dosen (hanya pemilik akun)',
    security: [['bearerAuth' => []]],
    requestBody: new OAT\RequestBody(content: new OAT\JsonContent(ref: '#/components/schemas/Dosen')),
    parameters: [new OAT\Parameter(name: 'uid', in: 'path', required: true, schema: new OAT\Schema(type: 'string'))],
    responses: [
        new OAT\Response(response: 200, description: 'Berhasil diubah'),
        new OAT\Response(response: 403, description: 'Bukan pemilik akun'),
    ]
)]
#[OAT\Delete(
    path: '/api/dosen/{uid}',
    tags: ['Dosen'],
    summary: 'Hapus akun dosen (hanya pemilik akun)',
    security: [['bearerAuth' => []]],
    parameters: [new OAT\Parameter(name: 'uid', in: 'path', required: true, schema: new OAT\Schema(type: 'string'))],
    responses: [
        new OAT\Response(response: 200, description: 'Berhasil dihapus'),
        new OAT\Response(response: 403, description: 'Bukan pemilik akun'),
    ]
)]
class DosenDocs {}
