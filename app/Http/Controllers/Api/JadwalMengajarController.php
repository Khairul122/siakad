<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\KelasKuliah;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class JadwalMengajarController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $uid = $request->attributes->get('auth_user')->uid;

        return response()->json($this->mapped($uid));
    }

    public function show(Request $request, int $id): JsonResponse
    {
        $uid = $request->attributes->get('auth_user')->uid;
        $item = $this->mapped($uid)->firstWhere('id', $id);

        if (! $item) {
            return response()->json(['message' => 'Data tidak ditemukan'], 404);
        }

        return response()->json($item);
    }

    private function mapped(string $dosenUid)
    {
        return KelasKuliah::with('mataKuliah')
            ->where('dosen_uid', $dosenUid)
            ->get()
            ->map(fn (KelasKuliah $kelas) => [
                'id' => $kelas->id,
                'kelas_kuliah_id' => $kelas->id,
                'uid' => $kelas->dosen_uid,
                'hari' => $kelas->hari,
                'mata_kuliah' => $kelas->mataKuliah?->nama ?? '',
                'nama_kelas' => $kelas->nama_kelas,
                'jam_mulai' => $kelas->jam_mulai,
                'jam_selesai' => $kelas->jam_selesai,
                'ruangan' => $kelas->ruangan,
                'keterangan' => "Semester {$kelas->semester} • Kelas {$kelas->nama_kelas}" . ($kelas->mataKuliah ? " ({$kelas->mataKuliah->sks} SKS)" : ''),
            ]);
    }
}
