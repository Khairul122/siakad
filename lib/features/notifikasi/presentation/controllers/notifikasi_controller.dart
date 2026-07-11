import 'package:flutter/foundation.dart';
import 'package:sistem_akademik/features/notifikasi/data/notifikasi_repository.dart';
import 'package:sistem_akademik/features/notifikasi/domain/notifikasi.dart';
import 'package:sistem_akademik/features/notifikasi/domain/notifikasi_repository.dart';

class NotifikasiController extends ChangeNotifier {
  final NotifikasiRepository _repository;

  NotifikasiController({NotifikasiRepository? repository})
      : _repository = repository ?? ApiNotifikasiRepository() {
    load();
  }

  List<Notifikasi> notifikasiList = [];
  bool isLoading = true;
  String? errorMessage;

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      notifikasiList = await _repository.fetchNotifikasi();
    } catch (e) {
      errorMessage = 'Gagal memuat notifikasi: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() => load();

  Future<void> markAsRead(String id) async {
    final index = notifikasiList.indexWhere((item) => item.id == id);
    if (index == -1 || notifikasiList[index].dibaca) return;

    try {
      await _repository.markAsRead(int.parse(id));
      notifikasiList[index] = notifikasiList[index].copyWith(dibaca: true);
      notifyListeners();
    } catch (e) {
      errorMessage = 'Gagal menandai notifikasi: $e';
      notifyListeners();
    }
  }
}
