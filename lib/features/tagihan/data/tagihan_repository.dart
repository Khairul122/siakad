import 'package:sistem_akademik/core/constants/api_paths.dart';
import 'package:sistem_akademik/core/network/api_client.dart';
import 'package:sistem_akademik/features/tagihan/domain/tagihan.dart';
import 'package:sistem_akademik/features/tagihan/domain/tagihan_repository.dart';

class ApiTagihanRepository implements TagihanRepository {
  final _api = ApiClient.instance;

  @override
  Future<List<Tagihan>> fetchTagihan() async {
    final data = await _api.get(ApiPaths.tagihan) as List<dynamic>;
    return data
        .map((item) => Tagihan.fromMap(
              (item as Map<String, dynamic>)['id'].toString(),
              item,
            ))
        .toList();
  }

  @override
  Future<void> kirimKonfirmasiPembayaran({
    required String tagihanId,
    required String buktiLocalPath,
    String catatan = '',
  }) async {
    final buktiUrl = await _api.uploadFile(buktiLocalPath, folder: 'tagihan');
    await _api.post(
      ApiPaths.tagihanKonfirmasi(int.parse(tagihanId)),
      body: {'bukti_url': buktiUrl, 'catatan': catatan},
    );
  }
}
