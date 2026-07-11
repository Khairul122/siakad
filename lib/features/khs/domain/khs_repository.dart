import 'package:sistem_akademik/features/khs/domain/nilai_mata_kuliah.dart';

abstract class KhsRepository {
  Future<List<NilaiMataKuliah>> fetchKhs();
}
