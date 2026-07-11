import 'package:dosen/core/constants/api_paths.dart';
import 'package:dosen/core/network/api_client.dart';
import 'package:dosen/features/presensi/domain/mahasiswa_kelas.dart';
import 'package:dosen/features/presensi/domain/presensi.dart';
import 'package:dosen/features/presensi/domain/presensi_repository.dart';

class ApiPresensiRepository implements PresensiRepository {
  @override
  Future<List<Presensi>> fetchPresensi(String kelas, String pertemuan) async {
    final data = await ApiClient.instance.get(
      ApiPaths.presensi,
      query: {'kelas': kelas, 'pertemuan': pertemuan},
    );
    final list = (data as List? ?? [])
        .map((e) => Presensi.fromMap(e as Map<String, dynamic>))
        .toList();
    return list;
  }

  @override
  Future<List<MahasiswaKelas>> fetchMahasiswaByKelas(String kelas) async {
    final data = await ApiClient.instance.get(ApiPaths.mahasiswa, query: {'kelas': kelas});
    var list = (data as List? ?? [])
        .map((e) => MahasiswaKelas.fromMap(e as Map<String, dynamic>))
        .toList();

    if (list.isEmpty) {
      final allData = await ApiClient.instance.get(ApiPaths.mahasiswa);
      list = (allData as List? ?? [])
          .map((e) => MahasiswaKelas.fromMap(e as Map<String, dynamic>))
          .toList();
    }

    list.sort((a, b) => a.nama.compareTo(b.nama));
    return list;
  }

  @override
  Future<void> simpanPresensi({
    required String kelas,
    required String pertemuan,
    required String uid,
    required String nim,
    required String nama,
    required String keterangan,
  }) async {
    if (uid.isEmpty) throw Exception('UID mahasiswa kosong.');
    await ApiClient.instance.put(
      ApiPaths.presensiItem(kelas, pertemuan, uid),
      body: {
        'nim': nim,
        'nama': nama,
        'keterangan': keterangan,
      },
    );
  }
}
