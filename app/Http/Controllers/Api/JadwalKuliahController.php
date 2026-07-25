<?php

namespace App\Http\Controllers\Api;

use App\Models\JadwalKuliah;
use App\Models\Krs;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class JadwalKuliahController extends BaseCrudController
{
    protected string $modelClass = JadwalKuliah::class;

    protected ?string $ownerColumn = 'uid';

    protected array $fillable = ['hari', 'mata_kuliah', 'jam_mulai', 'jam_selesai', 'ruangan', 'keterangan'];

    protected array $writeRoles = [];

    protected bool $dosenReadsAll = true;

    public function index(Request $request): JsonResponse
    {
        $role = $request->attributes->get('auth_role');
        $uid = $request->attributes->get('auth_user')?->uid;

        if ($role === 'mahasiswa' && $uid) {
            $jadwal = JadwalKuliah::where('uid', $uid)->get();

            if ($jadwal->isEmpty()) {
                $approvedKrs = Krs::with('mataKuliah.kelasKuliah')
                    ->where('uid', $uid)
                    ->where('status', 'disetujui')
                    ->latest()
                    ->first();

                if ($approvedKrs && $approvedKrs->mataKuliah->isNotEmpty()) {
                    foreach ($approvedKrs->mataKuliah as $mk) {
                        $kelas = $mk->kelasKuliah;
                        $pukul = explode('-', $mk->pukul ?? '');
                        $jamMulai = trim($pukul[0] ?? '08:00');
                        $jamSelesai = trim($pukul[1] ?? '10:00');

                        JadwalKuliah::create([
                            'uid' => $uid,
                            'hari' => ! empty($mk->hari) ? $mk->hari : ($kelas?->hari ?? 'Senin'),
                            'mata_kuliah' => $mk->nama,
                            'jam_mulai' => $kelas?->jam_mulai ?? $jamMulai,
                            'jam_selesai' => $kelas?->jam_selesai ?? $jamSelesai,
                            'ruangan' => ! empty($mk->ruang) ? $mk->ruang : ($kelas?->ruangan ?? '-'),
                            'keterangan' => "Semester {$approvedKrs->semester} • Kelas {$mk->kelas} ({$mk->sks} SKS)",
                        ]);
                    }

                    $jadwal = JadwalKuliah::where('uid', $uid)->get();
                }
            }

            return response()->json($jadwal);
        }

        return parent::index($request);
    }
}
