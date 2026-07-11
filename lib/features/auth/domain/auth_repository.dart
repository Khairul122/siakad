abstract class AuthRepository {
  bool get isLoggedIn;

  Future<void> login(String email, String password);

  Future<void> register({
    required String nama,
    required String nim,
    required String email,
    required String password,
  });

  Future<void> sendPasswordResetOtp(String email);

  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  });

  Future<void> logout();
}
