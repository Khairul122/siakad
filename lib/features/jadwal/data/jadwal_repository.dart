import 'package:dosen/core/constants/api_paths.dart';
import 'package:dosen/core/network/api_client.dart';
import 'package:dosen/features/jadwal/domain/jadwal_mengajar.dart';
import 'package:dosen/features/jadwal/domain/jadwal_repository.dart';

class ApiJadwalRepository implements JadwalRepository {
  final _api = ApiClient.instance;

  @override
  Future<List<JadwalMengajar>> fetchJadwal() async {
    final data = await _api.get(ApiPaths.jadwalMengajar);
    final list = (data as List? ?? []);
    return list.map((item) => JadwalMengajar.fromMap(item as Map<String, dynamic>)).toList();
  }

  @override
  Stream<List<JadwalMengajar>> watchJadwal() => Stream.fromFuture(fetchJadwal());
}
