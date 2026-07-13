import 'package:dosen/core/constants/api_paths.dart';
import 'package:dosen/core/network/api_client.dart';
import 'package:dosen/features/krs_approval/domain/krs_approval_repository.dart';
import 'package:dosen/features/krs_approval/domain/pengajuan_krs.dart';

class ApiKrsApprovalRepository implements KrsApprovalRepository {
  final _api = ApiClient.instance;

  @override
  Future<List<PengajuanKrs>> fetchPengajuan({String? status}) async {
    final data = await _api.get(
      ApiPaths.krs,
      query: status != null ? {'status': status} : null,
    ) as List<dynamic>;

    return data.map((item) => PengajuanKrs.fromMap(Map<String, dynamic>.from(item as Map))).toList();
  }

  @override
  Future<PengajuanKrs> approve(int id, {String? catatan}) async {
    final data = await _api.post(
      ApiPaths.krsApprove(id),
      body: catatan != null ? {'catatan': catatan} : null,
    ) as Map<String, dynamic>;

    return PengajuanKrs.fromMap(data);
  }

  @override
  Future<PengajuanKrs> reject(int id, {required String catatan}) async {
    final data = await _api.post(
      ApiPaths.krsReject(id),
      body: {'catatan': catatan},
    ) as Map<String, dynamic>;

    return PengajuanKrs.fromMap(data);
  }
}
