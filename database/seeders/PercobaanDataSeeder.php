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
 * Seeder data percobaan/demo untuk seluruh alur SIAKAD (dosen, mata kuliah, kelas,
 * mahasiswa, KRS, jadwal, nilai, presensi, KHS, tagihan, notifikasi, informasi, kegiatan).
 * Jalankan: php artisan db:seed --class=PercobaanDataSeeder
 */
class PercobaanDataSeeder extends Seeder
{
    private const PASSWORD = 'password';

    private const TAHUN_AKADEMIK = '2025/2026';

    private const SEMESTER = '3';

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

        $this->command?->info('Data percobaan SIAKAD berhasil dibuat (4 mahasiswa, password: '.self::PASSWORD.').');
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
                'nama' => 'Siti Aminah, M.T.',
                'nip' => '198703152012012002',
                'email' => 'siti.aminah@dosen.siakad.ac.id',
                'prodi' => 'Teknik Informatika',
                'avatar_seed' => 'dosen-siti',
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
        $data = [
            ['kode' => 'IF301', 'nama' => 'Pemrograman Web', 'sks' => 3, 'semester_ke' => 3],
            ['kode' => 'IF302', 'nama' => 'Basis Data', 'sks' => 3, 'semester_ke' => 3],
            ['kode' => 'IF303', 'nama' => 'Struktur Data', 'sks' => 3, 'semester_ke' => 3],
            ['kode' => 'IF304', 'nama' => 'Jaringan Komputer', 'sks' => 2, 'semester_ke' => 3],
            ['kode' => 'IF305', 'nama' => 'Matematika Diskrit', 'sks' => 2, 'semester_ke' => 3],
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
        $data = [
            ['kode' => 'IF301', 'dosen' => 'dosen-001', 'hari' => 'Senin', 'mulai' => '08:00', 'selesai' => '10:30', 'ruangan' => 'R.301', 'kuota' => 40],
            ['kode' => 'IF302', 'dosen' => 'dosen-002', 'hari' => 'Senin', 'mulai' => '10:30', 'selesai' => '13:00', 'ruangan' => 'R.302', 'kuota' => 40],
            ['kode' => 'IF303', 'dosen' => 'dosen-001', 'hari' => 'Selasa', 'mulai' => '08:00', 'selesai' => '10:30', 'ruangan' => 'R.303', 'kuota' => 40],
            ['kode' => 'IF304', 'dosen' => 'dosen-002', 'hari' => 'Rabu', 'mulai' => '08:00', 'selesai' => '09:40', 'ruangan' => 'Lab. Jaringan', 'kuota' => 35],
            ['kode' => 'IF305', 'dosen' => 'dosen-001', 'hari' => 'Kamis', 'mulai' => '08:00', 'selesai' => '09:40', 'ruangan' => 'R.301', 'kuota' => 40],
        ];

        $result = [];
        foreach ($data as $d) {
            $mataKuliah = $mataKuliahList[$d['kode']];

            $result[$d['kode']] = KelasKuliah::updateOrCreate(
                [
                    'mata_kuliah_id' => $mataKuliah->id,
                    'nama_kelas' => 'A',
                    'tahun_akademik' => self::TAHUN_AKADEMIK,
                    'semester' => self::SEMESTER,
                ],
                [
                    'dosen_uid' => $dosenList[$d['dosen']]->uid,
                    'hari' => $d['hari'],
                    'jam_mulai' => $d['mulai'],
                    'jam_selesai' => $d['selesai'],
                    'ruangan' => $d['ruangan'],
                    'kuota' => $d['kuota'],
                ]
            );
        }

        return $result;
    }

    private function seedMahasiswa(array $dosenList): array
    {
        $data = [
            [
                'uid' => 'mhs-001',
                'nama' => 'Ahmad Fauzan Ramadhan',
                'nim' => '2023010001',
                'no_hp' => '081234560001',
                'tanggal_lahir' => '2005-03-14',
                'alamat' => 'Jl. Merdeka No. 12, Bandung, Jawa Barat',
                'dosen' => 'dosen-001',
                'avatar_seed' => 'mhs-ahmad',
            ],
            [
                'uid' => 'mhs-002',
                'nama' => 'Siti Nur Aisyah',
                'nim' => '2023010002',
                'no_hp' => '081234560002',
                'tanggal_lahir' => '2005-07-22',
                'alamat' => 'Jl. Kenanga No. 5, Bandung, Jawa Barat',
                'dosen' => 'dosen-001',
                'avatar_seed' => 'mhs-siti',
            ],
            [
                'uid' => 'mhs-003',
                'nama' => 'Muhammad Rizky Pratama',
                'nim' => '2023010003',
                'no_hp' => '081234560003',
                'tanggal_lahir' => '2004-11-30',
                'alamat' => 'Jl. Anggrek No. 8, Cimahi, Jawa Barat',
                'dosen' => 'dosen-002',
                'avatar_seed' => 'mhs-rizky',
            ],
            [
                'uid' => 'mhs-004',
                'nama' => 'Dewi Anggraini Putri',
                'nim' => '2023010004',
                'no_hp' => '081234560004',
                'tanggal_lahir' => '2005-01-09',
                'alamat' => 'Jl. Melati No. 21, Bandung, Jawa Barat',
                'dosen' => 'dosen-002',
                'avatar_seed' => 'mhs-dewi',
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
        foreach ($mahasiswaList as $mahasiswa) {
            $krs = Krs::updateOrCreate(
                [
                    'uid' => $mahasiswa->uid,
                    'tahun_akademik' => self::TAHUN_AKADEMIK,
                    'semester' => self::SEMESTER,
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

            foreach ($kelasList as $kelas) {
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
        // Variasi nilai per mahasiswa supaya IPS/IPK tidak seragam.
        $polaNilai = [
            'mhs-001' => ['tugas' => 88, 'uts' => 85, 'uas' => 90],
            'mhs-002' => ['tugas' => 80, 'uts' => 78, 'uas' => 82],
            'mhs-003' => ['tugas' => 70, 'uts' => 65, 'uas' => 68],
            'mhs-004' => ['tugas' => 92, 'uts' => 95, 'uas' => 94],
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
        ];

        foreach ($mahasiswaList as $mahasiswa) {
            $status = $statusPerMahasiswa[$mahasiswa->uid];

            Tagihan::updateOrCreate(
                ['uid' => $mahasiswa->uid, 'jenis' => 'SPP Semester Ganjil 2025/2026'],
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
                'isi' => 'KRS Anda untuk semester Ganjil 2025/2026 telah disetujui oleh dosen wali.',
                'dibaca' => false,
            ]);

            Notifikasi::create([
                'uid' => $mahasiswa->uid,
                'tipe_user' => 'mahasiswa',
                'judul' => 'Tagihan SPP',
                'isi' => 'Tagihan SPP semester Ganjil 2025/2026 telah diterbitkan, silakan cek menu Tagihan.',
                'dibaca' => false,
            ]);
        }
    }

    private function seedInformasiKegiatan(): void
    {
        Informasi::updateOrCreate(
            ['judul' => 'Jadwal UTS Semester Ganjil 2025/2026'],
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

    /**
     * Download foto acak dari internet (Pravatar/Picsum) dan simpan ke storage lokal,
     * mengembalikan path relatif (konsisten dengan HasDynamicStorageUrls::cleanStoragePath).
     */
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
