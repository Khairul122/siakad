import 'package:flutter/foundation.dart';
import 'package:sistem_akademik/features/auth/domain/app_user.dart';
import 'package:sistem_akademik/features/profile/data/profile_repository.dart';
import 'package:sistem_akademik/features/profile/domain/profile_repository.dart';

class ProfileController extends ChangeNotifier {
  final ProfileRepository _repository;

  bool _disposed = false;

  ProfileController({ProfileRepository? repository})
      : _repository = repository ?? ApiProfileRepository() {
    load();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  AppUser? user;
  bool isLoading = false;
  bool isSaving = false;
  bool isUploadingPhoto = false;
  String? errorMessage;

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      user = await _repository.fetchCurrentUser();
    } catch (e) {
      errorMessage = 'Gagal memuat profil: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() => load();

  Future<bool> saveProfile({
    required String nama,
    required String noHp,
    required String tanggalLahir,
    required String alamat,
    required String kelas,
    required String angkatan,
    required String prodi,
    required String fakultas,
  }) async {
    if (nama.isEmpty) {
      errorMessage = 'Nama tidak boleh kosong';
      notifyListeners();
      return false;
    }

    isSaving = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _repository.updateProfile(
        nama: nama,
        noHp: noHp,
        tanggalLahir: tanggalLahir,
        alamat: alamat,
        kelas: kelas,
        angkatan: angkatan,
        prodi: prodi,
        fakultas: fakultas,
      );
      await load();
      return true;
    } catch (e) {
      errorMessage = 'Gagal menyimpan: $e';
      return false;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> uploadPhoto(String localFilePath) async {
    isUploadingPhoto = true;
    errorMessage = null;
    notifyListeners();

    try {
      final downloadUrl = await _repository.uploadProfilePhoto(localFilePath);
      await _repository.updatePhotoUrl(downloadUrl);
      await load();
      return true;
    } catch (e) {
      errorMessage = 'Gagal upload foto: $e';
      return false;
    } finally {
      isUploadingPhoto = false;
      notifyListeners();
    }
  }
}
