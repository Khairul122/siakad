<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\KelasKuliah;
use App\Models\Presensi;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class PresensiController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $query = Presensi::with('kelasKuliah.mataKuliah', 'kelasKuliah.dosen');

        if ($request->attributes->get('auth_role') === 'mahasiswa') {
            $query->where('mahasiswa_uid', $request->attributes->get('auth_user')->uid);
        } else {
            if ($request->filled('kelas_kuliah_id')) {
                $query->where('kelas_kuliah_id', $request->input('kelas_kuliah_id'));
            }
            if ($request->filled('pertemuan')) {
                $query->where('pertemuan', $request->input('pertemuan'));
            }
        }

        return response()->json($query->get());
    }

    public function show(Request $request, int $kelasKuliahId, string $pertemuan, string $mahasiswaUid): JsonResponse
    {
        if (! $this->canAccess($request, $mahasiswaUid)) {
            return response()->json(['message' => 'Akses ditolak'], 403);
        }

        $presensi = Presensi::with('kelasKuliah.mataKuliah', 'kelasKuliah.dosen')
            ->where('kelas_kuliah_id', $kelasKuliahId)
            ->where('pertemuan', $pertemuan)
            ->where('mahasiswa_uid', $mahasiswaUid)
            ->first();

        if (! $presensi) {
            return response()->json(['message' => 'Presensi tidak ditemukan'], 404);
        }

        return response()->json($presensi);
    }

    public function upsert(Request $request, int $kelasKuliahId, string $pertemuan, string $mahasiswaUid): JsonResponse
    {
        if ($request->attributes->get('auth_role') !== 'dosen') {
            return response()->json(['message' => 'Hanya dosen yang bisa menginput presensi'], 403);
        }

        $kelas = KelasKuliah::with('mataKuliah')->find($kelasKuliahId);

        if (! $kelas) {
            return response()->json(['message' => 'Kelas kuliah tidak ditemukan'], 404);
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
        $data['kelas'] = "{$kelas->mataKuliah?->nama} - Kelas {$kelas->nama_kelas}";
        $data['kelas_kuliah_id'] = $kelas->id;

        $presensi = Presensi::updateOrCreate(
            ['kelas_kuliah_id' => $kelas->id, 'pertemuan' => $pertemuan, 'mahasiswa_uid' => $mahasiswaUid],
            $data
        );

        return response()->json($presensi);
    }

    public function destroy(Request $request, int $kelasKuliahId, string $pertemuan, string $mahasiswaUid): JsonResponse
    {
        if ($request->attributes->get('auth_role') !== 'dosen') {
            return response()->json(['message' => 'Hanya dosen yang bisa menghapus presensi'], 403);
        }

        Presensi::where('kelas_kuliah_id', $kelasKuliahId)
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
