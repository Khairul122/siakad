import 'package:dosen/features/presensi/domain/mahasiswa_kelas.dart';
import 'package:dosen/features/presensi/domain/presensi.dart';

abstract class PresensiRepository {
  Future<List<Presensi>> fetchPresensi(String kelas, String pertemuan);

  Future<List<MahasiswaKelas>> fetchMahasiswaByKelas(String kelas);

  Future<void> simpanPresensi({
    required String kelas,
    required String pertemuan,
    required String uid,
    required String nim,
    required String nama,
    required String keterangan,
  });
}
