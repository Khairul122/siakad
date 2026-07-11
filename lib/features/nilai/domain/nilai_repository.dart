import 'package:dosen/features/nilai/domain/mahasiswa_kelas.dart';
import 'package:dosen/features/nilai/domain/nilai.dart';

abstract class NilaiRepository {
  Future<List<Nilai>> fetchNilai(String kelas);

  Future<List<MahasiswaKelas>> fetchMahasiswaByKelas(String kelas);

  Future<void> simpanNilai({
    required String kelas,
    required String uid,
    required String nim,
    required String nama,
    required int tugas,
    required int uts,
    required int uas,
  });
}
