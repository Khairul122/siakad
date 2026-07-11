import 'package:sistem_akademik/features/auth/domain/app_user.dart';

abstract class ProfileRepository {
  Future<AppUser?> fetchCurrentUser();

  Future<void> updateProfile({
    required String nama,
    required String noHp,
    required String tanggalLahir,
    required String alamat,
    required String kelas,
    required String angkatan,
    required String prodi,
  });

  Future<String> uploadProfilePhoto(String localFilePath);

  Future<void> updatePhotoUrl(String photoUrl);
}
