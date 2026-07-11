<?php

namespace App\Swagger;

use OpenApi\Attributes as OAT;

#[OAT\Schema(
    schema: 'Absensi',
    properties: [
        new OAT\Property(property: 'id', type: 'integer'),
        new OAT\Property(property: 'uid', type: 'string'),
        new OAT\Property(property: 'matkul', type: 'string', enum: ['algoritma', 'basis_data', 'mobile_computing', 'rekayasa_web', 'sistem_operasi', 'statistik']),
        new OAT\Property(property: 'pertemuan', type: 'string'),
        new OAT\Property(property: 'tanggal', type: 'string', format: 'date'),
        new OAT\Property(property: 'keterangan', type: 'string'),
        new OAT\Property(property: 'ruangan', type: 'string'),
        new OAT\Property(property: 'dosen', type: 'string'),
    ]
)]
#[OAT\Tag(name: 'Absensi', description: 'Absensi mandiri mahasiswa per mata kuliah')]
#[OAT\Get(path: '/api/absensi', tags: ['Absensi'], summary: 'Daftar absensi milik mahasiswa yang login (dosen melihat semua)', security: [['bearerAuth' => []]], responses: [new OAT\Response(response: 200, description: 'Daftar absensi', content: new OAT\JsonContent(type: 'array', items: new OAT\Items(ref: '#/components/schemas/Absensi')))])]
#[OAT\Post(path: '/api/absensi', tags: ['Absensi'], summary: 'Catat absensi (mahasiswa)', security: [['bearerAuth' => []]], requestBody: new OAT\RequestBody(content: new OAT\JsonContent(ref: '#/components/schemas/Absensi')), responses: [new OAT\Response(response: 201, description: 'Berhasil dicatat')])]
#[OAT\Get(path: '/api/absensi/{id}', tags: ['Absensi'], summary: 'Detail absensi', security: [['bearerAuth' => []]], parameters: [new OAT\Parameter(name: 'id', in: 'path', required: true, schema: new OAT\Schema(type: 'integer'))], responses: [new OAT\Response(response: 200, description: 'Detail absensi'), new OAT\Response(response: 404, description: 'Tidak ditemukan')])]
#[OAT\Put(path: '/api/absensi/{id}', tags: ['Absensi'], summary: 'Ubah absensi (mahasiswa pemilik)', security: [['bearerAuth' => []]], parameters: [new OAT\Parameter(name: 'id', in: 'path', required: true, schema: new OAT\Schema(type: 'integer'))], requestBody: new OAT\RequestBody(content: new OAT\JsonContent(ref: '#/components/schemas/Absensi')), responses: [new OAT\Response(response: 200, description: 'Berhasil diubah')])]
#[OAT\Delete(path: '/api/absensi/{id}', tags: ['Absensi'], summary: 'Hapus absensi (mahasiswa pemilik)', security: [['bearerAuth' => []]], parameters: [new OAT\Parameter(name: 'id', in: 'path', required: true, schema: new OAT\Schema(type: 'integer'))], responses: [new OAT\Response(response: 200, description: 'Berhasil dihapus')])]
class AbsensiDocs
{
}
