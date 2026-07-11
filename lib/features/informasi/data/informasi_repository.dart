import 'package:dosen/core/constants/api_paths.dart';
import 'package:dosen/core/network/api_client.dart';
import 'package:dosen/features/informasi/domain/informasi.dart';
import 'package:dosen/features/informasi/domain/informasi_repository.dart';

class ApiInformasiRepository implements InformasiRepository {
  final _api = ApiClient.instance;

  @override
  Future<List<Informasi>> fetchInformasi() async {
    final data = await _api.get(ApiPaths.informasi);
    final list = (data as List? ?? []);
    return list.map((item) => Informasi.fromMap(item as Map<String, dynamic>)).toList();
  }
}
