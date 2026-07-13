class ApiPaths {
  ApiPaths._();

  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String me = '/auth/me';

  static String mahasiswa(String uid) => '/mahasiswa/$uid';

  static const String jadwalKuliah = '/jadwal-kuliah';
  static const String krs = '/krs';
  static const String krsKuota = '/krs/kuota';
  static String krsItem(String id) => '/krs/$id';
  static const String kelasKuliah = '/kelas-kuliah';
  static const String khs = '/khs';
  static const String khsRingkasan = '/khs/ringkasan';
  static const String presensi = '/presensi';
  static const String tagihan = '/tagihan';
  static String tagihanKonfirmasi(int id) => '/tagihan/$id/konfirmasi';
  static const String informasi = '/informasi';
  static const String kegiatan = '/kegiatan';
  static const String notifikasi = '/notifikasi';
  static String notifikasiRead(int id) => '/notifikasi/$id/read';

  static const String uploads = '/uploads';
}
