<?php

namespace App\Swagger;

use OpenApi\Attributes as OAT;

#[OAT\Schema(
    schema: 'Informasi',
    properties: [
        new OAT\Property(property: 'id', type: 'integer'),
        new OAT\Property(property: 'judul', type: 'string'),
        new OAT\Property(property: 'isi', type: 'string'),
        new OAT\Property(property: 'tanggal', type: 'string', format: 'date-time'),
        new OAT\Property(property: 'gambar_url', type: 'string'),
    ]
)]
#[OAT\Schema(
    schema: 'Kegiatan',
    properties: [
        new OAT\Property(property: 'id', type: 'integer'),
        new OAT\Property(property: 'judul', type: 'string'),
        new OAT\Property(property: 'deskripsi', type: 'string'),
        new OAT\Property(property: 'tanggal', type: 'string', format: 'date-time'),
        new OAT\Property(property: 'gambar_url', type: 'string'),
        new OAT\Property(property: 'lokasi', type: 'string'),
        new OAT\Property(property: 'status', type: 'string'),
        new OAT\Property(property: 'pemateri', type: 'string'),
        new OAT\Property(property: 'kuota', type: 'string'),
    ]
)]
#[OAT\Tag(name: 'Informasi', description: 'Pengumuman/informasi umum, dibaca bersama mahasiswa & dosen')]
#[OAT\Tag(name: 'Kegiatan', description: 'Kegiatan kampus, dibaca bersama mahasiswa & dosen')]
#[OAT\Get(path: '/api/informasi', tags: ['Informasi'], summary: 'Daftar informasi (semua role)', security: [['bearerAuth' => []]], responses: [new OAT\Response(response: 200, description: 'Daftar informasi', content: new OAT\JsonContent(type: 'array', items: new OAT\Items(ref: '#/components/schemas/Informasi')))])]
#[OAT\Post(path: '/api/informasi', tags: ['Informasi'], summary: 'Tambah informasi (dosen)', security: [['bearerAuth' => []]], requestBody: new OAT\RequestBody(content: new OAT\JsonContent(ref: '#/components/schemas/Informasi')), responses: [new OAT\Response(response: 201, description: 'Berhasil dibuat')])]
#[OAT\Get(path: '/api/informasi/{id}', tags: ['Informasi'], summary: 'Detail informasi', security: [['bearerAuth' => []]], parameters: [new OAT\Parameter(name: 'id', in: 'path', required: true, schema: new OAT\Schema(type: 'integer'))], responses: [new OAT\Response(response: 200, description: 'Detail informasi'), new OAT\Response(response: 404, description: 'Tidak ditemukan')])]
#[OAT\Put(path: '/api/informasi/{id}', tags: ['Informasi'], summary: 'Ubah informasi (dosen)', security: [['bearerAuth' => []]], parameters: [new OAT\Parameter(name: 'id', in: 'path', required: true, schema: new OAT\Schema(type: 'integer'))], requestBody: new OAT\RequestBody(content: new OAT\JsonContent(ref: '#/components/schemas/Informasi')), responses: [new OAT\Response(response: 200, description: 'Berhasil diubah')])]
#[OAT\Delete(path: '/api/informasi/{id}', tags: ['Informasi'], summary: 'Hapus informasi (dosen)', security: [['bearerAuth' => []]], parameters: [new OAT\Parameter(name: 'id', in: 'path', required: true, schema: new OAT\Schema(type: 'integer'))], responses: [new OAT\Response(response: 200, description: 'Berhasil dihapus')])]
#[OAT\Get(path: '/api/kegiatan', tags: ['Kegiatan'], summary: 'Daftar kegiatan (semua role)', security: [['bearerAuth' => []]], responses: [new OAT\Response(response: 200, description: 'Daftar kegiatan', content: new OAT\JsonContent(type: 'array', items: new OAT\Items(ref: '#/components/schemas/Kegiatan')))])]
#[OAT\Post(path: '/api/kegiatan', tags: ['Kegiatan'], summary: 'Tambah kegiatan (dosen)', security: [['bearerAuth' => []]], requestBody: new OAT\RequestBody(content: new OAT\JsonContent(ref: '#/components/schemas/Kegiatan')), responses: [new OAT\Response(response: 201, description: 'Berhasil dibuat')])]
#[OAT\Get(path: '/api/kegiatan/{id}', tags: ['Kegiatan'], summary: 'Detail kegiatan', security: [['bearerAuth' => []]], parameters: [new OAT\Parameter(name: 'id', in: 'path', required: true, schema: new OAT\Schema(type: 'integer'))], responses: [new OAT\Response(response: 200, description: 'Detail kegiatan'), new OAT\Response(response: 404, description: 'Tidak ditemukan')])]
#[OAT\Put(path: '/api/kegiatan/{id}', tags: ['Kegiatan'], summary: 'Ubah kegiatan (dosen)', security: [['bearerAuth' => []]], parameters: [new OAT\Parameter(name: 'id', in: 'path', required: true, schema: new OAT\Schema(type: 'integer'))], requestBody: new OAT\RequestBody(content: new OAT\JsonContent(ref: '#/components/schemas/Kegiatan')), responses: [new OAT\Response(response: 200, description: 'Berhasil diubah')])]
#[OAT\Delete(path: '/api/kegiatan/{id}', tags: ['Kegiatan'], summary: 'Hapus kegiatan (dosen)', security: [['bearerAuth' => []]], parameters: [new OAT\Parameter(name: 'id', in: 'path', required: true, schema: new OAT\Schema(type: 'integer'))], responses: [new OAT\Response(response: 200, description: 'Berhasil dihapus')])]
class InformasiKegiatanDocs
{
}
