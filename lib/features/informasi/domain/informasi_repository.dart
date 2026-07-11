import 'package:sistem_akademik/features/informasi/domain/informasi.dart';

abstract class InformasiRepository {
  Future<List<Informasi>> fetchInformasi();
}
