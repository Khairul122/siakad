<?php

namespace App\Swagger;

use OpenApi\Attributes as OAT;

#[OAT\Schema(
    schema: 'JadwalKuliah',
    properties: [
        new OAT\Property(property: 'id', type: 'integer'),
        new OAT\Property(property: 'uid', type: 'string'),
        new OAT\Property(property: 'hari', type: 'string'),
        new OAT\Property(property: 'mata_kuliah', type: 'string'),
        new OAT\Property(property: 'jam_mulai', type: 'string'),
        new OAT\Property(property: 'jam_selesai', type: 'string'),
        new OAT\Property(property: 'ruangan', type: 'string'),
        new OAT\Property(property: 'keterangan', type: 'string'),
    ]
)]
#[OAT\Schema(
    schema: 'JadwalMengajar',
    properties: [
        new OAT\Property(property: 'id', type: 'integer'),
        new OAT\Property(property: 'uid', type: 'string'),
        new OAT\Property(property: 'hari', type: 'string'),
        new OAT\Property(property: 'mata_kuliah', type: 'string'),
        new OAT\Property(property: 'jam_mulai', type: 'string'),
        new OAT\Property(property: 'jam_selesai', type: 'string'),
        new OAT\Property(property: 'ruangan', type: 'string'),
        new OAT\Property(property: 'keterangan', type: 'string'),
    ]
)]
#[OAT\Tag(name: 'Jadwal Kuliah', description: 'Jadwal kuliah milik mahasiswa')]
#[OAT\Tag(name: 'Jadwal Mengajar', description: 'Jadwal mengajar milik dosen')]
#[OAT\Get(path: '/api/jadwal-kuliah', tags: ['Jadwal Kuliah'], summary: 'Daftar jadwal kuliah milik mahasiswa yang login (dosen melihat semua)', security: [['bearerAuth' => []]], responses: [new OAT\Response(response: 200, description: 'Daftar jadwal', content: new OAT\JsonContent(type: 'array', items: new OAT\Items(ref: '#/components/schemas/JadwalKuliah')))])]
#[OAT\Post(path: '/api/jadwal-kuliah', tags: ['Jadwal Kuliah'], summary: 'Tambah jadwal kuliah (mahasiswa)', security: [['bearerAuth' => []]], requestBody: new OAT\RequestBody(content: new OAT\JsonContent(ref: '#/components/schemas/JadwalKuliah')), responses: [new OAT\Response(response: 201, description: 'Berhasil dibuat')])]
#[OAT\Get(path: '/api/jadwal-kuliah/{id}', tags: ['Jadwal Kuliah'], summary: 'Detail jadwal kuliah', security: [['bearerAuth' => []]], parameters: [new OAT\Parameter(name: 'id', in: 'path', required: true, schema: new OAT\Schema(type: 'integer'))], responses: [new OAT\Response(response: 200, description: 'Detail jadwal'), new OAT\Response(response: 404, description: 'Tidak ditemukan')])]
#[OAT\Put(path: '/api/jadwal-kuliah/{id}', tags: ['Jadwal Kuliah'], summary: 'Ubah jadwal kuliah (mahasiswa pemilik)', security: [['bearerAuth' => []]], parameters: [new OAT\Parameter(name: 'id', in: 'path', required: true, schema: new OAT\Schema(type: 'integer'))], requestBody: new OAT\RequestBody(content: new OAT\JsonContent(ref: '#/components/schemas/JadwalKuliah')), responses: [new OAT\Response(response: 200, description: 'Berhasil diubah')])]
#[OAT\Delete(path: '/api/jadwal-kuliah/{id}', tags: ['Jadwal Kuliah'], summary: 'Hapus jadwal kuliah (mahasiswa pemilik)', security: [['bearerAuth' => []]], parameters: [new OAT\Parameter(name: 'id', in: 'path', required: true, schema: new OAT\Schema(type: 'integer'))], responses: [new OAT\Response(response: 200, description: 'Berhasil dihapus')])]
#[OAT\Get(path: '/api/jadwal-mengajar', tags: ['Jadwal Mengajar'], summary: 'Daftar jadwal mengajar milik dosen yang login', security: [['bearerAuth' => []]], responses: [new OAT\Response(response: 200, description: 'Daftar jadwal', content: new OAT\JsonContent(type: 'array', items: new OAT\Items(ref: '#/components/schemas/JadwalMengajar')))])]
#[OAT\Post(path: '/api/jadwal-mengajar', tags: ['Jadwal Mengajar'], summary: 'Tambah jadwal mengajar (dosen)', security: [['bearerAuth' => []]], requestBody: new OAT\RequestBody(content: new OAT\JsonContent(ref: '#/components/schemas/JadwalMengajar')), responses: [new OAT\Response(response: 201, description: 'Berhasil dibuat')])]
#[OAT\Get(path: '/api/jadwal-mengajar/{id}', tags: ['Jadwal Mengajar'], summary: 'Detail jadwal mengajar', security: [['bearerAuth' => []]], parameters: [new OAT\Parameter(name: 'id', in: 'path', required: true, schema: new OAT\Schema(type: 'integer'))], responses: [new OAT\Response(response: 200, description: 'Detail jadwal'), new OAT\Response(response: 404, description: 'Tidak ditemukan')])]
#[OAT\Put(path: '/api/jadwal-mengajar/{id}', tags: ['Jadwal Mengajar'], summary: 'Ubah jadwal mengajar (dosen pemilik)', security: [['bearerAuth' => []]], parameters: [new OAT\Parameter(name: 'id', in: 'path', required: true, schema: new OAT\Schema(type: 'integer'))], requestBody: new OAT\RequestBody(content: new OAT\JsonContent(ref: '#/components/schemas/JadwalMengajar')), responses: [new OAT\Response(response: 200, description: 'Berhasil diubah')])]
#[OAT\Delete(path: '/api/jadwal-mengajar/{id}', tags: ['Jadwal Mengajar'], summary: 'Hapus jadwal mengajar (dosen pemilik)', security: [['bearerAuth' => []]], parameters: [new OAT\Parameter(name: 'id', in: 'path', required: true, schema: new OAT\Schema(type: 'integer'))], responses: [new OAT\Response(response: 200, description: 'Berhasil dihapus')])]
class JadwalDocs
{
}
