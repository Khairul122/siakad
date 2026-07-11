import 'package:sistem_akademik/core/constants/api_paths.dart';
import 'package:sistem_akademik/core/network/api_client.dart';
import 'package:sistem_akademik/features/absensi/domain/absensi.dart';
import 'package:sistem_akademik/features/absensi/domain/absensi_repository.dart';

class ApiAbsensiRepository implements AbsensiRepository {
  @override
  Future<List<Absensi>> fetchAllAbsensi() async {
    final data = await ApiClient.instance.get(ApiPaths.absensi);
    final list = (data as List)
        .map((item) => Absensi.fromMap('${item['id']}', item as Map<String, dynamic>))
        .toList();
    return list;
  }

  @override
  Future<List<Absensi>> fetchAbsensiByMatkul(String matkul) async {
    final all = await fetchAllAbsensi();
    return all.where((a) => a.matkul == matkul).toList();
  }
}
