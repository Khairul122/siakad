import 'package:sistem_akademik/core/constants/api_paths.dart';
import 'package:sistem_akademik/core/network/api_client.dart';
import 'package:sistem_akademik/features/krs/domain/krs.dart';
import 'package:sistem_akademik/features/krs/domain/krs_repository.dart';

class ApiKrsRepository implements KrsRepository {
  final _api = ApiClient.instance;

  @override
  Future<Krs?> fetchKrs() async {
    final data = await _api.get(ApiPaths.krs) as List<dynamic>;
    if (data.isEmpty) return null;
    final item = data.first;
    return Krs.fromMap('${item['id']}', Map<String, dynamic>.from(item as Map));
  }
}
