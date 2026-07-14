import 'package:sistem_akademik/core/constants/api_paths.dart';
import 'package:sistem_akademik/core/network/api_client.dart';
import 'package:sistem_akademik/core/network/api_exception.dart';
import 'package:sistem_akademik/core/services/session_service.dart';
import 'package:sistem_akademik/features/auth/domain/auth_exception.dart';
import 'package:sistem_akademik/features/auth/domain/auth_repository.dart';
import 'package:uuid/uuid.dart';

class ApiAuthRepository implements AuthRepository {
  final _api = ApiClient.instance;
  static const _role = 'mahasiswa';

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
  Future<void> register({
    required String nama,
    required String nim,
    required String email,
    required String password,
  }) async {
    try {
      final uid = const Uuid().v4();
      await _api.post(ApiPaths.register, body: {
        'role': _role,
        'uid': uid,
        'nama': nama,
        'nim': nim,
        'email': email,
        'password': password,
      });
    } on ApiException catch (e) {
      throw AuthException(_firstFieldError(e) ?? e.message);
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
  Future<void> verifyPasswordResetOtp(String email, String otp) async {
    try {
      await _api.post(ApiPaths.verifyOtp, body: {'email': email, 'otp': otp});
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

  String? _firstFieldError(ApiException e) {
    final errors = e.fieldErrors;
    if (errors == null || errors.isEmpty) return null;
    final firstValue = errors.values.first;
    if (firstValue is List && firstValue.isNotEmpty) return firstValue.first.toString();
    return firstValue.toString();
  }
}
