import 'package:sistem_akademik/core/constants/api_paths.dart';
import 'package:sistem_akademik/core/network/api_client.dart';
import 'package:sistem_akademik/features/khs/domain/khs_repository.dart';
import 'package:sistem_akademik/features/khs/domain/khs_ringkasan.dart';
import 'package:sistem_akademik/features/khs/domain/nilai_mata_kuliah.dart';

class ApiKhsRepository implements KhsRepository {
  final _api = ApiClient.instance;

  @override
  Future<List<NilaiMataKuliah>> fetchKhs() async {
    final data = await _api.get(ApiPaths.khs) as List<dynamic>;
    return data
        .map((item) => NilaiMataKuliah.fromMap(
              '${item['id']}',
              Map<String, dynamic>.from(item as Map),
            ))
        .toList();
  }

  @override
  Future<KhsRingkasan> fetchRingkasan() async {
    final data = await _api.get(ApiPaths.khsRingkasan) as Map<String, dynamic>;
    return KhsRingkasan.fromMap(data);
  }
}
