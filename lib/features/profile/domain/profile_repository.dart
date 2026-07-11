import 'package:dosen/features/auth/domain/dosen.dart';

abstract class ProfileRepository {
  Future<Dosen?> fetchCurrentDosen();

  Future<void> updateProfil({
    required String nama,
    required String prodi,
  });

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  });
}
