import 'package:sistem_akademik/features/krs/domain/krs.dart';

abstract class KrsRepository {
  Future<Krs?> fetchKrs();
}
