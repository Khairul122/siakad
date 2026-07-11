import 'package:sistem_akademik/core/constants/api_paths.dart';
import 'package:sistem_akademik/core/network/api_client.dart';
import 'package:sistem_akademik/features/jadwal/domain/jadwal_kuliah.dart';
import 'package:sistem_akademik/features/jadwal/domain/jadwal_repository.dart';

class ApiJadwalRepository implements JadwalRepository {
  final _api = ApiClient.instance;

  @override
  Future<List<JadwalKuliah>> fetchJadwal() async {
    final data = await _api.get(ApiPaths.jadwalKuliah) as List<dynamic>;
    return data
        .map((item) => JadwalKuliah.fromMap(
              '${item['id']}',
              Map<String, dynamic>.from(item as Map),
            ))
        .toList();
  }
}
