<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Kegiatan;
use App\Models\PendaftaranKegiatan;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class PendaftaranKegiatanController extends Controller
{
    public function store(Request $request, int $kegiatanId): JsonResponse
    {
        if ($request->attributes->get('auth_role') !== 'mahasiswa') {
            return response()->json(['message' => 'Hanya mahasiswa yang bisa mendaftar kegiatan'], 403);
        }

        $kegiatan = Kegiatan::withCount('pendaftaran')->find($kegiatanId);

        if (! $kegiatan) {
            return response()->json(['message' => 'Kegiatan tidak ditemukan'], 404);
        }

        $uid = $request->attributes->get('auth_user')->uid;

        if (PendaftaranKegiatan::where('kegiatan_id', $kegiatanId)->where('uid', $uid)->exists()) {
            return response()->json(['message' => 'Anda sudah terdaftar di kegiatan ini'], 422);
        }

        $kuota = is_numeric($kegiatan->kuota) ? (int) $kegiatan->kuota : null;

        if ($kuota !== null && $kegiatan->pendaftaran_count >= $kuota) {
            return response()->json(['message' => 'Kuota kegiatan sudah penuh'], 422);
        }

        $validator = Validator::make($request->all(), [
            'nama' => ['required', 'string', 'max:255'],
            'nim' => ['required', 'string', 'max:50'],
            'prodi' => ['nullable', 'string', 'max:255'],
            'no_hp' => ['nullable', 'string', 'max:50'],
        ]);

        if ($validator->fails()) {
            return response()->json(['message' => 'Validasi gagal', 'errors' => $validator->errors()], 422);
        }

        $pendaftaran = PendaftaranKegiatan::create([
            'kegiatan_id' => $kegiatanId,
            'uid' => $uid,
            'nama' => $request->input('nama'),
            'nim' => $request->input('nim'),
            'prodi' => $request->input('prodi', ''),
            'no_hp' => $request->input('no_hp', ''),
            'status' => 'Terdaftar',
        ]);

        return response()->json([
            'pendaftaran' => $pendaftaran,
            'kegiatan' => $kegiatan->fresh()->loadCount('pendaftaran'),
        ], 201);
    }

    public function statusSaya(Request $request, int $kegiatanId): JsonResponse
    {
        if ($request->attributes->get('auth_role') !== 'mahasiswa') {
            return response()->json(['message' => 'Hanya mahasiswa yang punya status pendaftaran kegiatan'], 403);
        }

        $uid = $request->attributes->get('auth_user')->uid;
        $pendaftaran = PendaftaranKegiatan::where('kegiatan_id', $kegiatanId)->where('uid', $uid)->first();

        return response()->json([
            'terdaftar' => (bool) $pendaftaran,
            'pendaftaran' => $pendaftaran,
        ]);
    }

    public function peserta(Request $request, int $kegiatanId): JsonResponse
    {
        if ($request->attributes->get('auth_role') !== 'dosen') {
            return response()->json(['message' => 'Hanya dosen yang bisa melihat daftar peserta'], 403);
        }

        $peserta = PendaftaranKegiatan::where('kegiatan_id', $kegiatanId)
            ->orderByDesc('created_at')
            ->get();

        return response()->json($peserta);
    }

    public function destroy(Request $request, int $id): JsonResponse
    {
        $pendaftaran = PendaftaranKegiatan::find($id);

        if (! $pendaftaran) {
            return response()->json(['message' => 'Pendaftaran tidak ditemukan'], 404);
        }

        $role = $request->attributes->get('auth_role');
        $uid = $request->attributes->get('auth_user')->uid;

        if ($role === 'mahasiswa' && $pendaftaran->uid !== $uid) {
            return response()->json(['message' => 'Anda hanya bisa membatalkan pendaftaran sendiri'], 403);
        }

        $pendaftaran->delete();

        return response()->json(['message' => 'Pendaftaran berhasil dibatalkan']);
    }
}
