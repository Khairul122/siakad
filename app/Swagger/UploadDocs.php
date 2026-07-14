<?php

namespace App\Swagger;

use OpenApi\Attributes as OAT;

#[OAT\Tag(name: 'Upload', description: 'Upload file generik (foto profil, bukti pembayaran, dll)')]
#[OAT\Post(
    path: '/api/uploads',
    tags: ['Upload'],
    summary: 'Upload file gambar dan dapatkan URL publiknya',
    security: [['bearerAuth' => []]],
    requestBody: new OAT\RequestBody(
        required: true,
        content: new OAT\MediaType(
            mediaType: 'multipart/form-data',
            schema: new OAT\Schema(
                required: ['file'],
                properties: [
                    new OAT\Property(property: 'file', type: 'string', format: 'binary'),
                    new OAT\Property(property: 'folder', type: 'string', example: 'profil'),
                ]
            )
        )
    ),
    responses: [
        new OAT\Response(
            response: 201,
            description: 'Berhasil diunggah',
            content: new OAT\JsonContent(properties: [new OAT\Property(property: 'url', type: 'string')])
        ),
        new OAT\Response(response: 422, description: 'Validasi gagal (bukan gambar / lebih dari 5MB)'),
    ]
)]
class UploadDocs {}
