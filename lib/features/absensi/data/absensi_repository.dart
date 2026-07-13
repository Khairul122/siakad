import 'package:sistem_akademik/core/constants/api_paths.dart';
import 'package:sistem_akademik/core/network/api_client.dart';
import 'package:sistem_akademik/features/absensi/domain/absensi.dart';
import 'package:sistem_akademik/features/absensi/domain/absensi_repository.dart';

class ApiAbsensiRepository implements AbsensiRepository {
  @override
  Future<List<Absensi>> fetchAllAbsensi() async {
    final data = await ApiClient.instance.get(ApiPaths.presensi);
    return (data as List? ?? [])
        .map((item) => Absensi.fromMap(Map<String, dynamic>.from(item as Map)))
        .toList();
  }
}
