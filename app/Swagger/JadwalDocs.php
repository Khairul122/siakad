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
#[OAT\Tag(name: 'Jadwal Kuliah', description: 'Jadwal kuliah milik mahasiswa — read-only, otomatis di-generate saat KRS disetujui dosen wali')]
#[OAT\Tag(name: 'Jadwal Mengajar', description: 'Jadwal mengajar milik dosen — read-only, diturunkan dari kelas_kuliah yang diampu')]
#[OAT\Get(path: '/api/jadwal-kuliah', tags: ['Jadwal Kuliah'], summary: 'Daftar jadwal kuliah milik mahasiswa yang login (dosen melihat semua). Muncul otomatis setelah KRS disetujui.', security: [['bearerAuth' => []]], responses: [new OAT\Response(response: 200, description: 'Daftar jadwal', content: new OAT\JsonContent(type: 'array', items: new OAT\Items(ref: '#/components/schemas/JadwalKuliah')))])]
#[OAT\Get(path: '/api/jadwal-kuliah/{id}', tags: ['Jadwal Kuliah'], summary: 'Detail jadwal kuliah', security: [['bearerAuth' => []]], parameters: [new OAT\Parameter(name: 'id', in: 'path', required: true, schema: new OAT\Schema(type: 'integer'))], responses: [new OAT\Response(response: 200, description: 'Detail jadwal'), new OAT\Response(response: 404, description: 'Tidak ditemukan')])]
#[OAT\Get(path: '/api/jadwal-mengajar', tags: ['Jadwal Mengajar'], summary: 'Daftar jadwal mengajar milik dosen yang login (diturunkan dari kelas_kuliah)', security: [['bearerAuth' => []]], responses: [new OAT\Response(response: 200, description: 'Daftar jadwal', content: new OAT\JsonContent(type: 'array', items: new OAT\Items(ref: '#/components/schemas/JadwalMengajar')))])]
#[OAT\Get(path: '/api/jadwal-mengajar/{id}', tags: ['Jadwal Mengajar'], summary: 'Detail jadwal mengajar', security: [['bearerAuth' => []]], parameters: [new OAT\Parameter(name: 'id', in: 'path', required: true, schema: new OAT\Schema(type: 'integer'))], responses: [new OAT\Response(response: 200, description: 'Detail jadwal'), new OAT\Response(response: 404, description: 'Tidak ditemukan')])]
class JadwalDocs
{
}
