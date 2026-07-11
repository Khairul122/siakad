import 'package:flutter/foundation.dart';
import 'package:dosen/features/auth/domain/dosen.dart';
import 'package:dosen/features/profile/data/profile_repository.dart';
import 'package:dosen/features/profile/domain/profile_exception.dart';
import 'package:dosen/features/profile/domain/profile_repository.dart';

class ProfileController extends ChangeNotifier {
  final ProfileRepository _repository;

  ProfileController({ProfileRepository? repository})
      : _repository = repository ?? ApiProfileRepository() {
    load();
  }

  Dosen? dosen;
  bool isLoading = false;
  bool isSaving = false;
  String? errorMessage;

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      dosen = await _repository.fetchCurrentDosen();
    } catch (e) {
      errorMessage = 'Gagal memuat profil: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() => load();

  Future<bool> saveProfile({required String nama, required String prodi}) async {
    if (nama.isEmpty) {
      errorMessage = 'Nama tidak boleh kosong';
      notifyListeners();
      return false;
    }

    isSaving = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _repository.updateProfil(nama: nama, prodi: prodi);
      await load();
      return true;
    } catch (e) {
      errorMessage = 'Gagal: $e';
      return false;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    if (oldPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      errorMessage = 'Isi semua kolom terlebih dahulu';
      notifyListeners();
      return false;
    }
    if (newPassword != confirmPassword) {
      errorMessage = 'Konfirmasi password baru tidak sama';
      notifyListeners();
      return false;
    }
    if (newPassword.length < 6) {
      errorMessage = 'Password baru minimal 6 karakter';
      notifyListeners();
      return false;
    }

    isSaving = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _repository.changePassword(oldPassword: oldPassword, newPassword: newPassword);
      return true;
    } on ProfileException catch (e) {
      errorMessage = e.message;
      return false;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }
}
