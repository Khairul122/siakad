<?php

namespace App\Swagger;

use OpenApi\Attributes as OAT;

#[OAT\Schema(
    schema: 'MataKuliahKrs',
    properties: [
        new OAT\Property(property: 'kelas_kuliah_id', type: 'integer'),
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
        new OAT\Property(property: 'status', type: 'string', enum: ['diajukan', 'disetujui', 'ditolak']),
        new OAT\Property(property: 'catatan_dosen', type: 'string', nullable: true),
        new OAT\Property(property: 'disetujui_oleh', type: 'string', nullable: true),
        new OAT\Property(property: 'disetujui_at', type: 'string', nullable: true),
        new OAT\Property(property: 'mata_kuliah', type: 'array', items: new OAT\Items(ref: '#/components/schemas/MataKuliahKrs')),
    ]
)]
#[OAT\Schema(
    schema: 'MataKuliah',
    properties: [
        new OAT\Property(property: 'id', type: 'integer'),
        new OAT\Property(property: 'kode', type: 'string'),
        new OAT\Property(property: 'nama', type: 'string'),
        new OAT\Property(property: 'sks', type: 'integer'),
        new OAT\Property(property: 'prodi', type: 'string'),
        new OAT\Property(property: 'semester_ke', type: 'integer'),
    ]
)]
#[OAT\Schema(
    schema: 'KelasKuliah',
    properties: [
        new OAT\Property(property: 'id', type: 'integer'),
        new OAT\Property(property: 'mata_kuliah_id', type: 'integer'),
        new OAT\Property(property: 'dosen_uid', type: 'string', nullable: true),
        new OAT\Property(property: 'nama_kelas', type: 'string'),
        new OAT\Property(property: 'hari', type: 'string'),
        new OAT\Property(property: 'jam_mulai', type: 'string'),
        new OAT\Property(property: 'jam_selesai', type: 'string'),
        new OAT\Property(property: 'ruangan', type: 'string'),
        new OAT\Property(property: 'kuota', type: 'integer'),
        new OAT\Property(property: 'tahun_akademik', type: 'string'),
        new OAT\Property(property: 'semester', type: 'string'),
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
#[OAT\Tag(name: 'Mata Kuliah', description: 'Master kurikulum mata kuliah')]
#[OAT\Tag(name: 'Kelas Kuliah', description: 'Penawaran kelas per periode — dipilih mahasiswa saat mengisi KRS')]
#[OAT\Tag(name: 'KRS', description: 'Kartu Rencana Studi mahasiswa: pilih kelas kuliah, divalidasi kuota SKS, disetujui/ditolak dosen wali')]
#[OAT\Tag(name: 'KHS', description: 'Kartu Hasil Studi mahasiswa (diisi dosen)')]
#[OAT\Get(path: '/api/mata-kuliah', tags: ['Mata Kuliah'], summary: 'Daftar master mata kuliah (filter opsional ?prodi= & ?semester_ke=)', security: [['bearerAuth' => []]], responses: [new OAT\Response(response: 200, description: 'Daftar mata kuliah', content: new OAT\JsonContent(type: 'array', items: new OAT\Items(ref: '#/components/schemas/MataKuliah')))])]
#[OAT\Get(path: '/api/mata-kuliah/{id}', tags: ['Mata Kuliah'], summary: 'Detail mata kuliah', security: [['bearerAuth' => []]], parameters: [new OAT\Parameter(name: 'id', in: 'path', required: true, schema: new OAT\Schema(type: 'integer'))], responses: [new OAT\Response(response: 200, description: 'Detail mata kuliah'), new OAT\Response(response: 404, description: 'Tidak ditemukan')])]
#[OAT\Get(path: '/api/kelas-kuliah', tags: ['Kelas Kuliah'], summary: 'Daftar kelas kuliah ditawarkan (filter opsional ?tahun_akademik= & ?semester= & ?prodi=)', security: [['bearerAuth' => []]], responses: [new OAT\Response(response: 200, description: 'Daftar kelas kuliah', content: new OAT\JsonContent(type: 'array', items: new OAT\Items(ref: '#/components/schemas/KelasKuliah')))])]
#[OAT\Get(path: '/api/kelas-kuliah/{id}', tags: ['Kelas Kuliah'], summary: 'Detail kelas kuliah', security: [['bearerAuth' => []]], parameters: [new OAT\Parameter(name: 'id', in: 'path', required: true, schema: new OAT\Schema(type: 'integer'))], responses: [new OAT\Response(response: 200, description: 'Detail kelas kuliah'), new OAT\Response(response: 404, description: 'Tidak ditemukan')])]
#[OAT\Get(path: '/api/krs', tags: ['KRS'], summary: 'Daftar KRS milik mahasiswa yang login (dosen otomatis dibatasi ke mahasiswa bimbingannya, filter opsional ?status= & ?uid=)', security: [['bearerAuth' => []]], parameters: [new OAT\Parameter(name: 'uid', in: 'query', schema: new OAT\Schema(type: 'string')), new OAT\Parameter(name: 'status', in: 'query', schema: new OAT\Schema(type: 'string'))], responses: [new OAT\Response(response: 200, description: 'Daftar KRS beserta mata kuliahnya')])]
#[OAT\Post(
    path: '/api/krs',
    tags: ['KRS'],
    summary: 'Ajukan KRS baru dari daftar kelas_kuliah_ids (mahasiswa) — divalidasi kuota SKS & bentrok jadwal',
    security: [['bearerAuth' => []]],
    requestBody: new OAT\RequestBody(
        required: true,
        content: new OAT\JsonContent(
            required: ['tahun_akademik', 'semester', 'kelas_kuliah_ids'],
            properties: [
                new OAT\Property(property: 'tahun_akademik', type: 'string'),
                new OAT\Property(property: 'semester', type: 'string'),
                new OAT\Property(property: 'kelas_kuliah_ids', type: 'array', items: new OAT\Items(type: 'integer')),
            ]
        )
    ),
    responses: [
        new OAT\Response(response: 201, description: 'KRS berhasil diajukan', content: new OAT\JsonContent(ref: '#/components/schemas/Krs')),
        new OAT\Response(response: 422, description: 'Melebihi kuota SKS / jadwal bentrok'),
        new OAT\Response(response: 403, description: 'Bukan role mahasiswa'),
    ]
)]
#[OAT\Get(path: '/api/krs/{id}', tags: ['KRS'], summary: 'Detail KRS beserta mata kuliahnya', security: [['bearerAuth' => []]], parameters: [new OAT\Parameter(name: 'id', in: 'path', required: true, schema: new OAT\Schema(type: 'integer'))], responses: [new OAT\Response(response: 200, description: 'Detail KRS', content: new OAT\JsonContent(ref: '#/components/schemas/Krs')), new OAT\Response(response: 404, description: 'Tidak ditemukan')])]
#[OAT\Put(path: '/api/krs/{id}', tags: ['KRS'], summary: 'Ubah KRS (ganti seluruh kelas_kuliah_ids), hanya bila status belum disetujui', security: [['bearerAuth' => []]], parameters: [new OAT\Parameter(name: 'id', in: 'path', required: true, schema: new OAT\Schema(type: 'integer'))], responses: [new OAT\Response(response: 200, description: 'Berhasil diubah'), new OAT\Response(response: 422, description: 'KRS sudah disetujui')])]
#[OAT\Delete(path: '/api/krs/{id}', tags: ['KRS'], summary: 'Hapus KRS beserta mata kuliahnya', security: [['bearerAuth' => []]], parameters: [new OAT\Parameter(name: 'id', in: 'path', required: true, schema: new OAT\Schema(type: 'integer'))], responses: [new OAT\Response(response: 200, description: 'Berhasil dihapus')])]
#[OAT\Post(path: '/api/krs/{id}/approve', tags: ['KRS'], summary: 'Setujui KRS (dosen wali mahasiswa ybs) — otomatis generate jadwal kuliah', security: [['bearerAuth' => []]], parameters: [new OAT\Parameter(name: 'id', in: 'path', required: true, schema: new OAT\Schema(type: 'integer'))], responses: [new OAT\Response(response: 200, description: 'KRS disetujui'), new OAT\Response(response: 403, description: 'Bukan dosen pembimbing mahasiswa ini')])]
#[OAT\Post(path: '/api/krs/{id}/reject', tags: ['KRS'], summary: 'Tolak KRS (dosen wali mahasiswa ybs), wajib sertakan catatan', security: [['bearerAuth' => []]], parameters: [new OAT\Parameter(name: 'id', in: 'path', required: true, schema: new OAT\Schema(type: 'integer'))], requestBody: new OAT\RequestBody(required: true, content: new OAT\JsonContent(required: ['catatan'], properties: [new OAT\Property(property: 'catatan', type: 'string')])), responses: [new OAT\Response(response: 200, description: 'KRS ditolak'), new OAT\Response(response: 403, description: 'Bukan dosen pembimbing mahasiswa ini')])]
#[OAT\Get(path: '/api/khs', tags: ['KHS'], summary: 'Daftar KHS milik mahasiswa yang login (dosen melihat semua)', security: [['bearerAuth' => []]], responses: [new OAT\Response(response: 200, description: 'Daftar KHS', content: new OAT\JsonContent(type: 'array', items: new OAT\Items(ref: '#/components/schemas/Khs')))])]
#[OAT\Post(path: '/api/khs', tags: ['KHS'], summary: 'Tambah nilai KHS (dosen)', security: [['bearerAuth' => []]], requestBody: new OAT\RequestBody(content: new OAT\JsonContent(ref: '#/components/schemas/Khs')), responses: [new OAT\Response(response: 201, description: 'Berhasil dibuat')])]
#[OAT\Get(path: '/api/khs/{id}', tags: ['KHS'], summary: 'Detail KHS', security: [['bearerAuth' => []]], parameters: [new OAT\Parameter(name: 'id', in: 'path', required: true, schema: new OAT\Schema(type: 'integer'))], responses: [new OAT\Response(response: 200, description: 'Detail KHS'), new OAT\Response(response: 404, description: 'Tidak ditemukan')])]
#[OAT\Put(path: '/api/khs/{id}', tags: ['KHS'], summary: 'Ubah nilai KHS (dosen)', security: [['bearerAuth' => []]], parameters: [new OAT\Parameter(name: 'id', in: 'path', required: true, schema: new OAT\Schema(type: 'integer'))], requestBody: new OAT\RequestBody(content: new OAT\JsonContent(ref: '#/components/schemas/Khs')), responses: [new OAT\Response(response: 200, description: 'Berhasil diubah')])]
#[OAT\Delete(path: '/api/khs/{id}', tags: ['KHS'], summary: 'Hapus KHS (dosen)', security: [['bearerAuth' => []]], parameters: [new OAT\Parameter(name: 'id', in: 'path', required: true, schema: new OAT\Schema(type: 'integer'))], responses: [new OAT\Response(response: 200, description: 'Berhasil dihapus')])]
class KrsKhsDocs {}
