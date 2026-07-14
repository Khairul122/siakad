<?php

namespace App\Services;

use Illuminate\Support\Facades\Http;
use RuntimeException;

/**
 * Kirim email lewat Brevo (dulu Sendinblue) HTTP API — dipakai sebagai
 * pengganti SMTP karena port SMTP (587/465/25) sering diblokir jaringan/ISP,
 * sementara HTTPS (443) tidak. Pengirim tetap bisa memakai alamat Gmail biasa
 * (mis. sabrisiraj46@gmail.com), asal sudah diverifikasi sebagai "sender" di
 * dashboard Brevo (verifikasi cukup klik link dari email, tanpa OAuth/DNS).
 */
class BrevoMailer
{
    private const SEND_URL = 'https://api.brevo.com/v3/smtp/email';

    public function send(string $to, string $subject, string $html): void
    {
        $apiKey = config('services.brevo.key');
        $senderEmail = config('services.brevo.sender_email');
        $senderName = config('services.brevo.sender_name', 'SIAKAD');

        if (!$apiKey || !$senderEmail) {
            throw new RuntimeException('Kredensial Brevo (key/sender_email) belum diisi di .env');
        }

        $response = Http::withHeaders([
            'api-key' => $apiKey,
            'Accept' => 'application/json',
        ])->timeout(15)->post(self::SEND_URL, [
            'sender' => ['email' => $senderEmail, 'name' => $senderName],
            'to' => [['email' => $to]],
            'subject' => $subject,
            'htmlContent' => $html,
        ]);

        if (!$response->successful()) {
            throw new RuntimeException(
                'Brevo gagal mengirim email: '.$response->status().' '.$response->body()
            );
        }
    }
}
