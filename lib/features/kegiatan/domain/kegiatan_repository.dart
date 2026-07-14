import 'package:sistem_akademik/features/kegiatan/domain/kegiatan.dart';

abstract class KegiatanRepository {
  Future<List<Kegiatan>> fetchKegiatan();

  Future<bool> cekStatusPendaftaran(String kegiatanId);

  Future<void> daftarKegiatan({
    required String kegiatanId,
    required String nama,
    required String nim,
    required String prodi,
    required String noHp,
  });
}
