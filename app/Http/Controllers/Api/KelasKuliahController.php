<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\KelasKuliah;
use App\Models\KrsMataKuliah;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class KelasKuliahController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $query = KelasKuliah::with(['mataKuliah', 'dosen'])->withCount('krsMataKuliah');

        if ($request->filled('tahun_akademik')) {
            $tahun = trim($request->input('tahun_akademik'));
            if ($tahun !== '') {
                $query->where('tahun_akademik', $tahun);
            }
        }

        if ($request->filled('semester')) {
            $sem = trim($request->input('semester'));
            if ($sem !== '') {
                $query->where(function ($q) use ($sem) {
                    $q->where('semester', $sem)
                      ->orWhereHas('mataKuliah', fn ($mk) => $mk->where('semester_ke', $sem));

                    if (in_array(strtolower($sem), ['1', '3', '5', '7', 'ganjil'], true)) {
                        $q->orWhereIn('semester', ['1', '3', '5', '7', 'Ganjil', 'ganjil']);
                    } elseif (in_array(strtolower($sem), ['2', '4', '6', '8', 'genap'], true)) {
                        $q->orWhereIn('semester', ['2', '4', '6', '8', 'Genap', 'genap']);
                    }
                });
            }
        }

        if ($request->filled('prodi')) {
            $query->whereHas('mataKuliah', function ($q) use ($request) {
                $q->where('prodi', $request->input('prodi'));
            });
        }

        return response()->json($query->get());
    }

    public function show(Request $request, int $id): JsonResponse
    {
        $kelas = KelasKuliah::with(['mataKuliah', 'dosen'])->withCount('krsMataKuliah')->find($id);

        if (! $kelas) {
            return response()->json(['message' => 'Kelas kuliah tidak ditemukan'], 404);
        }

        return response()->json($kelas);
    }

    public function peserta(int $id): JsonResponse
    {
        $mahasiswa = KrsMataKuliah::where('kelas_kuliah_id', $id)
            ->whereHas('krs', fn ($q) => $q->where('status', 'disetujui'))
            ->with('krs.mahasiswa')
            ->get()
            ->map(fn ($mk) => $mk->krs->mahasiswa)
            ->filter()
            ->unique('uid')
            ->values();

        return response()->json($mahasiswa);
    }
}
