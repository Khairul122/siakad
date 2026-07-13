import 'package:dosen/features/presensi/domain/mahasiswa_kelas.dart';
import 'package:dosen/features/presensi/domain/presensi.dart';

abstract class PresensiRepository {
  Future<List<Presensi>> fetchPresensi(int kelasKuliahId, String pertemuan);

  Future<List<MahasiswaKelas>> fetchMahasiswaByKelas(int kelasKuliahId);

  Future<void> simpanPresensi({
    required int kelasKuliahId,
    required String pertemuan,
    required String uid,
    required String nim,
    required String nama,
    required String keterangan,
  });
}
