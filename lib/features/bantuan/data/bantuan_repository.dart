import 'package:dosen/core/constants/api_paths.dart';
import 'package:dosen/core/network/api_client.dart';
import 'package:dosen/features/bantuan/domain/bantuan_repository.dart';

class ApiBantuanRepository implements BantuanRepository {
  final _api = ApiClient.instance;

  @override
  Future<void> kirimMasukan({required String kategori, required String pesan}) async {
    await _api.post(ApiPaths.masukan, body: {
      'kategori': kategori,
      'pesan': pesan,
    });
  }
}
