import 'package:dosen/core/constants/api_paths.dart';
import 'package:dosen/core/network/api_client.dart';
import 'package:dosen/core/network/api_exception.dart';
import 'package:dosen/core/services/session_service.dart';
import 'package:dosen/features/auth/domain/auth_exception.dart';
import 'package:dosen/features/auth/domain/auth_repository.dart';

class ApiAuthRepository implements AuthRepository {
  final _api = ApiClient.instance;
  static const _role = 'dosen';

  @override
  bool get isLoggedIn => SessionService.instance.isLoggedIn;

  @override
  Future<void> login(String email, String password) async {
    try {
      final data = await _api.post(ApiPaths.login, body: {
        'role': _role,
        'email': email,
        'password': password,
      });

      final token = data['access_token'] as String;
      final user = data['user'] as Map<String, dynamic>;
      await SessionService.instance.save(token: token, uid: user['uid'] as String);
    } on ApiException catch (e) {
      throw AuthException(e.message);
    }
  }

  @override
  Future<void> sendPasswordResetOtp(String email) async {
    try {
      await _api.post(ApiPaths.forgotPassword, body: {'email': email});
    } on ApiException catch (e) {
      throw AuthException(e.message);
    }
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    try {
      await _api.post(ApiPaths.resetPassword, body: {
        'email': email,
        'otp': otp,
        'password': newPassword,
      });
    } on ApiException catch (e) {
      throw AuthException(e.message);
    }
  }

  @override
  Future<void> logout() async {
    await SessionService.instance.clear();
  }
}
