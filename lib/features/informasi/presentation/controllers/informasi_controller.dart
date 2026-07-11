import 'package:flutter/foundation.dart';
import 'package:sistem_akademik/features/informasi/data/informasi_repository.dart';
import 'package:sistem_akademik/features/informasi/domain/informasi.dart';
import 'package:sistem_akademik/features/informasi/domain/informasi_repository.dart';

class InformasiController extends ChangeNotifier {
  final InformasiRepository _repository;

  InformasiController({InformasiRepository? repository})
      : _repository = repository ?? ApiInformasiRepository() {
    load();
  }

  List<Informasi> informasiList = [];
  bool isLoading = true;
  String? errorMessage;

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      informasiList = await _repository.fetchInformasi();
    } catch (e) {
      errorMessage = 'Gagal memuat informasi: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() => load();
}
