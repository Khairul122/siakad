import 'package:sistem_akademik/core/constants/api_paths.dart';
import 'package:sistem_akademik/core/network/api_client.dart';
import 'package:sistem_akademik/features/kegiatan/domain/kegiatan.dart';
import 'package:sistem_akademik/features/kegiatan/domain/kegiatan_repository.dart';

class ApiKegiatanRepository implements KegiatanRepository {
  final _api = ApiClient.instance;

  @override
  Future<List<Kegiatan>> fetchKegiatan() async {
    final data = await _api.get(ApiPaths.kegiatan) as List<dynamic>;
    return data
        .map((item) => Kegiatan.fromMap(
              (item as Map<String, dynamic>)['id'].toString(),
              item,
            ))
        .toList();
  }

  @override
  Future<bool> cekStatusPendaftaran(String kegiatanId) async {
    final data = await _api.get(ApiPaths.kegiatanStatusPendaftaran(kegiatanId)) as Map<String, dynamic>;
    return data['terdaftar'] == true;
  }

  @override
  Future<void> daftarKegiatan({
    required String kegiatanId,
    required String nama,
    required String nim,
    required String prodi,
    required String noHp,
  }) async {
    await _api.post(ApiPaths.kegiatanDaftar(kegiatanId), body: {
      'nama': nama,
      'nim': nim,
      'prodi': prodi,
      'no_hp': noHp,
    });
  }
}
