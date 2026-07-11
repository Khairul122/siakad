import 'package:sistem_akademik/features/jadwal/domain/jadwal_kuliah.dart';

abstract class JadwalRepository {
  Future<List<JadwalKuliah>> fetchJadwal();
}
