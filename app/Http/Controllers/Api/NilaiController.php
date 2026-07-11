<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Nilai;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class NilaiController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $query = Nilai::query();

        if ($request->attributes->get('auth_role') === 'mahasiswa') {
            $query->where('mahasiswa_uid', $request->attributes->get('auth_user')->uid);
        } elseif ($request->filled('kelas')) {
            $query->where('kelas', $request->input('kelas'));
        }

        return response()->json($query->get());
    }

    public function show(Request $request, string $kelas, string $mahasiswaUid): JsonResponse
    {
        if (!$this->canAccess($request, $mahasiswaUid)) {
            return response()->json(['message' => 'Akses ditolak'], 403);
        }

        $nilai = Nilai::where('kelas', $kelas)->where('mahasiswa_uid', $mahasiswaUid)->first();

        if (!$nilai) {
            return response()->json(['message' => 'Nilai tidak ditemukan'], 404);
        }

        return response()->json($nilai);
    }

    public function upsert(Request $request, string $kelas, string $mahasiswaUid): JsonResponse
    {
        if ($request->attributes->get('auth_role') !== 'dosen') {
            return response()->json(['message' => 'Hanya dosen yang bisa menginput nilai'], 403);
        }

        $validator = Validator::make($request->all(), [
            'nim' => ['nullable', 'string', 'max:50'],
            'nama' => ['nullable', 'string', 'max:255'],
            'tugas' => ['required', 'integer', 'min:0', 'max:100'],
            'uts' => ['required', 'integer', 'min:0', 'max:100'],
            'uas' => ['required', 'integer', 'min:0', 'max:100'],
        ]);

        if ($validator->fails()) {
            return response()->json(['message' => 'Validasi gagal', 'errors' => $validator->errors()], 422);
        }

        $data = $validator->validated();

        $nilai = Nilai::updateOrCreate(
            ['kelas' => $kelas, 'mahasiswa_uid' => $mahasiswaUid],
            $data
        );

        return response()->json($nilai);
    }

    public function destroy(Request $request, string $kelas, string $mahasiswaUid): JsonResponse
    {
        if ($request->attributes->get('auth_role') !== 'dosen') {
            return response()->json(['message' => 'Hanya dosen yang bisa menghapus nilai'], 403);
        }

        Nilai::where('kelas', $kelas)->where('mahasiswa_uid', $mahasiswaUid)->delete();

        return response()->json(['message' => 'Nilai berhasil dihapus']);
    }

    private function canAccess(Request $request, string $mahasiswaUid): bool
    {
        if ($request->attributes->get('auth_role') === 'dosen') {
            return true;
        }

        return $request->attributes->get('auth_user')->uid === $mahasiswaUid;
    }
}
