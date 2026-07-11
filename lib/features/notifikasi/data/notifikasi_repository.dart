import 'package:dosen/core/constants/api_paths.dart';
import 'package:dosen/core/network/api_client.dart';
import 'package:dosen/features/notifikasi/domain/notifikasi.dart';
import 'package:dosen/features/notifikasi/domain/notifikasi_repository.dart';

class ApiNotifikasiRepository implements NotifikasiRepository {
  final _api = ApiClient.instance;

  @override
  Future<List<Notifikasi>> fetchNotifikasi() async {
    final data = await _api.get(ApiPaths.notifikasi);
    final list = (data as List? ?? []);
    return list.map((item) => Notifikasi.fromMap(item as Map<String, dynamic>)).toList();
  }

  @override
  Future<void> markAsRead(int id) async {
    await _api.post(ApiPaths.notifikasiRead(id));
  }
}
