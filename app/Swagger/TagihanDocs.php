<?php

namespace App\Swagger;

use OpenApi\Attributes as OAT;

#[OAT\Schema(
    schema: 'Tagihan',
    properties: [
        new OAT\Property(property: 'id', type: 'integer'),
        new OAT\Property(property: 'uid', type: 'string'),
        new OAT\Property(property: 'jenis', type: 'string'),
        new OAT\Property(property: 'nominal', type: 'number', format: 'float'),
        new OAT\Property(property: 'status', type: 'string', enum: ['Belum Dibayar', 'Menunggu Konfirmasi', 'Lunas']),
        new OAT\Property(property: 'jatuh_tempo', type: 'string', format: 'date'),
        new OAT\Property(property: 'metode_pembayaran', type: 'string'),
        new OAT\Property(property: 'bank_tujuan', type: 'string'),
        new OAT\Property(property: 'no_rekening', type: 'string'),
        new OAT\Property(property: 'bukti_url', type: 'string'),
        new OAT\Property(property: 'catatan', type: 'string'),
    ]
)]
#[OAT\Tag(name: 'Tagihan', description: 'Tagihan & pembayaran mahasiswa')]
#[OAT\Get(path: '/api/tagihan', tags: ['Tagihan'], summary: 'Daftar tagihan (mahasiswa: milik sendiri, dosen: filter ?uid=&status=)', security: [['bearerAuth' => []]], parameters: [new OAT\Parameter(name: 'uid', in: 'query', schema: new OAT\Schema(type: 'string')), new OAT\Parameter(name: 'status', in: 'query', schema: new OAT\Schema(type: 'string'))], responses: [new OAT\Response(response: 200, description: 'Daftar tagihan', content: new OAT\JsonContent(type: 'array', items: new OAT\Items(ref: '#/components/schemas/Tagihan')))])]
#[OAT\Post(path: '/api/tagihan', tags: ['Tagihan'], summary: 'Buat tagihan baru (dosen/staf)', security: [['bearerAuth' => []]], requestBody: new OAT\RequestBody(content: new OAT\JsonContent(ref: '#/components/schemas/Tagihan')), responses: [new OAT\Response(response: 201, description: 'Berhasil dibuat')])]
#[OAT\Get(path: '/api/tagihan/{id}', tags: ['Tagihan'], summary: 'Detail tagihan', security: [['bearerAuth' => []]], parameters: [new OAT\Parameter(name: 'id', in: 'path', required: true, schema: new OAT\Schema(type: 'integer'))], responses: [new OAT\Response(response: 200, description: 'Detail tagihan'), new OAT\Response(response: 404, description: 'Tidak ditemukan')])]
#[OAT\Put(path: '/api/tagihan/{id}', tags: ['Tagihan'], summary: 'Ubah tagihan (dosen/staf)', security: [['bearerAuth' => []]], parameters: [new OAT\Parameter(name: 'id', in: 'path', required: true, schema: new OAT\Schema(type: 'integer'))], requestBody: new OAT\RequestBody(content: new OAT\JsonContent(ref: '#/components/schemas/Tagihan')), responses: [new OAT\Response(response: 200, description: 'Berhasil diubah')])]
#[OAT\Delete(path: '/api/tagihan/{id}', tags: ['Tagihan'], summary: 'Hapus tagihan (dosen/staf)', security: [['bearerAuth' => []]], parameters: [new OAT\Parameter(name: 'id', in: 'path', required: true, schema: new OAT\Schema(type: 'integer'))], responses: [new OAT\Response(response: 200, description: 'Berhasil dihapus')])]
#[OAT\Post(
    path: '/api/tagihan/{id}/konfirmasi',
    tags: ['Tagihan'],
    summary: 'Mahasiswa mengonfirmasi pembayaran (upload bukti)',
    security: [['bearerAuth' => []]],
    parameters: [new OAT\Parameter(name: 'id', in: 'path', required: true, schema: new OAT\Schema(type: 'integer'))],
    requestBody: new OAT\RequestBody(
        required: true,
        content: new OAT\JsonContent(required: ['bukti_url'], properties: [
            new OAT\Property(property: 'bukti_url', type: 'string'),
            new OAT\Property(property: 'catatan', type: 'string'),
        ])
    ),
    responses: [new OAT\Response(response: 200, description: 'Status berubah ke Menunggu Konfirmasi')]
)]
#[OAT\Post(
    path: '/api/tagihan/{id}/lunas',
    tags: ['Tagihan'],
    summary: 'Dosen/staf menandai tagihan lunas',
    security: [['bearerAuth' => []]],
    parameters: [new OAT\Parameter(name: 'id', in: 'path', required: true, schema: new OAT\Schema(type: 'integer'))],
    responses: [new OAT\Response(response: 200, description: 'Status berubah ke Lunas')]
)]
class TagihanDocs
{
}
