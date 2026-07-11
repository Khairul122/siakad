import 'package:flutter/foundation.dart';
import 'package:dosen/features/auth/data/auth_repository.dart';
import 'package:dosen/features/auth/domain/auth_exception.dart';
import 'package:dosen/features/auth/domain/auth_repository.dart';

class AuthController extends ChangeNotifier {
  final AuthRepository _repository;

  AuthController({AuthRepository? repository})
      : _repository = repository ?? ApiAuthRepository();

  bool isLoading = false;
  String? errorMessage;

  Future<bool> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      errorMessage = 'Harap isi email dan password';
      notifyListeners();
      return false;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _repository.login(email, password);
      return true;
    } on AuthException catch (e) {
      errorMessage = e.message;
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> sendPasswordResetOtp(String email) async {
    if (email.isEmpty) {
      errorMessage = 'Email tidak boleh kosong';
      notifyListeners();
      return false;
    }
    if (!RegExp(r'^[\w\-.]+@([\w\-]+\.)+[\w\-]{2,4}$').hasMatch(email)) {
      errorMessage = 'Format email tidak valid';
      notifyListeners();
      return false;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _repository.sendPasswordResetOtp(email);
      return true;
    } on AuthException catch (e) {
      errorMessage = e.message;
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  bool isValidOtpFormat(String code) => code.length == 4;

  Future<bool> resetPassword({
    required String email,
    required String otp,
    required String password,
    required String confirm,
  }) async {
    if (password.isEmpty || confirm.isEmpty) {
      errorMessage = 'Isi semua kolom terlebih dahulu';
      notifyListeners();
      return false;
    }
    if (password != confirm) {
      errorMessage = 'Password tidak sama, coba lagi.';
      notifyListeners();
      return false;
    }
    if (password.length < 6) {
      errorMessage = 'Password minimal 6 karakter';
      notifyListeners();
      return false;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _repository.resetPassword(email: email, otp: otp, newPassword: password);
      return true;
    } on AuthException catch (e) {
      errorMessage = e.message;
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() => _repository.logout();
}
