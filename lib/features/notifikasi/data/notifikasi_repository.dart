import 'package:sistem_akademik/core/constants/api_paths.dart';
import 'package:sistem_akademik/core/network/api_client.dart';
import 'package:sistem_akademik/features/notifikasi/domain/notifikasi.dart';
import 'package:sistem_akademik/features/notifikasi/domain/notifikasi_repository.dart';

class ApiNotifikasiRepository implements NotifikasiRepository {
  final _api = ApiClient.instance;

  @override
  Future<List<Notifikasi>> fetchNotifikasi() async {
    final data = await _api.get(ApiPaths.notifikasi) as List<dynamic>;
    return data
        .map((item) => Notifikasi.fromMap(
              (item as Map<String, dynamic>)['id'].toString(),
              item,
            ))
        .toList();
  }

  @override
  Future<void> markAsRead(int id) async {
    await _api.post(ApiPaths.notifikasiRead(id));
  }
}
