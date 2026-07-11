import 'package:sistem_akademik/features/tagihan/domain/tagihan.dart';

abstract class TagihanRepository {
  Future<List<Tagihan>> fetchTagihan();

  Future<void> kirimKonfirmasiPembayaran({
    required String tagihanId,
    required String buktiLocalPath,
    String catatan = '',
  });
}
