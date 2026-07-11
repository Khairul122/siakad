<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Presensi;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class PresensiController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $query = Presensi::query();

        if ($request->attributes->get('auth_role') === 'mahasiswa') {
            $query->where('mahasiswa_uid', $request->attributes->get('auth_user')->uid);
        } else {
            if ($request->filled('kelas')) {
                $query->where('kelas', $request->input('kelas'));
            }
            if ($request->filled('pertemuan')) {
                $query->where('pertemuan', $request->input('pertemuan'));
            }
        }

        return response()->json($query->get());
    }

    public function show(Request $request, string $kelas, string $pertemuan, string $mahasiswaUid): JsonResponse
    {
        if (!$this->canAccess($request, $mahasiswaUid)) {
            return response()->json(['message' => 'Akses ditolak'], 403);
        }

        $presensi = Presensi::where('kelas', $kelas)
            ->where('pertemuan', $pertemuan)
            ->where('mahasiswa_uid', $mahasiswaUid)
            ->first();

        if (!$presensi) {
            return response()->json(['message' => 'Presensi tidak ditemukan'], 404);
        }

        return response()->json($presensi);
    }

    public function upsert(Request $request, string $kelas, string $pertemuan, string $mahasiswaUid): JsonResponse
    {
        if ($request->attributes->get('auth_role') !== 'dosen') {
            return response()->json(['message' => 'Hanya dosen yang bisa menginput presensi'], 403);
        }

        $validator = Validator::make($request->all(), [
            'nim' => ['nullable', 'string', 'max:50'],
            'nama' => ['nullable', 'string', 'max:255'],
            'keterangan' => ['required', 'in:Hadir,Izin,Sakit,Alpha'],
        ]);

        if ($validator->fails()) {
            return response()->json(['message' => 'Validasi gagal', 'errors' => $validator->errors()], 422);
        }

        $data = $validator->validated();

        $presensi = Presensi::updateOrCreate(
            ['kelas' => $kelas, 'pertemuan' => $pertemuan, 'mahasiswa_uid' => $mahasiswaUid],
            $data
        );

        return response()->json($presensi);
    }

    public function destroy(Request $request, string $kelas, string $pertemuan, string $mahasiswaUid): JsonResponse
    {
        if ($request->attributes->get('auth_role') !== 'dosen') {
            return response()->json(['message' => 'Hanya dosen yang bisa menghapus presensi'], 403);
        }

        Presensi::where('kelas', $kelas)
            ->where('pertemuan', $pertemuan)
            ->where('mahasiswa_uid', $mahasiswaUid)
            ->delete();

        return response()->json(['message' => 'Presensi berhasil dihapus']);
    }

    private function canAccess(Request $request, string $mahasiswaUid): bool
    {
        if ($request->attributes->get('auth_role') === 'dosen') {
            return true;
        }

        return $request->attributes->get('auth_user')->uid === $mahasiswaUid;
    }
}
