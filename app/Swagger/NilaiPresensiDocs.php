<?php

namespace App\Swagger;

use OpenApi\Attributes as OAT;

#[OAT\Schema(
    schema: 'Nilai',
    properties: [
        new OAT\Property(property: 'id', type: 'integer'),
        new OAT\Property(property: 'kelas', type: 'string'),
        new OAT\Property(property: 'mahasiswa_uid', type: 'string'),
        new OAT\Property(property: 'nim', type: 'string'),
        new OAT\Property(property: 'nama', type: 'string'),
        new OAT\Property(property: 'tugas', type: 'integer'),
        new OAT\Property(property: 'uts', type: 'integer'),
        new OAT\Property(property: 'uas', type: 'integer'),
    ]
)]
#[OAT\Schema(
    schema: 'Presensi',
    properties: [
        new OAT\Property(property: 'id', type: 'integer'),
        new OAT\Property(property: 'kelas', type: 'string'),
        new OAT\Property(property: 'pertemuan', type: 'string'),
        new OAT\Property(property: 'mahasiswa_uid', type: 'string'),
        new OAT\Property(property: 'nim', type: 'string'),
        new OAT\Property(property: 'nama', type: 'string'),
        new OAT\Property(property: 'keterangan', type: 'string', enum: ['Hadir', 'Izin', 'Sakit', 'Alpha']),
    ]
)]
#[OAT\Tag(name: 'Nilai', description: 'Nilai tugas/UTS/UAS per kelas, diinput dosen')]
#[OAT\Tag(name: 'Presensi', description: 'Presensi per kelas & pertemuan, diinput dosen')]
#[OAT\Get(path: '/api/nilai', tags: ['Nilai'], summary: 'Daftar nilai (mahasiswa: milik sendiri, dosen: filter ?kelas=)', security: [['bearerAuth' => []]], parameters: [new OAT\Parameter(name: 'kelas', in: 'query', schema: new OAT\Schema(type: 'string'))], responses: [new OAT\Response(response: 200, description: 'Daftar nilai', content: new OAT\JsonContent(type: 'array', items: new OAT\Items(ref: '#/components/schemas/Nilai')))])]
#[OAT\Get(path: '/api/nilai/{kelas}/{mahasiswaUid}', tags: ['Nilai'], summary: 'Detail nilai satu mahasiswa di satu kelas', security: [['bearerAuth' => []]], parameters: [new OAT\Parameter(name: 'kelas', in: 'path', required: true, schema: new OAT\Schema(type: 'string')), new OAT\Parameter(name: 'mahasiswaUid', in: 'path', required: true, schema: new OAT\Schema(type: 'string'))], responses: [new OAT\Response(response: 200, description: 'Detail nilai'), new OAT\Response(response: 404, description: 'Tidak ditemukan')])]
#[OAT\Put(
    path: '/api/nilai/{kelas}/{mahasiswaUid}',
    tags: ['Nilai'],
    summary: 'Input/ubah nilai (upsert, hanya dosen)',
    security: [['bearerAuth' => []]],
    parameters: [
        new OAT\Parameter(name: 'kelas', in: 'path', required: true, schema: new OAT\Schema(type: 'string')),
        new OAT\Parameter(name: 'mahasiswaUid', in: 'path', required: true, schema: new OAT\Schema(type: 'string')),
    ],
    requestBody: new OAT\RequestBody(
        required: true,
        content: new OAT\JsonContent(
            required: ['tugas', 'uts', 'uas'],
            properties: [
                new OAT\Property(property: 'nim', type: 'string'),
                new OAT\Property(property: 'nama', type: 'string'),
                new OAT\Property(property: 'tugas', type: 'integer', minimum: 0, maximum: 100),
                new OAT\Property(property: 'uts', type: 'integer', minimum: 0, maximum: 100),
                new OAT\Property(property: 'uas', type: 'integer', minimum: 0, maximum: 100),
            ]
        )
    ),
    responses: [
        new OAT\Response(response: 200, description: 'Nilai berhasil disimpan', content: new OAT\JsonContent(ref: '#/components/schemas/Nilai')),
        new OAT\Response(response: 403, description: 'Bukan role dosen'),
    ]
)]
#[OAT\Delete(path: '/api/nilai/{kelas}/{mahasiswaUid}', tags: ['Nilai'], summary: 'Hapus nilai (dosen)', security: [['bearerAuth' => []]], parameters: [new OAT\Parameter(name: 'kelas', in: 'path', required: true, schema: new OAT\Schema(type: 'string')), new OAT\Parameter(name: 'mahasiswaUid', in: 'path', required: true, schema: new OAT\Schema(type: 'string'))], responses: [new OAT\Response(response: 200, description: 'Berhasil dihapus')])]
#[OAT\Get(path: '/api/presensi', tags: ['Presensi'], summary: 'Daftar presensi (mahasiswa: milik sendiri, dosen: filter ?kelas=&pertemuan=)', security: [['bearerAuth' => []]], parameters: [new OAT\Parameter(name: 'kelas', in: 'query', schema: new OAT\Schema(type: 'string')), new OAT\Parameter(name: 'pertemuan', in: 'query', schema: new OAT\Schema(type: 'string'))], responses: [new OAT\Response(response: 200, description: 'Daftar presensi', content: new OAT\JsonContent(type: 'array', items: new OAT\Items(ref: '#/components/schemas/Presensi')))])]
#[OAT\Get(path: '/api/presensi/{kelas}/{pertemuan}/{mahasiswaUid}', tags: ['Presensi'], summary: 'Detail presensi satu mahasiswa', security: [['bearerAuth' => []]], parameters: [new OAT\Parameter(name: 'kelas', in: 'path', required: true, schema: new OAT\Schema(type: 'string')), new OAT\Parameter(name: 'pertemuan', in: 'path', required: true, schema: new OAT\Schema(type: 'string')), new OAT\Parameter(name: 'mahasiswaUid', in: 'path', required: true, schema: new OAT\Schema(type: 'string'))], responses: [new OAT\Response(response: 200, description: 'Detail presensi'), new OAT\Response(response: 404, description: 'Tidak ditemukan')])]
#[OAT\Put(
    path: '/api/presensi/{kelas}/{pertemuan}/{mahasiswaUid}',
    tags: ['Presensi'],
    summary: 'Input/ubah presensi (upsert, hanya dosen)',
    security: [['bearerAuth' => []]],
    parameters: [
        new OAT\Parameter(name: 'kelas', in: 'path', required: true, schema: new OAT\Schema(type: 'string')),
        new OAT\Parameter(name: 'pertemuan', in: 'path', required: true, schema: new OAT\Schema(type: 'string')),
        new OAT\Parameter(name: 'mahasiswaUid', in: 'path', required: true, schema: new OAT\Schema(type: 'string')),
    ],
    requestBody: new OAT\RequestBody(
        required: true,
        content: new OAT\JsonContent(
            required: ['keterangan'],
            properties: [
                new OAT\Property(property: 'nim', type: 'string'),
                new OAT\Property(property: 'nama', type: 'string'),
                new OAT\Property(property: 'keterangan', type: 'string', enum: ['Hadir', 'Izin', 'Sakit', 'Alpha']),
            ]
        )
    ),
    responses: [
        new OAT\Response(response: 200, description: 'Presensi berhasil disimpan', content: new OAT\JsonContent(ref: '#/components/schemas/Presensi')),
        new OAT\Response(response: 403, description: 'Bukan role dosen'),
    ]
)]
#[OAT\Delete(path: '/api/presensi/{kelas}/{pertemuan}/{mahasiswaUid}', tags: ['Presensi'], summary: 'Hapus presensi (dosen)', security: [['bearerAuth' => []]], parameters: [new OAT\Parameter(name: 'kelas', in: 'path', required: true, schema: new OAT\Schema(type: 'string')), new OAT\Parameter(name: 'pertemuan', in: 'path', required: true, schema: new OAT\Schema(type: 'string')), new OAT\Parameter(name: 'mahasiswaUid', in: 'path', required: true, schema: new OAT\Schema(type: 'string'))], responses: [new OAT\Response(response: 200, description: 'Berhasil dihapus')])]
class NilaiPresensiDocs {}
