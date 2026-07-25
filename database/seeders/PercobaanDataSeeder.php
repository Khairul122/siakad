<?php

namespace Database\Seeders;

use App\Models\Dosen;
use App\Models\Informasi;
use App\Models\JadwalKuliah;
use App\Models\Kegiatan;
use App\Models\KelasKuliah;
use App\Models\Khs;
use App\Models\Krs;
use App\Models\KrsMataKuliah;
use App\Models\Mahasiswa;
use App\Models\MataKuliah;
use App\Models\Nilai;
use App\Models\Notifikasi;
use App\Models\Presensi;
use App\Models\Tagihan;
use App\Services\AkademikService;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;

/**
 * Seeder data percobaan/demo untuk seluruh alur SIAKAD (5 Dosen, 5 Mahasiswa, 8 Semester @ 20 SKS).
 * Jalankan: php artisan db:seed --class=PercobaanDataSeeder
 */
class PercobaanDataSeeder extends Seeder
{
    private const PASSWORD = 'password';

    private const TAHUN_AKADEMIK = '2025/2026';

    public function run(AkademikService $akademikService): void
    {
        $dosenList = $this->seedDosen();
        $mataKuliahList = $this->seedMataKuliah();
        $kelasList = $this->seedKelasKuliah($mataKuliahList, $dosenList);
        $mahasiswaList = $this->seedMahasiswa($dosenList);

        $this->seedKrsDanJadwal($mahasiswaList, $kelasList);
        $this->seedNilaiPresensiKhs($mahasiswaList, $kelasList, $akademikService);
        $this->seedTagihan($mahasiswaList);
        $this->seedNotifikasi($mahasiswaList);
        $this->seedInformasiKegiatan();

        $this->command?->info('Data percobaan SIAKAD berhasil dibuat (5 Dosen, 5 Mahasiswa, 8 Semester @ 20 SKS, password: '.self::PASSWORD.').');
    }

    private function seedDosen(): array
    {
        $data = [
            [
                'uid' => 'dosen-001',
                'nama' => 'Dr. Bambang Sutrisno, M.Kom',
                'nip' => '198501012010011001',
                'email' => 'bambang.sutrisno@dosen.siakad.ac.id',
                'prodi' => 'Teknik Informatika',
                'avatar_seed' => 'dosen-bambang',
            ],
            [
                'uid' => 'dosen-002',
                'nama' => 'Prof. Dr. Siti Aminah, M.T.',
                'nip' => '198703152012012002',
                'email' => 'siti.aminah@dosen.siakad.ac.id',
                'prodi' => 'Teknik Informatika',
                'avatar_seed' => 'dosen-siti',
            ],
            [
                'uid' => 'dosen-003',
                'nama' => 'Budi Santoso, S.Kom., M.Sc.',
                'nip' => '198905202014021003',
                'email' => 'budi.santoso@dosen.siakad.ac.id',
                'prodi' => 'Teknik Informatika',
                'avatar_seed' => 'dosen-budi',
            ],
            [
                'uid' => 'dosen-004',
                'nama' => 'Dewi Lestari, M.T.',
                'nip' => '199108102016032004',
                'email' => 'dewi.lestari@dosen.siakad.ac.id',
                'prodi' => 'Teknik Informatika',
                'avatar_seed' => 'dosen-dewi',
            ],
            [
                'uid' => 'dosen-005',
                'nama' => 'Eko Prasetyo, M.Kom.',
                'nip' => '199312052018041005',
                'email' => 'eko.prasetyo@dosen.siakad.ac.id',
                'prodi' => 'Teknik Informatika',
                'avatar_seed' => 'dosen-eko',
            ],
        ];

        $result = [];
        foreach ($data as $d) {
            $result[$d['uid']] = Dosen::updateOrCreate(
                ['uid' => $d['uid']],
                [
                    'nama' => $d['nama'],
                    'nip' => $d['nip'],
                    'email' => $d['email'],
                    'password' => Hash::make(self::PASSWORD),
                    'photo_url' => $this->downloadFoto('dosen', $d['avatar_seed']),
                    'prodi' => $d['prodi'],
                ]
            );
        }

        return $result;
    }

    private function seedMataKuliah(): array
    {
        // 8 Semesters x 5 MataKuliah x 4 SKS = 20 SKS per semester (Total 160 SKS)
        $data = [
            // Semester 1
            ['kode' => 'IF101', 'nama' => 'Algoritma & Pemrograman', 'sks' => 4, 'semester_ke' => 1],
            ['kode' => 'IF102', 'nama' => 'Matematika Diskrit', 'sks' => 4, 'semester_ke' => 1],
            ['kode' => 'IF103', 'nama' => 'Bahasa Indonesia', 'sks' => 4, 'semester_ke' => 1],
            ['kode' => 'IF104', 'nama' => 'Pengantar Teknologi Informasi', 'sks' => 4, 'semester_ke' => 1],
            ['kode' => 'IF105', 'nama' => 'Pendidikan Pancasila', 'sks' => 4, 'semester_ke' => 1],

            // Semester 2
            ['kode' => 'IF201', 'nama' => 'Struktur Data', 'sks' => 4, 'semester_ke' => 2],
            ['kode' => 'IF202', 'nama' => 'Kalkulus Informatika', 'sks' => 4, 'semester_ke' => 2],
            ['kode' => 'IF203', 'nama' => 'Organisasi Komputer', 'sks' => 4, 'semester_ke' => 2],
            ['kode' => 'IF204', 'nama' => 'Bahasa Inggris Komunikasi', 'sks' => 4, 'semester_ke' => 2],
            ['kode' => 'IF205', 'nama' => 'Pendidikan Agama', 'sks' => 4, 'semester_ke' => 2],

            // Semester 3
            ['kode' => 'IF301', 'nama' => 'Pemrograman Web', 'sks' => 4, 'semester_ke' => 3],
            ['kode' => 'IF302', 'nama' => 'Basis Data', 'sks' => 4, 'semester_ke' => 3],
            ['kode' => 'IF303', 'nama' => 'Jaringan Komputer', 'sks' => 4, 'semester_ke' => 3],
            ['kode' => 'IF304', 'nama' => 'Sistem Operasi', 'sks' => 4, 'semester_ke' => 3],
            ['kode' => 'IF305', 'nama' => 'Rekayasa Perangkat Lunak', 'sks' => 4, 'semester_ke' => 3],

            // Semester 4
            ['kode' => 'IF401', 'nama' => 'Pemrograman Berorientasi Objek', 'sks' => 4, 'semester_ke' => 4],
            ['kode' => 'IF402', 'nama' => 'Sistem Basis Data Lanjut', 'sks' => 4, 'semester_ke' => 4],
            ['kode' => 'IF403', 'nama' => 'Keamanan Informasi', 'sks' => 4, 'semester_ke' => 4],
            ['kode' => 'IF404', 'nama' => 'Analisis & Desain Sistem', 'sks' => 4, 'semester_ke' => 4],
            ['kode' => 'IF405', 'nama' => 'Interaksi Manusia & Komputer', 'sks' => 4, 'semester_ke' => 4],

            // Semester 5
            ['kode' => 'IF501', 'nama' => 'Pemrograman Mobile', 'sks' => 4, 'semester_ke' => 5],
            ['kode' => 'IF502', 'nama' => 'Kecerdasan Buatan', 'sks' => 4, 'semester_ke' => 5],
            ['kode' => 'IF503', 'nama' => 'Pemrosesan Sinyal Digital', 'sks' => 4, 'semester_ke' => 5],
            ['kode' => 'IF504', 'nama' => 'Metodologi Penelitian', 'sks' => 4, 'semester_ke' => 5],
            ['kode' => 'IF505', 'nama' => 'Etika Profesi IT', 'sks' => 4, 'semester_ke' => 5],

            // Semester 6
            ['kode' => 'IF601', 'nama' => 'Machine Learning', 'sks' => 4, 'semester_ke' => 6],
            ['kode' => 'IF602', 'nama' => 'Cloud Computing', 'sks' => 4, 'semester_ke' => 6],
            ['kode' => 'IF603', 'nama' => 'Pengujian Perangkat Lunak', 'sks' => 4, 'semester_ke' => 6],
            ['kode' => 'IF604', 'nama' => 'Manajemen Proyek IT', 'sks' => 4, 'semester_ke' => 6],
            ['kode' => 'IF605', 'nama' => 'Kriptografi', 'sks' => 4, 'semester_ke' => 6],

            // Semester 7
            ['kode' => 'IF701', 'nama' => 'Big Data Analytics', 'sks' => 4, 'semester_ke' => 7],
            ['kode' => 'IF702', 'nama' => 'Internet of Things', 'sks' => 4, 'semester_ke' => 7],
            ['kode' => 'IF703', 'nama' => 'Kerja Praktik / Magang', 'sks' => 4, 'semester_ke' => 7],
            ['kode' => 'IF704', 'nama' => 'Kewirausahaan Digital', 'sks' => 4, 'semester_ke' => 7],
            ['kode' => 'IF705', 'nama' => 'Kapita Selekta', 'sks' => 4, 'semester_ke' => 7],

            // Semester 8
            ['kode' => 'IF801', 'nama' => 'Skripsi / Tugas Akhir', 'sks' => 4, 'semester_ke' => 8],
            ['kode' => 'IF802', 'nama' => 'Seminar Hasil', 'sks' => 4, 'semester_ke' => 8],
            ['kode' => 'IF803', 'nama' => 'Technopreneurship', 'sks' => 4, 'semester_ke' => 8],
            ['kode' => 'IF804', 'nama' => 'Tata Kelola IT', 'sks' => 4, 'semester_ke' => 8],
            ['kode' => 'IF805', 'nama' => 'Etika Profesi Lanjut', 'sks' => 4, 'semester_ke' => 8],
        ];

        $result = [];
        foreach ($data as $d) {
            $result[$d['kode']] = MataKuliah::updateOrCreate(
                ['kode' => $d['kode']],
                [
                    'nama' => $d['nama'],
                    'sks' => $d['sks'],
                    'prodi' => 'Teknik Informatika',
                    'semester_ke' => $d['semester_ke'],
                ]
            );
        }

        return $result;
    }

    private function seedKelasKuliah(array $mataKuliahList, array $dosenList): array
    {
        $dosenKeys = array_keys($dosenList);
        $hariList = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat'];
        $jamSlot = [
            ['mulai' => '08:00', 'selesai' => '10:30'],
            ['mulai' => '10:30', 'selesai' => '13:00'],
            ['mulai' => '13:30', 'selesai' => '16:00'],
        ];

        $result = [];
        $i = 0;
        foreach ($mataKuliahList as $kode => $mk) {
            $dosenKey = $dosenKeys[$i % count($dosenKeys)];
            $hari = $hariList[$i % count($hariList)];
            $slot = $jamSlot[($i / count($hariList)) % count($jamSlot)];
            $ruangan = 'R.'.(301 + ($i % 5));

            $result[$kode] = KelasKuliah::updateOrCreate(
                [
                    'mata_kuliah_id' => $mk->id,
                    'nama_kelas' => 'A',
                    'tahun_akademik' => self::TAHUN_AKADEMIK,
                    'semester' => (string) $mk->semester_ke,
                ],
                [
                    'dosen_uid' => $dosenList[$dosenKey]->uid,
                    'hari' => $hari,
                    'jam_mulai' => $slot['mulai'],
                    'jam_selesai' => $slot['selesai'],
                    'ruangan' => $ruangan,
                    'kuota' => 40,
                ]
            );
            $i++;
        }

        return $result;
    }

    private function seedMahasiswa(array $dosenList): array
    {
        $dosenKeys = array_keys($dosenList);

        $data = [
            [
                'uid' => 'mhs-001',
                'nama' => 'Khairul Huda',
                'nim' => '2025001',
                'no_hp' => '081234560001',
                'tanggal_lahir' => '2005-03-14',
                'alamat' => 'Jl. Merdeka No. 12, Bandung, Jawa Barat',
                'dosen' => $dosenKeys[0],
                'avatar_seed' => 'mhs-khairul',
            ],
            [
                'uid' => 'mhs-002',
                'nama' => 'Siti Nur Aisyah',
                'nim' => '2025002',
                'no_hp' => '081234560002',
                'tanggal_lahir' => '2005-07-22',
                'alamat' => 'Jl. Kenanga No. 5, Bandung, Jawa Barat',
                'dosen' => $dosenKeys[1],
                'avatar_seed' => 'mhs-siti',
            ],
            [
                'uid' => 'mhs-003',
                'nama' => 'Muhammad Rizky Pratama',
                'nim' => '2025003',
                'no_hp' => '081234560003',
                'tanggal_lahir' => '2004-11-30',
                'alamat' => 'Jl. Anggrek No. 8, Cimahi, Jawa Barat',
                'dosen' => $dosenKeys[2],
                'avatar_seed' => 'mhs-rizky',
            ],
            [
                'uid' => 'mhs-004',
                'nama' => 'Dewi Anggraini Putri',
                'nim' => '2025004',
                'no_hp' => '081234560004',
                'tanggal_lahir' => '2005-01-09',
                'alamat' => 'Jl. Melati No. 21, Bandung, Jawa Barat',
                'dosen' => $dosenKeys[3],
                'avatar_seed' => 'mhs-dewi',
            ],
            [
                'uid' => 'mhs-005',
                'nama' => 'Sabri Siraj',
                'nim' => '2025005',
                'no_hp' => '081234560005',
                'tanggal_lahir' => '2004-05-18',
                'alamat' => 'Jl. Ciumbuleuit No. 44, Bandung, Jawa Barat',
                'dosen' => $dosenKeys[4],
                'avatar_seed' => 'mhs-sabri',
            ],
        ];

        $result = [];
        foreach ($data as $d) {
            $email = Str::lower(Str::slug($d['nama'], '')).'@gmail.com';

            $result[$d['uid']] = Mahasiswa::updateOrCreate(
                ['uid' => $d['uid']],
                [
                    'nama' => $d['nama'],
                    'nim' => $d['nim'],
                    'email' => $email,
                    'password' => Hash::make(self::PASSWORD),
                    'no_hp' => $d['no_hp'],
                    'tanggal_lahir' => $d['tanggal_lahir'],
                    'alamat' => $d['alamat'],
                    'photo_url' => $this->downloadFoto('mahasiswa', $d['avatar_seed']),
                    'kelas' => 'TI-3A',
                    'angkatan' => '2023',
                    'prodi' => 'Teknik Informatika',
                    'dosen_pembimbing_uid' => $dosenList[$d['dosen']]->uid,
                ]
            );
        }

        return $result;
    }

    private function seedKrsDanJadwal(array $mahasiswaList, array $kelasList): void
    {
        // Seed KRS and Jadwal for current active semester (Semester 3)
        $kelasSemester3 = array_filter($kelasList, fn ($k) => (string) $k->semester === '3');

        foreach ($mahasiswaList as $mahasiswa) {
            $krs = Krs::updateOrCreate(
                [
                    'uid' => $mahasiswa->uid,
                    'tahun_akademik' => self::TAHUN_AKADEMIK,
                    'semester' => '3',
                ],
                [
                    'status' => 'disetujui',
                    'catatan_dosen' => 'KRS disetujui, silakan mengikuti perkuliahan.',
                    'disetujui_oleh' => $mahasiswa->dosen_pembimbing_uid,
                    'disetujui_at' => now(),
                ]
            );

            $krs->mataKuliah()->delete();
            JadwalKuliah::where('uid', $mahasiswa->uid)->delete();

            foreach ($kelasSemester3 as $kelas) {
                $kelas->loadMissing('mataKuliah');

                KrsMataKuliah::create([
                    'krs_id' => $krs->id,
                    'kelas_kuliah_id' => $kelas->id,
                    'nama' => $kelas->mataKuliah->nama,
                    'kode' => $kelas->mataKuliah->kode,
                    'sks' => (string) $kelas->mataKuliah->sks,
                    'kelas' => $kelas->nama_kelas,
                    'hari' => $kelas->hari,
                    'pukul' => "{$kelas->jam_mulai}-{$kelas->jam_selesai}",
                    'ruang' => $kelas->ruangan,
                    'status' => '',
                ]);

                JadwalKuliah::create([
                    'uid' => $mahasiswa->uid,
                    'hari' => $kelas->hari,
                    'mata_kuliah' => $kelas->mataKuliah->nama,
                    'jam_mulai' => $kelas->jam_mulai,
                    'jam_selesai' => $kelas->jam_selesai,
                    'ruangan' => $kelas->ruangan,
                    'keterangan' => "Semester 3 • Kelas {$kelas->nama_kelas} ({$kelas->mataKuliah->sks} SKS)",
                ]);
            }
        }
    }

    private function seedNilaiPresensiKhs(array $mahasiswaList, array $kelasList, AkademikService $akademikService): void
    {
        $polaNilai = [
            'mhs-001' => ['tugas' => 88, 'uts' => 85, 'uas' => 90],
            'mhs-002' => ['tugas' => 80, 'uts' => 78, 'uas' => 82],
            'mhs-003' => ['tugas' => 70, 'uts' => 65, 'uas' => 68],
            'mhs-004' => ['tugas' => 92, 'uts' => 95, 'uas' => 94],
            'mhs-005' => ['tugas' => 85, 'uts' => 88, 'uas' => 86],
        ];

        $polaPresensi = ['Hadir', 'Hadir', 'Hadir', 'Izin'];

        foreach ($mahasiswaList as $mahasiswa) {
            $nilai = $polaNilai[$mahasiswa->uid];

            foreach ($kelasList as $kelas) {
                $kelas->loadMissing('mataKuliah');
                $labelKelas = "{$kelas->mataKuliah->nama} - Kelas {$kelas->nama_kelas}";

                Nilai::updateOrCreate(
                    ['kelas_kuliah_id' => $kelas->id, 'mahasiswa_uid' => $mahasiswa->uid],
                    [
                        'kelas' => $labelKelas,
                        'nim' => $mahasiswa->nim,
                        'nama' => $mahasiswa->nama,
                        'tugas' => $nilai['tugas'],
                        'uts' => $nilai['uts'],
                        'uas' => $nilai['uas'],
                    ]
                );

                $akademikService->syncKhs($mahasiswa->uid, $kelas->id);

                foreach (range(1, 4) as $pertemuan) {
                    Presensi::updateOrCreate(
                        [
                            'kelas_kuliah_id' => $kelas->id,
                            'pertemuan' => $pertemuan,
                            'mahasiswa_uid' => $mahasiswa->uid,
                        ],
                        [
                            'kelas' => $labelKelas,
                            'nim' => $mahasiswa->nim,
                            'nama' => $mahasiswa->nama,
                            'keterangan' => $pertemuan === 4 ? $polaPresensi[3] : $polaPresensi[0],
                        ]
                    );
                }
            }
        }
    }

    private function seedTagihan(array $mahasiswaList): void
    {
        $statusPerMahasiswa = [
            'mhs-001' => 'Lunas',
            'mhs-002' => 'Menunggu Konfirmasi',
            'mhs-003' => 'Belum Dibayar',
            'mhs-004' => 'Lunas',
            'mhs-005' => 'Lunas',
        ];

        foreach ($mahasiswaList as $mahasiswa) {
            $status = $statusPerMahasiswa[$mahasiswa->uid];

            Tagihan::updateOrCreate(
                ['uid' => $mahasiswa->uid, 'jenis' => 'SPP Semester 3 2025/2026'],
                [
                    'nominal' => 3500000,
                    'status' => $status,
                    'jatuh_tempo' => now()->addDays(14)->toDateString(),
                    'metode_pembayaran' => 'Transfer Bank',
                    'bank_tujuan' => 'Bank Mandiri',
                    'no_rekening' => '1300009998887',
                    'bukti_url' => $status === 'Belum Dibayar' ? '' : $this->downloadFoto('bukti-bayar', 'bukti-'.$mahasiswa->uid),
                    'catatan' => $status === 'Belum Dibayar' ? null : 'Pembayaran via transfer bank',
                    'tanggal_konfirmasi' => in_array($status, ['Menunggu Konfirmasi', 'Lunas'], true) ? now()->toDateTimeString() : '',
                    'tanggal_lunas' => $status === 'Lunas' ? now()->toDateTimeString() : '',
                ]
            );
        }
    }

    private function seedNotifikasi(array $mahasiswaList): void
    {
        foreach ($mahasiswaList as $mahasiswa) {
            Notifikasi::create([
                'uid' => $mahasiswa->uid,
                'tipe_user' => 'mahasiswa',
                'judul' => 'KRS Disetujui',
                'isi' => 'KRS Anda untuk Semester 3 2025/2026 telah disetujui oleh dosen wali.',
                'dibaca' => false,
            ]);

            Notifikasi::create([
                'uid' => $mahasiswa->uid,
                'tipe_user' => 'mahasiswa',
                'judul' => 'Tagihan SPP',
                'isi' => 'Tagihan SPP Semester 3 2025/2026 telah diterbitkan, silakan cek menu Tagihan.',
                'dibaca' => false,
            ]);
        }
    }

    private function seedInformasiKegiatan(): void
    {
        Informasi::updateOrCreate(
            ['judul' => 'Jadwal UTS Semester 3 2025/2026'],
            [
                'isi' => 'Ujian Tengah Semester akan dilaksanakan mulai 20 Oktober 2026. Silakan cek jadwal masing-masing mata kuliah.',
                'tanggal' => now()->toDateTimeString(),
                'gambar_url' => $this->downloadFoto('informasi', 'informasi-uts'),
            ]
        );

        Kegiatan::updateOrCreate(
            ['judul' => 'Seminar Nasional Teknologi Informasi 2026'],
            [
                'deskripsi' => 'Seminar membahas perkembangan kecerdasan buatan dan peluang kariernya bagi mahasiswa.',
                'tanggal' => now()->addDays(10)->toDateTimeString(),
                'gambar_url' => $this->downloadFoto('kegiatan', 'kegiatan-seminar'),
                'lokasi' => 'Aula Kampus',
                'status' => 'Akan Datang',
                'pemateri' => 'Dr. Bambang Sutrisno, M.Kom',
                'kuota' => 150,
            ]
        );
    }

    private function downloadFoto(string $folder, string $seed): string
    {
        $isFoto = in_array($folder, ['mahasiswa', 'dosen'], true);
        $url = $isFoto
            ? 'https://i.pravatar.cc/500?u='.urlencode($seed)
            : 'https://picsum.photos/seed/'.urlencode($seed).'/800/500';

        try {
            $response = Http::timeout(10)->get($url);

            if (! $response->successful()) {
                Log::warning("PercobaanDataSeeder: gagal download foto {$seed} dari {$url}");

                return '';
            }

            $filename = Str::slug($seed).'.jpg';
            $path = "uploads/{$folder}/{$filename}";
            Storage::disk('public')->put($path, $response->body());

            return $path;
        } catch (\Throwable $e) {
            Log::warning("PercobaanDataSeeder: exception saat download foto {$seed}: {$e->getMessage()}");

            return '';
        }
    }
}
