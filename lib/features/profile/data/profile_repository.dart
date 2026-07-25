import 'package:dosen/core/constants/api_paths.dart';
import 'package:dosen/core/network/api_client.dart';
import 'package:dosen/core/network/api_exception.dart';
import 'package:dosen/core/services/session_service.dart';
import 'package:dosen/features/auth/domain/dosen.dart';
import 'package:dosen/features/profile/domain/profile_exception.dart';
import 'package:dosen/features/profile/domain/profile_repository.dart';

class ApiProfileRepository implements ProfileRepository {
  final _api = ApiClient.instance;

  @override
  Future<Dosen?> fetchCurrentDosen() async {
    final uid = SessionService.instance.uid;
    if (uid == null) return null;

    final data = await _api.get(ApiPaths.dosen(uid));
    return Dosen.fromMap(data as Map<String, dynamic>);
  }

  @override
  Future<void> updateProfil({
    required String nama,
    required String prodi,
  }) async {
    final uid = SessionService.instance.uid;
    if (uid == null) return;

    await _api.put(ApiPaths.dosen(uid), body: {
      'nama': nama,
      'prodi': prodi,
    });
  }

  @override
  Future<String> uploadProfilePhoto(String localFilePath) {
    return _api.uploadFile(localFilePath, folder: 'dosen');
  }

  @override
  Future<void> updatePhotoUrl(String photoUrl) async {
    final uid = SessionService.instance.uid;
    if (uid == null) return;
    await _api.put(ApiPaths.dosen(uid), body: {'photo_url': photoUrl});
  }

  @override
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      await _api.post(ApiPaths.changePassword, body: {
        'old_password': oldPassword,
        'new_password': newPassword,
      });
    } on ApiException catch (e) {
      throw ProfileException(e.message);
    }
  }
}
