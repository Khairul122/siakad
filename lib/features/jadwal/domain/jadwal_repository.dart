import 'package:dosen/features/jadwal/domain/jadwal_mengajar.dart';

abstract class JadwalRepository {
  Future<List<JadwalMengajar>> fetchJadwal();

  Stream<List<JadwalMengajar>> watchJadwal();
}
