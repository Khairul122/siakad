<?php

namespace App\Swagger;

use OpenApi\Attributes as OAT;

#[OAT\Schema(
    schema: 'Mahasiswa',
    properties: [
        new OAT\Property(property: 'uid', type: 'string'),
        new OAT\Property(property: 'nama', type: 'string'),
        new OAT\Property(property: 'nim', type: 'string'),
        new OAT\Property(property: 'email', type: 'string', format: 'email'),
        new OAT\Property(property: 'no_hp', type: 'string'),
        new OAT\Property(property: 'tanggal_lahir', type: 'string'),
        new OAT\Property(property: 'alamat', type: 'string'),
        new OAT\Property(property: 'photo_url', type: 'string'),
        new OAT\Property(property: 'kelas', type: 'string'),
        new OAT\Property(property: 'angkatan', type: 'string'),
        new OAT\Property(property: 'prodi', type: 'string'),
        new OAT\Property(property: 'dosen_pembimbing_uid', type: 'string', nullable: true),
    ]
)]
#[OAT\Tag(name: 'Mahasiswa', description: 'Profil mahasiswa')]
#[OAT\Get(
    path: '/api/mahasiswa',
    tags: ['Mahasiswa'],
    summary: 'Daftar semua mahasiswa (khusus dosen)',
    security: [['bearerAuth' => []]],
    parameters: [
        new OAT\Parameter(name: 'dosen_pembimbing_uid', in: 'query', schema: new OAT\Schema(type: 'string')),
        new OAT\Parameter(name: 'kelas', in: 'query', schema: new OAT\Schema(type: 'string')),
    ],
    responses: [
        new OAT\Response(response: 200, description: 'Daftar mahasiswa'),
        new OAT\Response(response: 403, description: 'Bukan role dosen'),
    ]
)]
#[OAT\Get(
    path: '/api/mahasiswa/{uid}',
    tags: ['Mahasiswa'],
    summary: 'Detail profil mahasiswa (diri sendiri atau oleh dosen)',
    security: [['bearerAuth' => []]],
    parameters: [new OAT\Parameter(name: 'uid', in: 'path', required: true, schema: new OAT\Schema(type: 'string'))],
    responses: [
        new OAT\Response(response: 200, description: 'Detail mahasiswa', content: new OAT\JsonContent(ref: '#/components/schemas/Mahasiswa')),
        new OAT\Response(response: 403, description: 'Akses ditolak'),
        new OAT\Response(response: 404, description: 'Tidak ditemukan'),
    ]
)]
#[OAT\Put(
    path: '/api/mahasiswa/{uid}',
    tags: ['Mahasiswa'],
    summary: 'Ubah profil mahasiswa (hanya pemilik akun)',
    security: [['bearerAuth' => []]],
    requestBody: new OAT\RequestBody(content: new OAT\JsonContent(ref: '#/components/schemas/Mahasiswa')),
    parameters: [new OAT\Parameter(name: 'uid', in: 'path', required: true, schema: new OAT\Schema(type: 'string'))],
    responses: [
        new OAT\Response(response: 200, description: 'Berhasil diubah'),
        new OAT\Response(response: 403, description: 'Bukan pemilik akun'),
    ]
)]
#[OAT\Delete(
    path: '/api/mahasiswa/{uid}',
    tags: ['Mahasiswa'],
    summary: 'Hapus akun mahasiswa (hanya pemilik akun)',
    security: [['bearerAuth' => []]],
    parameters: [new OAT\Parameter(name: 'uid', in: 'path', required: true, schema: new OAT\Schema(type: 'string'))],
    responses: [
        new OAT\Response(response: 200, description: 'Berhasil dihapus'),
        new OAT\Response(response: 403, description: 'Bukan pemilik akun'),
    ]
)]
class MahasiswaDocs
{
}
