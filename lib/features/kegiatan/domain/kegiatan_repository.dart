import 'package:sistem_akademik/features/kegiatan/domain/kegiatan.dart';

abstract class KegiatanRepository {
  Future<List<Kegiatan>> fetchKegiatan();
}
