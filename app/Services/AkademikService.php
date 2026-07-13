<?php

namespace App\Services;

use App\Models\KelasKuliah;
use App\Models\Khs;
use App\Models\Nilai;
use Illuminate\Support\Collection;

class AkademikService
{
    private const DEFAULT_MAX_SKS = 21;

    private const GRADE_POINTS = [
        'A' => 4.0,
        'B' => 3.0,
        'C' => 2.0,
        'D' => 1.0,
        'E' => 0.0,
    ];

    public function hitungIps(string $uid): ?float
    {
        $terakhir = Khs::where('uid', $uid)->orderByDesc('id')->first();

        if (!$terakhir) {
            return null;
        }

        $semesterRows = Khs::where('uid', $uid)
            ->where('tahun_akademik', $terakhir->tahun_akademik)
            ->where('semester', $terakhir->semester)
            ->get();

        return $this->ipsForRows($semesterRows);
    }

    public function maxSks(?float $ips): int
    {
        if ($ips === null) {
            return self::DEFAULT_MAX_SKS;
        }

        return match (true) {
            $ips >= 3.00 => 24,
            $ips >= 2.50 => 21,
            $ips >= 2.00 => 18,
            $ips >= 1.50 => 15,
            default => 12,
        };
    }

    /**
     * Sinkronkan satu baris KHS mahasiswa untuk kelas_kuliah tertentu dari data Nilai terbaru.
     * Dipanggil otomatis setiap kali dosen menyimpan/mengubah nilai (NilaiController::upsert).
     */
    public function syncKhs(string $mahasiswaUid, int $kelasKuliahId): void
    {
        $kelas = KelasKuliah::with('mataKuliah')->find($kelasKuliahId);
        $nilai = Nilai::where('kelas_kuliah_id', $kelasKuliahId)->where('mahasiswa_uid', $mahasiswaUid)->first();

        if (!$kelas || !$nilai || !$kelas->mataKuliah) {
            return;
        }

        Khs::updateOrCreate(
            [
                'uid' => $mahasiswaUid,
                'tahun_akademik' => $kelas->tahun_akademik,
                'semester' => $kelas->semester,
                'kode' => $kelas->mataKuliah->kode,
            ],
            [
                'mata_kuliah' => $kelas->mataKuliah->nama,
                'sks' => $kelas->mataKuliah->sks,
                'kelas' => "{$kelas->mataKuliah->nama} - Kelas {$kelas->nama_kelas}",
                'tugas' => $nilai->tugas,
                'uts' => $nilai->uts,
                'uas' => $nilai->uas,
            ]
        );
    }

    /**
     * Ringkasan IP per semester + IPK kumulatif untuk seorang mahasiswa.
     *
     * @return array{semester: array<int, array{tahun_akademik: string, semester: string, ips: float, total_sks: int}>, ipk: float|null}
     */
    public function ringkasanPerSemester(string $uid): array
    {
        $rows = Khs::where('uid', $uid)->get();
        $grouped = $rows->groupBy(fn (Khs $row) => "{$row->tahun_akademik}|{$row->semester}");

        $semesterList = $grouped->map(function (Collection $group) {
            /** @var Khs $first */
            $first = $group->first();

            return [
                'tahun_akademik' => $first->tahun_akademik,
                'semester' => $first->semester,
                'ips' => $this->ipsForRows($group),
                'total_sks' => $group->sum('sks'),
            ];
        })->values()->all();

        $ipk = $rows->isEmpty() ? null : $this->ipsForRows($rows);

        return ['semester' => $semesterList, 'ipk' => $ipk];
    }

    private function ipsForRows(Collection $rows): ?float
    {
        $totalSks = 0;
        $totalBobot = 0.0;

        foreach ($rows as $row) {
            $nilaiAkhir = ($row->tugas * 0.3) + ($row->uts * 0.3) + ($row->uas * 0.4);
            $grade = $this->grade($nilaiAkhir);
            $totalSks += $row->sks;
            $totalBobot += self::GRADE_POINTS[$grade] * $row->sks;
        }

        if ($totalSks === 0) {
            return null;
        }

        return round($totalBobot / $totalSks, 2);
    }

    private function grade(float $nilaiAkhir): string
    {
        if ($nilaiAkhir >= 85) return 'A';
        if ($nilaiAkhir >= 75) return 'B';
        if ($nilaiAkhir >= 65) return 'C';
        if ($nilaiAkhir >= 55) return 'D';
        return 'E';
    }
}
