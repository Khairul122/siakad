<?php

namespace App\Swagger;

use OpenApi\Attributes as OAT;

#[OAT\Schema(
    schema: 'Notifikasi',
    properties: [
        new OAT\Property(property: 'id', type: 'integer'),
        new OAT\Property(property: 'uid', type: 'string'),
        new OAT\Property(property: 'tipe_user', type: 'string', enum: ['Mahasiswa', 'Dosen']),
        new OAT\Property(property: 'judul', type: 'string'),
        new OAT\Property(property: 'isi', type: 'string'),
        new OAT\Property(property: 'dibaca', type: 'boolean'),
    ]
)]
#[OAT\Schema(
    schema: 'Masukan',
    properties: [
        new OAT\Property(property: 'id', type: 'integer'),
        new OAT\Property(property: 'uid', type: 'string'),
        new OAT\Property(property: 'kategori', type: 'string'),
        new OAT\Property(property: 'pesan', type: 'string'),
    ]
)]
#[OAT\Tag(name: 'Notifikasi', description: 'Notifikasi milik mahasiswa/dosen')]
#[OAT\Tag(name: 'Masukan', description: 'Bantuan & masukan dari dosen')]
#[OAT\Get(path: '/api/notifikasi', tags: ['Notifikasi'], summary: 'Daftar notifikasi milik user yang login', security: [['bearerAuth' => []]], responses: [new OAT\Response(response: 200, description: 'Daftar notifikasi', content: new OAT\JsonContent(type: 'array', items: new OAT\Items(ref: '#/components/schemas/Notifikasi')))])]
#[OAT\Post(
    path: '/api/notifikasi',
    tags: ['Notifikasi'],
    summary: 'Buat notifikasi baru untuk seorang mahasiswa/dosen',
    security: [['bearerAuth' => []]],
    requestBody: new OAT\RequestBody(
        required: true,
        content: new OAT\JsonContent(
            required: ['uid', 'tipe_user', 'judul'],
            properties: [
                new OAT\Property(property: 'uid', type: 'string'),
                new OAT\Property(property: 'tipe_user', type: 'string', enum: ['Mahasiswa', 'Dosen']),
                new OAT\Property(property: 'judul', type: 'string'),
                new OAT\Property(property: 'isi', type: 'string'),
            ]
        )
    ),
    responses: [new OAT\Response(response: 201, description: 'Berhasil dibuat', content: new OAT\JsonContent(ref: '#/components/schemas/Notifikasi'))]
)]
#[OAT\Post(path: '/api/notifikasi/{id}/read', tags: ['Notifikasi'], summary: 'Tandai notifikasi sudah dibaca (pemilik saja)', security: [['bearerAuth' => []]], parameters: [new OAT\Parameter(name: 'id', in: 'path', required: true, schema: new OAT\Schema(type: 'integer'))], responses: [new OAT\Response(response: 200, description: 'Berhasil ditandai dibaca'), new OAT\Response(response: 404, description: 'Tidak ditemukan')])]
#[OAT\Delete(path: '/api/notifikasi/{id}', tags: ['Notifikasi'], summary: 'Hapus notifikasi (pemilik saja)', security: [['bearerAuth' => []]], parameters: [new OAT\Parameter(name: 'id', in: 'path', required: true, schema: new OAT\Schema(type: 'integer'))], responses: [new OAT\Response(response: 200, description: 'Berhasil dihapus')])]
#[OAT\Get(path: '/api/masukan', tags: ['Masukan'], summary: 'Daftar masukan milik dosen yang login', security: [['bearerAuth' => []]], responses: [new OAT\Response(response: 200, description: 'Daftar masukan', content: new OAT\JsonContent(type: 'array', items: new OAT\Items(ref: '#/components/schemas/Masukan')))])]
#[OAT\Post(path: '/api/masukan', tags: ['Masukan'], summary: 'Kirim masukan (dosen)', security: [['bearerAuth' => []]], requestBody: new OAT\RequestBody(content: new OAT\JsonContent(ref: '#/components/schemas/Masukan')), responses: [new OAT\Response(response: 201, description: 'Berhasil dikirim')])]
#[OAT\Get(path: '/api/masukan/{id}', tags: ['Masukan'], summary: 'Detail masukan', security: [['bearerAuth' => []]], parameters: [new OAT\Parameter(name: 'id', in: 'path', required: true, schema: new OAT\Schema(type: 'integer'))], responses: [new OAT\Response(response: 200, description: 'Detail masukan'), new OAT\Response(response: 404, description: 'Tidak ditemukan')])]
#[OAT\Put(path: '/api/masukan/{id}', tags: ['Masukan'], summary: 'Ubah masukan (dosen pemilik)', security: [['bearerAuth' => []]], parameters: [new OAT\Parameter(name: 'id', in: 'path', required: true, schema: new OAT\Schema(type: 'integer'))], requestBody: new OAT\RequestBody(content: new OAT\JsonContent(ref: '#/components/schemas/Masukan')), responses: [new OAT\Response(response: 200, description: 'Berhasil diubah')])]
#[OAT\Delete(path: '/api/masukan/{id}', tags: ['Masukan'], summary: 'Hapus masukan (dosen pemilik)', security: [['bearerAuth' => []]], parameters: [new OAT\Parameter(name: 'id', in: 'path', required: true, schema: new OAT\Schema(type: 'integer'))], responses: [new OAT\Response(response: 200, description: 'Berhasil dihapus')])]
class NotifikasiMasukanDocs {}
