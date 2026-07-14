abstract class AuthRepository {
  bool get isLoggedIn;

  Future<void> login(String email, String password);

  Future<void> sendPasswordResetOtp(String email);

  Future<void> verifyPasswordResetOtp(String email, String otp);

  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  });

  Future<void> logout();
}
