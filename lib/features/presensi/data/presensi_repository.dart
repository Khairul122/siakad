import 'package:dosen/core/constants/api_paths.dart';
import 'package:dosen/core/network/api_client.dart';
import 'package:dosen/features/presensi/domain/mahasiswa_kelas.dart';
import 'package:dosen/features/presensi/domain/presensi.dart';
import 'package:dosen/features/presensi/domain/presensi_repository.dart';

class ApiPresensiRepository implements PresensiRepository {
  @override
  Future<List<Presensi>> fetchPresensi(int kelasKuliahId, String pertemuan) async {
    final data = await ApiClient.instance.get(
      ApiPaths.presensi,
      query: {'kelas_kuliah_id': kelasKuliahId, 'pertemuan': pertemuan},
    );
    return (data as List? ?? []).map((e) => Presensi.fromMap(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<MahasiswaKelas>> fetchMahasiswaByKelas(int kelasKuliahId) async {
    final data = await ApiClient.instance.get(ApiPaths.kelasKuliahPeserta(kelasKuliahId));
    final list = (data as List? ?? []).map((e) => MahasiswaKelas.fromMap(e as Map<String, dynamic>)).toList();
    list.sort((a, b) => a.nama.compareTo(b.nama));
    return list;
  }

  @override
  Future<void> simpanPresensi({
    required int kelasKuliahId,
    required String pertemuan,
    required String uid,
    required String nim,
    required String nama,
    required String keterangan,
  }) async {
    if (uid.isEmpty) throw Exception('UID mahasiswa kosong.');
    await ApiClient.instance.put(
      ApiPaths.presensiItem(kelasKuliahId, pertemuan, uid),
      body: {
        'nim': nim,
        'nama': nama,
        'keterangan': keterangan,
      },
    );
  }
}
