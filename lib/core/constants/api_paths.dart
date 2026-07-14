class ApiPaths {
  ApiPaths._();

  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String me = '/auth/me';
  static const String forgotPassword = '/auth/forgot-password';
  static const String verifyOtp = '/auth/verify-otp';
  static const String resetPassword = '/auth/reset-password';
  static const String changePassword = '/auth/change-password';

  static String dosen(String uid) => '/dosen/${Uri.encodeComponent(uid)}';

  static const String mahasiswa = '/mahasiswa';

  static const String jadwalMengajar = '/jadwal-mengajar';

  static const String krs = '/krs';
  static String krsApprove(int id) => '/krs/$id/approve';
  static String krsReject(int id) => '/krs/$id/reject';

  static String kelasKuliahPeserta(int id) => '/kelas-kuliah/$id/peserta';

  static const String nilai = '/nilai';
  static String nilaiItem(int kelasKuliahId, String mahasiswaUid) =>
      '/nilai/$kelasKuliahId/${Uri.encodeComponent(mahasiswaUid)}';

  static const String presensi = '/presensi';
  static String presensiItem(int kelasKuliahId, String pertemuan, String mahasiswaUid) =>
      '/presensi/$kelasKuliahId/${Uri.encodeComponent(pertemuan)}/${Uri.encodeComponent(mahasiswaUid)}';

  static const String informasi = '/informasi';
  static const String notifikasi = '/notifikasi';
  static String notifikasiRead(int id) => '/notifikasi/$id/read';
  static const String masukan = '/masukan';
}
