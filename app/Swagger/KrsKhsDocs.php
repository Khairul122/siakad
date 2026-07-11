<?php

namespace App\Swagger;

use OpenApi\Attributes as OAT;

#[OAT\Schema(
    schema: 'MataKuliahKrs',
    properties: [
        new OAT\Property(property: 'nama', type: 'string'),
        new OAT\Property(property: 'kode', type: 'string'),
        new OAT\Property(property: 'sks', type: 'string'),
        new OAT\Property(property: 'kelas', type: 'string'),
        new OAT\Property(property: 'hari', type: 'string'),
        new OAT\Property(property: 'pukul', type: 'string'),
        new OAT\Property(property: 'ruang', type: 'string'),
        new OAT\Property(property: 'status', type: 'string'),
    ]
)]
#[OAT\Schema(
    schema: 'Krs',
    properties: [
        new OAT\Property(property: 'id', type: 'integer'),
        new OAT\Property(property: 'uid', type: 'string'),
        new OAT\Property(property: 'tahun_akademik', type: 'string'),
        new OAT\Property(property: 'semester', type: 'string'),
        new OAT\Property(property: 'mata_kuliah', type: 'array', items: new OAT\Items(ref: '#/components/schemas/MataKuliahKrs')),
    ]
)]
#[OAT\Schema(
    schema: 'Khs',
    properties: [
        new OAT\Property(property: 'id', type: 'integer'),
        new OAT\Property(property: 'uid', type: 'string'),
        new OAT\Property(property: 'tahun_akademik', type: 'string'),
        new OAT\Property(property: 'semester', type: 'string'),
        new OAT\Property(property: 'kode', type: 'string'),
        new OAT\Property(property: 'mata_kuliah', type: 'string'),
        new OAT\Property(property: 'sks', type: 'integer'),
        new OAT\Property(property: 'kelas', type: 'string'),
        new OAT\Property(property: 'tugas', type: 'number', format: 'float'),
        new OAT\Property(property: 'uts', type: 'number', format: 'float'),
        new OAT\Property(property: 'uas', type: 'number', format: 'float'),
    ]
)]
#[OAT\Tag(name: 'KRS', description: 'Kartu Rencana Studi mahasiswa (dengan daftar mata kuliah bersarang)')]
#[OAT\Tag(name: 'KHS', description: 'Kartu Hasil Studi mahasiswa (diisi dosen)')]
#[OAT\Get(path: '/api/krs', tags: ['KRS'], summary: 'Daftar KRS milik mahasiswa yang login (dosen bisa filter ?uid=)', security: [['bearerAuth' => []]], parameters: [new OAT\Parameter(name: 'uid', in: 'query', schema: new OAT\Schema(type: 'string'))], responses: [new OAT\Response(response: 200, description: 'Daftar KRS beserta mata kuliahnya')])]
#[OAT\Post(
    path: '/api/krs',
    tags: ['KRS'],
    summary: 'Buat KRS baru beserta daftar mata kuliah (mahasiswa)',
    security: [['bearerAuth' => []]],
    requestBody: new OAT\RequestBody(
        required: true,
        content: new OAT\JsonContent(
            required: ['tahun_akademik', 'semester', 'mata_kuliah'],
            properties: [
                new OAT\Property(property: 'tahun_akademik', type: 'string'),
                new OAT\Property(property: 'semester', type: 'string'),
                new OAT\Property(property: 'mata_kuliah', type: 'array', items: new OAT\Items(ref: '#/components/schemas/MataKuliahKrs')),
            ]
        )
    ),
    responses: [
        new OAT\Response(response: 201, description: 'KRS berhasil dibuat', content: new OAT\JsonContent(ref: '#/components/schemas/Krs')),
        new OAT\Response(response: 403, description: 'Bukan role mahasiswa'),
    ]
)]
#[OAT\Get(path: '/api/krs/{id}', tags: ['KRS'], summary: 'Detail KRS beserta mata kuliahnya', security: [['bearerAuth' => []]], parameters: [new OAT\Parameter(name: 'id', in: 'path', required: true, schema: new OAT\Schema(type: 'integer'))], responses: [new OAT\Response(response: 200, description: 'Detail KRS', content: new OAT\JsonContent(ref: '#/components/schemas/Krs')), new OAT\Response(response: 404, description: 'Tidak ditemukan')])]
#[OAT\Put(path: '/api/krs/{id}', tags: ['KRS'], summary: 'Ubah KRS (mengganti seluruh daftar mata kuliah jika dikirim)', security: [['bearerAuth' => []]], parameters: [new OAT\Parameter(name: 'id', in: 'path', required: true, schema: new OAT\Schema(type: 'integer'))], responses: [new OAT\Response(response: 200, description: 'Berhasil diubah')])]
#[OAT\Delete(path: '/api/krs/{id}', tags: ['KRS'], summary: 'Hapus KRS beserta mata kuliahnya', security: [['bearerAuth' => []]], parameters: [new OAT\Parameter(name: 'id', in: 'path', required: true, schema: new OAT\Schema(type: 'integer'))], responses: [new OAT\Response(response: 200, description: 'Berhasil dihapus')])]
#[OAT\Get(path: '/api/khs', tags: ['KHS'], summary: 'Daftar KHS milik mahasiswa yang login (dosen melihat semua)', security: [['bearerAuth' => []]], responses: [new OAT\Response(response: 200, description: 'Daftar KHS', content: new OAT\JsonContent(type: 'array', items: new OAT\Items(ref: '#/components/schemas/Khs')))])]
#[OAT\Post(path: '/api/khs', tags: ['KHS'], summary: 'Tambah nilai KHS (dosen)', security: [['bearerAuth' => []]], requestBody: new OAT\RequestBody(content: new OAT\JsonContent(ref: '#/components/schemas/Khs')), responses: [new OAT\Response(response: 201, description: 'Berhasil dibuat')])]
#[OAT\Get(path: '/api/khs/{id}', tags: ['KHS'], summary: 'Detail KHS', security: [['bearerAuth' => []]], parameters: [new OAT\Parameter(name: 'id', in: 'path', required: true, schema: new OAT\Schema(type: 'integer'))], responses: [new OAT\Response(response: 200, description: 'Detail KHS'), new OAT\Response(response: 404, description: 'Tidak ditemukan')])]
#[OAT\Put(path: '/api/khs/{id}', tags: ['KHS'], summary: 'Ubah nilai KHS (dosen)', security: [['bearerAuth' => []]], parameters: [new OAT\Parameter(name: 'id', in: 'path', required: true, schema: new OAT\Schema(type: 'integer'))], requestBody: new OAT\RequestBody(content: new OAT\JsonContent(ref: '#/components/schemas/Khs')), responses: [new OAT\Response(response: 200, description: 'Berhasil diubah')])]
#[OAT\Delete(path: '/api/khs/{id}', tags: ['KHS'], summary: 'Hapus KHS (dosen)', security: [['bearerAuth' => []]], parameters: [new OAT\Parameter(name: 'id', in: 'path', required: true, schema: new OAT\Schema(type: 'integer'))], responses: [new OAT\Response(response: 200, description: 'Berhasil dihapus')])]
class KrsKhsDocs
{
}
