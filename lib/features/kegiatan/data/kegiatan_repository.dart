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
}
