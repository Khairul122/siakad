import 'package:sistem_akademik/core/constants/api_paths.dart';
import 'package:sistem_akademik/core/network/api_client.dart';
import 'package:sistem_akademik/core/services/session_service.dart';
import 'package:sistem_akademik/features/auth/domain/app_user.dart';
import 'package:sistem_akademik/features/profile/domain/profile_repository.dart';

class ApiProfileRepository implements ProfileRepository {
  final _api = ApiClient.instance;

  @override
  Future<AppUser?> fetchCurrentUser() async {
    final uid = SessionService.instance.uid;
    if (uid == null) return null;

    final data = await _api.get(ApiPaths.mahasiswa(uid));
    return AppUser.fromMap(data as Map<String, dynamic>);
  }

  @override
  Future<void> updateProfile({
    required String nama,
    required String noHp,
    required String tanggalLahir,
    required String alamat,
    required String kelas,
    required String angkatan,
    required String prodi,
  }) async {
    final uid = SessionService.instance.uid;
    if (uid == null) return;

    await _api.put(ApiPaths.mahasiswa(uid), body: {
      'nama': nama,
      'no_hp': noHp,
      'tanggal_lahir': tanggalLahir,
      'alamat': alamat,
      'kelas': kelas,
      'angkatan': angkatan,
      'prodi': prodi,
    });
  }

  @override
  Future<String> uploadProfilePhoto(String localFilePath) {
    return _api.uploadFile(localFilePath, folder: 'profil');
  }

  @override
  Future<void> updatePhotoUrl(String photoUrl) async {
    final uid = SessionService.instance.uid;
    if (uid == null) return;
    await _api.put(ApiPaths.mahasiswa(uid), body: {'photo_url': photoUrl});
  }
}
