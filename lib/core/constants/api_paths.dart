class ApiPaths {
  ApiPaths._();

  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String me = '/auth/me';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String changePassword = '/auth/change-password';

  static String dosen(String uid) => '/dosen/${Uri.encodeComponent(uid)}';

  static const String mahasiswa = '/mahasiswa';

  static const String jadwalMengajar = '/jadwal-mengajar';

  static const String nilai = '/nilai';
  static String nilaiItem(String kelas, String mahasiswaUid) =>
      '/nilai/${Uri.encodeComponent(kelas)}/${Uri.encodeComponent(mahasiswaUid)}';

  static const String presensi = '/presensi';
  static String presensiItem(String kelas, String pertemuan, String mahasiswaUid) =>
      '/presensi/${Uri.encodeComponent(kelas)}/${Uri.encodeComponent(pertemuan)}/${Uri.encodeComponent(mahasiswaUid)}';

  static const String informasi = '/informasi';
  static const String notifikasi = '/notifikasi';
  static String notifikasiRead(int id) => '/notifikasi/$id/read';
  static const String masukan = '/masukan';
}
