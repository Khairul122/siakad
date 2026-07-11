import 'package:flutter/foundation.dart';
import 'package:sistem_akademik/features/kegiatan/data/kegiatan_repository.dart';
import 'package:sistem_akademik/features/kegiatan/domain/kegiatan.dart';
import 'package:sistem_akademik/features/kegiatan/domain/kegiatan_repository.dart';

class KegiatanController extends ChangeNotifier {
  final KegiatanRepository _repository;

  KegiatanController({KegiatanRepository? repository})
      : _repository = repository ?? ApiKegiatanRepository() {
    load();
  }

  List<Kegiatan> kegiatanList = [];
  bool isLoading = true;
  String? errorMessage;

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      kegiatanList = await _repository.fetchKegiatan();
    } catch (e) {
      errorMessage = 'Gagal memuat kegiatan: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() => load();
}
