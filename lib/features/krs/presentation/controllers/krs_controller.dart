import 'package:flutter/foundation.dart';
import 'package:sistem_akademik/features/krs/data/krs_repository.dart';
import 'package:sistem_akademik/features/krs/domain/krs.dart';
import 'package:sistem_akademik/features/krs/domain/krs_repository.dart';

class KrsController extends ChangeNotifier {
  final KrsRepository _repository;

  KrsController({KrsRepository? repository})
      : _repository = repository ?? ApiKrsRepository() {
    load();
  }

  Krs? krs;
  bool isLoading = false;
  String? errorMessage;

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      krs = await _repository.fetchKrs();
    } catch (e) {
      errorMessage = 'Gagal memuat KRS: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() => load();
}
