import 'package:sistem_akademik/features/absensi/domain/absensi.dart';

abstract class AbsensiRepository {
  Future<List<Absensi>> fetchAllAbsensi();
  Future<List<Absensi>> fetchAbsensiByMatkul(String matkul);
}
