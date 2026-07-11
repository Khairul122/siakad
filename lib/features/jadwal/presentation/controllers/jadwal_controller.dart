import 'package:flutter/foundation.dart';
import 'package:sistem_akademik/features/jadwal/data/jadwal_repository.dart';
import 'package:sistem_akademik/features/jadwal/domain/jadwal_kuliah.dart';
import 'package:sistem_akademik/features/jadwal/domain/jadwal_repository.dart';

class JadwalController extends ChangeNotifier {
  final JadwalRepository _repository;

  JadwalController({JadwalRepository? repository})
      : _repository = repository ?? ApiJadwalRepository() {
    load();
  }

  List<JadwalKuliah> jadwalList = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      jadwalList = await _repository.fetchJadwal();
    } catch (e) {
      errorMessage = 'Gagal memuat jadwal: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() => load();
}
