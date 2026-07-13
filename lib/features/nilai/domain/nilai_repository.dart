import 'package:dosen/features/nilai/domain/mahasiswa_kelas.dart';
import 'package:dosen/features/nilai/domain/nilai.dart';

abstract class NilaiRepository {
  Future<List<Nilai>> fetchNilai(int kelasKuliahId);

  Future<List<MahasiswaKelas>> fetchMahasiswaByKelas(int kelasKuliahId);

  Future<void> simpanNilai({
    required int kelasKuliahId,
    required String uid,
    required String nim,
    required String nama,
    required int tugas,
    required int uts,
    required int uas,
  });
}
