import 'package:dosen/core/constants/api_paths.dart';
import 'package:dosen/core/network/api_client.dart';
import 'package:dosen/features/nilai/domain/mahasiswa_kelas.dart';
import 'package:dosen/features/nilai/domain/nilai.dart';
import 'package:dosen/features/nilai/domain/nilai_repository.dart';

class ApiNilaiRepository implements NilaiRepository {
  @override
  Future<List<Nilai>> fetchNilai(int kelasKuliahId) async {
    final data = await ApiClient.instance.get(ApiPaths.nilai, query: {'kelas_kuliah_id': kelasKuliahId});
    return (data as List? ?? []).map((e) => Nilai.fromMap(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<MahasiswaKelas>> fetchMahasiswaByKelas(int kelasKuliahId) async {
    final data = await ApiClient.instance.get(ApiPaths.kelasKuliahPeserta(kelasKuliahId));
    final list = (data as List? ?? []).map((e) => MahasiswaKelas.fromMap(e as Map<String, dynamic>)).toList();
    list.sort((a, b) => a.nama.compareTo(b.nama));
    return list;
  }

  @override
  Future<void> simpanNilai({
    required int kelasKuliahId,
    required String uid,
    required String nim,
    required String nama,
    required int tugas,
    required int uts,
    required int uas,
  }) async {
    if (uid.isEmpty) throw Exception('UID mahasiswa kosong.');
    await ApiClient.instance.put(
      ApiPaths.nilaiItem(kelasKuliahId, uid),
      body: {
        'nim': nim,
        'nama': nama,
        'tugas': tugas.clamp(0, 100),
        'uts': uts.clamp(0, 100),
        'uas': uas.clamp(0, 100),
      },
    );
  }
}
