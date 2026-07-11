import 'package:sistem_akademik/core/constants/api_paths.dart';
import 'package:sistem_akademik/core/network/api_client.dart';
import 'package:sistem_akademik/features/informasi/domain/informasi.dart';
import 'package:sistem_akademik/features/informasi/domain/informasi_repository.dart';

class ApiInformasiRepository implements InformasiRepository {
  final _api = ApiClient.instance;

  @override
  Future<List<Informasi>> fetchInformasi() async {
    final data = await _api.get(ApiPaths.informasi) as List<dynamic>;
    return data
        .map((item) => Informasi.fromMap(
              (item as Map<String, dynamic>)['id'].toString(),
              item,
            ))
        .toList();
  }
}
