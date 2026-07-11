import 'package:dosen/core/constants/api_paths.dart';
import 'package:dosen/core/network/api_client.dart';
import 'package:dosen/core/services/session_service.dart';
import 'package:dosen/features/bimbingan/domain/bimbingan_repository.dart';
import 'package:dosen/features/bimbingan/domain/mahasiswa_bimbingan.dart';

class ApiBimbinganRepository implements BimbinganRepository {
  final _api = ApiClient.instance;

  @override
  Future<List<MahasiswaBimbingan>> fetchBimbingan() async {
    final uid = SessionService.instance.uid;
    if (uid == null) return [];

    final data = await _api.get(ApiPaths.mahasiswa, query: {'dosen_pembimbing_uid': uid});
    final list = (data as List? ?? [])
        .map((item) => MahasiswaBimbingan.fromMap(item as Map<String, dynamic>))
        .toList();
    list.sort((a, b) => a.nama.compareTo(b.nama));
    return list;
  }
}
