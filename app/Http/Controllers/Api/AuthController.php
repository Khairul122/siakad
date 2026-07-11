<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Dosen;
use App\Models\Mahasiswa;
use App\Models\OtpRequest;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use OpenApi\Attributes as OAT;

#[OAT\Tag(name: 'Auth', description: 'Registrasi, login, dan reset password mandiri (JWT)')]
class AuthController extends Controller
{
    #[OAT\Post(
        path: '/api/auth/register',
        tags: ['Auth'],
        summary: 'Registrasi akun mahasiswa atau dosen baru',
        requestBody: new OAT\RequestBody(
            required: true,
            content: new OAT\JsonContent(
                required: ['role', 'uid', 'nama', 'email', 'password'],
                properties: [
                    new OAT\Property(property: 'role', type: 'string', enum: ['mahasiswa', 'dosen']),
                    new OAT\Property(property: 'uid', type: 'string', example: 'mhs-001'),
                    new OAT\Property(property: 'nama', type: 'string'),
                    new OAT\Property(property: 'email', type: 'string', format: 'email'),
                    new OAT\Property(property: 'password', type: 'string', format: 'password', minLength: 6),
                    new OAT\Property(property: 'nim', type: 'string', description: 'wajib jika role=mahasiswa'),
                    new OAT\Property(property: 'nip', type: 'string', description: 'opsional jika role=dosen'),
                ]
            )
        ),
        responses: [
            new OAT\Response(response: 201, description: 'Berhasil didaftarkan'),
            new OAT\Response(response: 422, description: 'Validasi gagal'),
        ]
    )]
    public function register(Request $request): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'role' => ['required', 'in:mahasiswa,dosen'],
            'uid' => ['required', 'string', 'max:128'],
            'nama' => ['required', 'string', 'max:255'],
            'email' => ['required', 'email', 'max:255'],
            'password' => ['required', 'string', 'min:6'],
            'nim' => ['nullable', 'string', 'max:50'],
            'nip' => ['nullable', 'string', 'max:50'],
        ]);

        if ($validator->fails()) {
            return response()->json(['message' => 'Validasi gagal', 'errors' => $validator->errors()], 422);
        }

        $data = $validator->validated();

        if ($data['role'] === 'mahasiswa') {
            if (Mahasiswa::where('email', $data['email'])->orWhere('uid', $data['uid'])->exists()) {
                return response()->json(['message' => 'Email atau UID sudah terdaftar'], 422);
            }

            $mahasiswa = Mahasiswa::create([
                'uid' => $data['uid'],
                'nama' => $data['nama'],
                'nim' => $data['nim'] ?? null,
                'email' => $data['email'],
                'password' => Hash::make($data['password']),
            ]);

            return response()->json($mahasiswa, 201);
        }

        if (Dosen::where('email', $data['email'])->orWhere('uid', $data['uid'])->exists()) {
            return response()->json(['message' => 'Email atau UID sudah terdaftar'], 422);
        }

        $dosen = Dosen::create([
            'uid' => $data['uid'],
            'nama' => $data['nama'],
            'nip' => $data['nip'] ?? null,
            'email' => $data['email'],
            'password' => Hash::make($data['password']),
        ]);

        return response()->json($dosen, 201);
    }

    #[OAT\Post(
        path: '/api/auth/login',
        tags: ['Auth'],
        summary: 'Login dan menerbitkan JWT',
        requestBody: new OAT\RequestBody(
            required: true,
            content: new OAT\JsonContent(
                required: ['role', 'email', 'password'],
                properties: [
                    new OAT\Property(property: 'role', type: 'string', enum: ['mahasiswa', 'dosen']),
                    new OAT\Property(property: 'email', type: 'string', format: 'email'),
                    new OAT\Property(property: 'password', type: 'string', format: 'password'),
                ]
            )
        ),
        responses: [
            new OAT\Response(response: 200, description: 'Berhasil login, mengembalikan access_token'),
            new OAT\Response(response: 401, description: 'Email atau password salah'),
        ]
    )]
    public function login(Request $request): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'role' => ['required', 'in:mahasiswa,dosen'],
            'email' => ['required', 'email'],
            'password' => ['required', 'string'],
        ]);

        if ($validator->fails()) {
            return response()->json(['message' => 'Validasi gagal', 'errors' => $validator->errors()], 422);
        }

        $role = $request->input('role');
        $modelClass = $role === 'mahasiswa' ? Mahasiswa::class : Dosen::class;
        $user = $modelClass::where('email', $request->input('email'))->first();

        if (!$user || !Hash::check($request->input('password'), $user->password)) {
            return response()->json(['message' => 'Email atau password salah'], 401);
        }

        $token = auth($role)->login($user);

        return response()->json([
            'access_token' => $token,
            'token_type' => 'bearer',
            'expires_in' => auth($role)->factory()->getTTL() * 60,
            'role' => $role,
            'user' => $user,
        ]);
    }

    #[OAT\Get(
        path: '/api/auth/me',
        tags: ['Auth'],
        summary: 'Profil user yang sedang login',
        security: [['bearerAuth' => []]],
        responses: [
            new OAT\Response(response: 200, description: 'Data user saat ini'),
            new OAT\Response(response: 401, description: 'Token tidak valid'),
        ]
    )]
    public function me(Request $request): JsonResponse
    {
        return response()->json([
            'role' => $request->attributes->get('auth_role'),
            'user' => $request->attributes->get('auth_user'),
        ]);
    }

    #[OAT\Post(
        path: '/api/auth/forgot-password',
        tags: ['Auth'],
        summary: 'Minta kode OTP reset password (belum terintegrasi pengiriman email nyata)',
        requestBody: new OAT\RequestBody(
            required: true,
            content: new OAT\JsonContent(
                required: ['email'],
                properties: [new OAT\Property(property: 'email', type: 'string', format: 'email')]
            )
        ),
        responses: [
            new OAT\Response(response: 200, description: 'OTP dibuat. Di lingkungan non-production, OTP dikembalikan langsung di response sebagai placeholder karena belum ada integrasi email.'),
        ]
    )]
    public function forgotPassword(Request $request): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'email' => ['required', 'email'],
        ]);

        if ($validator->fails()) {
            return response()->json(['message' => 'Validasi gagal', 'errors' => $validator->errors()], 422);
        }

        $email = $request->input('email');
        $existsAsUser = Mahasiswa::where('email', $email)->exists() || Dosen::where('email', $email)->exists();

        if (!$existsAsUser) {
            return response()->json(['message' => 'Email tidak terdaftar'], 404);
        }

        $otp = (string) random_int(1000, 9999);

        OtpRequest::updateOrCreate(
            ['email' => $email],
            [
                'otp' => $otp,
                'expired_at' => now()->addMinutes(10)->getTimestampMs(),
                'used' => false,
            ]
        );

        $response = ['message' => 'Kode OTP dibuat, berlaku 10 menit.'];

        if (!app()->environment('production')) {
            $response['otp_dev_only'] = $otp;
        }

        return response()->json($response);
    }

    #[OAT\Post(
        path: '/api/auth/reset-password',
        tags: ['Auth'],
        summary: 'Reset password memakai kode OTP',
        requestBody: new OAT\RequestBody(
            required: true,
            content: new OAT\JsonContent(
                required: ['email', 'otp', 'password'],
                properties: [
                    new OAT\Property(property: 'email', type: 'string', format: 'email'),
                    new OAT\Property(property: 'otp', type: 'string'),
                    new OAT\Property(property: 'password', type: 'string', format: 'password', minLength: 6),
                ]
            )
        ),
        responses: [
            new OAT\Response(response: 200, description: 'Password berhasil diperbarui'),
            new OAT\Response(response: 400, description: 'OTP salah/kadaluwarsa/sudah dipakai'),
        ]
    )]
    public function resetPassword(Request $request): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'email' => ['required', 'email'],
            'otp' => ['required', 'string'],
            'password' => ['required', 'string', 'min:6'],
        ]);

        if ($validator->fails()) {
            return response()->json(['message' => 'Validasi gagal', 'errors' => $validator->errors()], 422);
        }

        $email = $request->input('email');
        $otpRequest = OtpRequest::where('email', $email)->first();

        if (!$otpRequest) {
            return response()->json(['message' => 'Kode OTP tidak ditemukan'], 400);
        }

        if ($otpRequest->used) {
            return response()->json(['message' => 'Kode OTP sudah digunakan'], 400);
        }

        if (now()->getTimestampMs() > $otpRequest->expired_at) {
            return response()->json(['message' => 'Kode OTP sudah kadaluwarsa'], 400);
        }

        if ($otpRequest->otp !== $request->input('otp')) {
            return response()->json(['message' => 'Kode OTP salah'], 400);
        }

        $hashed = Hash::make($request->input('password'));
        $updated = Mahasiswa::where('email', $email)->update(['password' => $hashed]);

        if (!$updated) {
            Dosen::where('email', $email)->update(['password' => $hashed]);
        }

        $otpRequest->update(['used' => true]);

        return response()->json(['message' => 'Password berhasil diperbarui']);
    }

    #[OAT\Post(
        path: '/api/auth/change-password',
        tags: ['Auth'],
        summary: 'Ganti password untuk user yang sedang login (verifikasi password lama)',
        security: [['bearerAuth' => []]],
        requestBody: new OAT\RequestBody(
            required: true,
            content: new OAT\JsonContent(
                required: ['old_password', 'new_password'],
                properties: [
                    new OAT\Property(property: 'old_password', type: 'string', format: 'password'),
                    new OAT\Property(property: 'new_password', type: 'string', format: 'password', minLength: 6),
                ]
            )
        ),
        responses: [
            new OAT\Response(response: 200, description: 'Password berhasil diperbarui'),
            new OAT\Response(response: 400, description: 'Password lama salah'),
        ]
    )]
    public function changePassword(Request $request): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'old_password' => ['required', 'string'],
            'new_password' => ['required', 'string', 'min:6'],
        ]);

        if ($validator->fails()) {
            return response()->json(['message' => 'Validasi gagal', 'errors' => $validator->errors()], 422);
        }

        $user = $request->attributes->get('auth_user');

        if (!Hash::check($request->input('old_password'), $user->password)) {
            return response()->json(['message' => 'Password lama salah'], 400);
        }

        $user->update(['password' => Hash::make($request->input('new_password'))]);

        return response()->json(['message' => 'Password berhasil diperbarui']);
    }
}
