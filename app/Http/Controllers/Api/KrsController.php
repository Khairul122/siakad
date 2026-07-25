<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\JadwalKuliah;
use App\Models\KelasKuliah;
use App\Models\Krs;
use App\Services\AkademikService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

class KrsController extends Controller
{
    public function __construct(private AkademikService $akademikService) {}

    public function kuota(Request $request): JsonResponse
    {
        if ($request->attributes->get('auth_role') !== 'mahasiswa') {
            return response()->json(['message' => 'Hanya mahasiswa yang punya kuota SKS'], 403);
        }

        $uid = $request->attributes->get('auth_user')->uid;
        $ips = $this->akademikService->hitungIps($uid);

        return response()->json([
            'ips' => $ips,
            'max_sks' => $this->akademikService->maxSks($ips),
        ]);
    }

    public function index(Request $request): JsonResponse
    {
        $query = Krs::with('mahasiswa', 'mataKuliah.kelasKuliah.mataKuliah', 'mataKuliah.kelasKuliah.dosen');

        if ($request->attributes->get('auth_role') === 'mahasiswa') {
            $query->where('uid', $request->attributes->get('auth_user')->uid);
        } elseif ($request->attributes->get('auth_role') === 'dosen') {
            $dosenUid = $request->attributes->get('auth_user')->uid;
            $query->whereHas('mahasiswa', fn ($q) => $q->where('dosen_pembimbing_uid', $dosenUid));

            if ($request->filled('uid')) {
                $query->where('uid', $request->input('uid'));
            }
        }

        if ($request->filled('status')) {
            $query->where('status', $request->input('status'));
        }

        if ($request->filled('semester')) {
            $sem = trim($request->input('semester'));
            if ($sem !== '') {
                $query->where(function ($q) use ($sem) {
                    $q->where('semester', $sem);
                    if (in_array(strtolower($sem), ['1', '3', '5', '7', 'ganjil'], true)) {
                        $q->orWhereIn('semester', ['1', '3', '5', '7', 'Ganjil', 'ganjil']);
                    } elseif (in_array(strtolower($sem), ['2', '4', '6', '8', 'genap'], true)) {
                        $q->orWhereIn('semester', ['2', '4', '6', '8', 'Genap', 'genap']);
                    }
                });
            }
        }

        return response()->json($query->get());
    }

    public function show(Request $request, int $id): JsonResponse
    {
        $krs = Krs::with('mahasiswa', 'mataKuliah.kelasKuliah.mataKuliah', 'mataKuliah.kelasKuliah.dosen')->find($id);

        if (! $krs || ! $this->canAccess($request, $krs)) {
            return response()->json(['message' => 'KRS tidak ditemukan'], 404);
        }

        return response()->json($krs);
    }

    public function store(Request $request): JsonResponse
    {
        if ($request->attributes->get('auth_role') !== 'mahasiswa') {
            return response()->json(['message' => 'Hanya mahasiswa yang bisa membuat KRS'], 403);
        }

        $uid = $request->attributes->get('auth_user')->uid;

        $validator = Validator::make($request->all(), [
            'tahun_akademik' => ['required', 'string', 'max:20'],
            'semester' => ['required', 'string', 'max:20'],
            'kelas_kuliah_ids' => ['required', 'array', 'min:1'],
            'kelas_kuliah_ids.*' => ['integer', 'exists:kelas_kuliah,id'],
        ]);

        if ($validator->fails()) {
            return response()->json(['message' => 'Validasi gagal', 'errors' => $validator->errors()], 422);
        }

        $data = $validator->validated();
        $kelasList = KelasKuliah::with('mataKuliah')->whereIn('id', $data['kelas_kuliah_ids'])->get();

        $tahunAkademik = $kelasList->first()?->tahun_akademik ?? $data['tahun_akademik'];
        $semester = $kelasList->first()?->semester ?? $data['semester'];

        $existing = Krs::where('uid', $uid)
            ->where(function ($q) use ($tahunAkademik, $data) {
                $q->where('tahun_akademik', $tahunAkademik)
                  ->orWhere('tahun_akademik', $data['tahun_akademik']);
            })
            ->where(function ($q) use ($semester, $data) {
                $sem1 = trim($semester);
                $sem2 = trim($data['semester']);
                $q->whereIn('semester', [$sem1, $sem2]);
                if (in_array(strtolower($sem1), ['1', '3', '5', '7', 'ganjil'], true) || in_array(strtolower($sem2), ['1', '3', '5', '7', 'ganjil'], true)) {
                    $q->orWhereIn('semester', ['1', '3', '5', '7', 'Ganjil', 'ganjil']);
                } elseif (in_array(strtolower($sem1), ['2', '4', '6', '8', 'genap'], true) || in_array(strtolower($sem2), ['2', '4', '6', '8', 'genap'], true)) {
                    $q->orWhereIn('semester', ['2', '4', '6', '8', 'Genap', 'genap']);
                }
            })
            ->first();

        if ($existing && $existing->status === 'disetujui') {
            return response()->json(['message' => 'KRS sudah disetujui, tidak bisa diajukan ulang'], 422);
        }

        if ($error = $this->validasiPengajuan($uid, $tahunAkademik, $semester, $kelasList)) {
            return $error;
        }

        $krs = DB::transaction(function () use ($existing, $uid, $tahunAkademik, $semester, $kelasList) {
            if ($existing) {
                $existing->mataKuliah()->delete();
                $existing->update([
                    'tahun_akademik' => $tahunAkademik,
                    'semester' => $semester,
                    'status' => 'diajukan',
                    'catatan_dosen' => null,
                    'disetujui_oleh' => null,
                    'disetujui_at' => null,
                ]);
                $krs = $existing;
            } else {
                $krs = Krs::create([
                    'uid' => $uid,
                    'tahun_akademik' => $tahunAkademik,
                    'semester' => $semester,
                    'status' => 'diajukan',
                ]);
            }

            foreach ($kelasList as $kelas) {
                $krs->mataKuliah()->create($this->snapshot($kelas));
            }

            return $krs->load('mataKuliah.kelasKuliah.mataKuliah', 'mataKuliah.kelasKuliah.dosen');
        });

        return response()->json($krs, 201);
    }

    public function update(Request $request, int $id): JsonResponse
    {
        $krs = Krs::find($id);

        if (! $krs || ! $this->canAccess($request, $krs)) {
            return response()->json(['message' => 'KRS tidak ditemukan'], 404);
        }

        if ($request->attributes->get('auth_role') !== 'mahasiswa') {
            return response()->json(['message' => 'Hanya mahasiswa pemilik KRS yang bisa mengubah'], 403);
        }

        if ($krs->status === 'disetujui') {
            return response()->json(['message' => 'KRS sudah disetujui, tidak bisa diubah'], 422);
        }

        $validator = Validator::make($request->all(), [
            'tahun_akademik' => ['nullable', 'string', 'max:20'],
            'semester' => ['nullable', 'string', 'max:20'],
            'kelas_kuliah_ids' => ['required', 'array', 'min:1'],
            'kelas_kuliah_ids.*' => ['integer', 'exists:kelas_kuliah,id'],
        ]);

        if ($validator->fails()) {
            return response()->json(['message' => 'Validasi gagal', 'errors' => $validator->errors()], 422);
        }

        $data = $validator->validated();
        $tahunAkademik = !empty($data['tahun_akademik']) ? $data['tahun_akademik'] : $krs->tahun_akademik;
        $semester = !empty($data['semester']) ? $data['semester'] : $krs->semester;

        $kelasList = KelasKuliah::with('mataKuliah')->whereIn('id', $data['kelas_kuliah_ids'])->get();

        if ($error = $this->validasiPengajuan($krs->uid, $tahunAkademik, $semester, $kelasList)) {
            return $error;
        }

        DB::transaction(function () use ($krs, $tahunAkademik, $semester, $kelasList) {
            $krs->mataKuliah()->delete();

            foreach ($kelasList as $kelas) {
                $krs->mataKuliah()->create($this->snapshot($kelas));
            }

            $krs->update([
                'tahun_akademik' => $tahunAkademik,
                'semester' => $semester,
                'status' => 'diajukan',
                'catatan_dosen' => null,
                'disetujui_oleh' => null,
                'disetujui_at' => null,
            ]);
        });

        return response()->json($krs->load('mataKuliah.kelasKuliah.mataKuliah', 'mataKuliah.kelasKuliah.dosen'));
    }

    public function destroy(Request $request, int $id): JsonResponse
    {
        $krs = Krs::find($id);

        if (! $krs || ! $this->canAccess($request, $krs)) {
            return response()->json(['message' => 'KRS tidak ditemukan'], 404);
        }

        $krs->delete();

        return response()->json(['message' => 'KRS berhasil dihapus']);
    }

    public function approve(Request $request, int $id): JsonResponse
    {
        $krs = Krs::with('mataKuliah.kelasKuliah')->find($id);

        if (! $krs) {
            return response()->json(['message' => 'KRS tidak ditemukan'], 404);
        }

        $dosenUid = $request->attributes->get('auth_user')->uid;

        if ($krs->mahasiswa->dosen_pembimbing_uid !== $dosenUid) {
            return response()->json(['message' => 'Anda bukan dosen pembimbing mahasiswa ini'], 403);
        }

        DB::transaction(function () use ($krs, $request, $dosenUid) {
            $krs->update([
                'status' => 'disetujui',
                'catatan_dosen' => $request->input('catatan'),
                'disetujui_oleh' => $dosenUid,
                'disetujui_at' => now(),
            ]);

            JadwalKuliah::where('uid', $krs->uid)->delete();

            foreach ($krs->mataKuliah as $mk) {
                $kelas = $mk->kelasKuliah;

                if (! $kelas) {
                    continue;
                }

                JadwalKuliah::create([
                    'uid' => $krs->uid,
                    'hari' => $kelas->hari,
                    'mata_kuliah' => $mk->nama,
                    'jam_mulai' => $kelas->jam_mulai,
                    'jam_selesai' => $kelas->jam_selesai,
                    'ruangan' => $kelas->ruangan,
                    'keterangan' => '',
                ]);
            }
        });

        return response()->json($krs->fresh(['mataKuliah.kelasKuliah.mataKuliah']));
    }

    public function reject(Request $request, int $id): JsonResponse
    {
        $krs = Krs::find($id);

        if (! $krs) {
            return response()->json(['message' => 'KRS tidak ditemukan'], 404);
        }

        $dosenUid = $request->attributes->get('auth_user')->uid;

        if ($krs->mahasiswa->dosen_pembimbing_uid !== $dosenUid) {
            return response()->json(['message' => 'Anda bukan dosen pembimbing mahasiswa ini'], 403);
        }

        $validator = Validator::make($request->all(), [
            'catatan' => ['required', 'string'],
        ]);

        if ($validator->fails()) {
            return response()->json(['message' => 'Validasi gagal', 'errors' => $validator->errors()], 422);
        }

        $krs->update([
            'status' => 'ditolak',
            'catatan_dosen' => $request->input('catatan'),
            'disetujui_oleh' => null,
            'disetujui_at' => null,
        ]);

        return response()->json($krs->fresh(['mataKuliah.kelasKuliah.mataKuliah']));
    }

    private function validasiPengajuan(string $uid, string $tahunAkademik, string $semester, $kelasList): ?JsonResponse
    {
        foreach ($kelasList as $kelas) {
            if (! $this->periodeMatch($kelas->tahun_akademik, $kelas->semester, $tahunAkademik, $semester, $kelas->mataKuliah?->semester_ke)) {
                return response()->json(['message' => "Kelas {$kelas->nama_kelas} ({$kelas->mataKuliah?->nama}) tidak tersedia pada periode ini"], 422);
            }
        }

        $totalSks = $kelasList->sum(fn (KelasKuliah $kelas) => $kelas->mataKuliah?->sks ?? 0);
        $ips = $this->akademikService->hitungIps($uid);
        $maxSks = $this->akademikService->maxSks($ips);

        if ($totalSks > $maxSks) {
            return response()->json([
                'message' => "Total SKS ({$totalSks}) melebihi batas maksimum ({$maxSks} SKS berdasarkan IPS terakhir)",
            ], 422);
        }

        for ($i = 0; $i < count($kelasList); $i++) {
            for ($j = $i + 1; $j < count($kelasList); $j++) {
                if ($this->bentrok($kelasList[$i], $kelasList[$j])) {
                    return response()->json([
                        'message' => "Jadwal kelas {$kelasList[$i]->nama_kelas} bentrok dengan {$kelasList[$j]->nama_kelas}",
                    ], 422);
                }
            }
        }

        return null;
    }

    private function periodeMatch(string $kelasTahun, string $kelasSem, string $targetTahun, string $targetSem, ?int $mkSemKe = null): bool
    {
        if (! empty($targetTahun) && trim(strtolower($kelasTahun)) !== trim(strtolower($targetTahun))) {
            return false;
        }

        if (empty($targetSem)) {
            return true;
        }

        $kSem = trim(strtolower($kelasSem));
        $tSem = trim(strtolower($targetSem));

        if ($kSem === $tSem) {
            return true;
        }

        if ($mkSemKe !== null && (string) $mkSemKe === $tSem) {
            return true;
        }

        $ganjil = ['1', '3', '5', '7', 'ganjil'];
        $genap = ['2', '4', '6', '8', 'genap'];

        if (in_array($kSem, $ganjil, true) && in_array($tSem, $ganjil, true)) {
            return true;
        }

        if (in_array($kSem, $genap, true) && in_array($tSem, $genap, true)) {
            return true;
        }

        return false;
    }

    private function bentrok(KelasKuliah $a, KelasKuliah $b): bool
    {
        if ($a->hari !== $b->hari) {
            return false;
        }

        return $a->jam_mulai < $b->jam_selesai && $b->jam_mulai < $a->jam_selesai;
    }

    private function snapshot(KelasKuliah $kelas): array
    {
        return [
            'kelas_kuliah_id' => $kelas->id,
            'nama' => $kelas->mataKuliah?->nama ?? '',
            'kode' => $kelas->mataKuliah?->kode ?? '',
            'sks' => (string) ($kelas->mataKuliah?->sks ?? ''),
            'kelas' => $kelas->nama_kelas,
            'hari' => $kelas->hari,
            'pukul' => "{$kelas->jam_mulai}-{$kelas->jam_selesai}",
            'ruang' => $kelas->ruangan,
            'status' => '',
        ];
    }

    private function canAccess(Request $request, Krs $krs): bool
    {
        if ($request->attributes->get('auth_role') === 'dosen') {
            return $krs->mahasiswa?->dosen_pembimbing_uid === $request->attributes->get('auth_user')->uid;
        }

        return $krs->uid === $request->attributes->get('auth_user')->uid;
    }
}
