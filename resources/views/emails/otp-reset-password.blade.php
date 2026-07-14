<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="utf-8">
    <title>Kode OTP Reset Password</title>
</head>
<body style="margin:0; padding:0; background-color:#f4f5f7; font-family: Arial, Helvetica, sans-serif;">
    <table role="presentation" width="100%" cellpadding="0" cellspacing="0" style="background-color:#f4f5f7; padding:32px 0;">
        <tr>
            <td align="center">
                <table role="presentation" width="480" cellpadding="0" cellspacing="0" style="background-color:#ffffff; border-radius:12px; overflow:hidden;">
                    <tr>
                        <td style="background-color:#0d6efd; padding:24px 32px;">
                            <span style="color:#ffffff; font-size:18px; font-weight:bold;">SIAKAD - Sistem Informasi Akademik</span>
                        </td>
                    </tr>
                    <tr>
                        <td style="padding:32px;">
                            <p style="font-size:15px; color:#333333; margin:0 0 16px;">Halo,</p>
                            <p style="font-size:15px; color:#333333; margin:0 0 24px;">
                                Kami menerima permintaan reset password untuk akun Anda. Gunakan kode OTP berikut untuk melanjutkan:
                            </p>
                            <div style="text-align:center; margin:0 0 24px;">
                                <span style="display:inline-block; padding:14px 32px; font-size:32px; letter-spacing:8px; font-weight:bold; color:#0d6efd; background-color:#eef4ff; border-radius:10px;">
                                    {{ $otp }}
                                </span>
                            </div>
                            <p style="font-size:14px; color:#666666; margin:0 0 8px;">
                                Kode ini berlaku selama <strong>{{ $ttlMinutes }} menit</strong> dan hanya bisa digunakan satu kali.
                            </p>
                            <p style="font-size:14px; color:#666666; margin:0;">
                                Jika Anda tidak merasa meminta reset password, abaikan email ini — password Anda tidak akan berubah.
                            </p>
                        </td>
                    </tr>
                    <tr>
                        <td style="padding:16px 32px; background-color:#f4f5f7;">
                            <p style="font-size:12px; color:#999999; margin:0;">Email ini dikirim otomatis, mohon tidak membalas.</p>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</body>
</html>
