<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Mahasiswa;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class MahasiswaController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        if ($request->attributes->get('auth_role') !== 'dosen') {
            return response()->json(['message' => 'Hanya dosen yang bisa melihat daftar semua mahasiswa'], 403);
        }

        $query = Mahasiswa::query();

        if ($request->filled('dosen_pembimbing_uid')) {
            $query->where('dosen_pembimbing_uid', $request->input('dosen_pembimbing_uid'));
        }

        if ($request->filled('kelas')) {
            $query->where('kelas', $request->input('kelas'));
        }

        return response()->json($query->get());
    }

    public function show(Request $request, string $uid): JsonResponse
    {
        if (!$this->canAccess($request, $uid)) {
            return response()->json(['message' => 'Akses ditolak'], 403);
        }

        $mahasiswa = Mahasiswa::find($uid);

        if (!$mahasiswa) {
            return response()->json(['message' => 'Mahasiswa tidak ditemukan'], 404);
        }

        return response()->json($mahasiswa);
    }

    public function update(Request $request, string $uid): JsonResponse
    {
        if ($request->attributes->get('auth_role') !== 'mahasiswa' || $request->attributes->get('auth_user')->uid !== $uid) {
            return response()->json(['message' => 'Hanya pemilik akun yang bisa mengubah profil ini'], 403);
        }

        $mahasiswa = Mahasiswa::find($uid);

        if (!$mahasiswa) {
            return response()->json(['message' => 'Mahasiswa tidak ditemukan'], 404);
        }

        $mahasiswa->update($request->only([
            'nama', 'no_hp', 'tanggal_lahir', 'alamat', 'photo_url',
            'kelas', 'angkatan', 'prodi', 'dosen_pembimbing_uid', 'fcm_token',
        ]));

        return response()->json($mahasiswa);
    }

    public function destroy(Request $request, string $uid): JsonResponse
    {
        if ($request->attributes->get('auth_role') !== 'mahasiswa' || $request->attributes->get('auth_user')->uid !== $uid) {
            return response()->json(['message' => 'Hanya pemilik akun yang bisa menghapus akun ini'], 403);
        }

        Mahasiswa::where('uid', $uid)->delete();

        return response()->json(['message' => 'Akun berhasil dihapus']);
    }

    private function canAccess(Request $request, string $uid): bool
    {
        if ($request->attributes->get('auth_role') === 'dosen') {
            return true;
        }

        return $request->attributes->get('auth_user')->uid === $uid;
    }
}
