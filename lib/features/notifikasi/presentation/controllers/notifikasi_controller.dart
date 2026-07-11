import 'package:flutter/foundation.dart';
import 'package:dosen/features/notifikasi/data/notifikasi_repository.dart';
import 'package:dosen/features/notifikasi/domain/notifikasi.dart';
import 'package:dosen/features/notifikasi/domain/notifikasi_repository.dart';

class NotifikasiController extends ChangeNotifier {
  final NotifikasiRepository _repository;

  NotifikasiController({NotifikasiRepository? repository})
      : _repository = repository ?? ApiNotifikasiRepository() {
    load();
  }

  List<Notifikasi> notifikasiList = [];
  bool isLoading = false;
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

  Future<void> markAsRead(int id) async {
    await _repository.markAsRead(id);
    final index = notifikasiList.indexWhere((n) => n.id == id);
    if (index != -1) {
      final old = notifikasiList[index];
      notifikasiList[index] = Notifikasi(
        id: old.id,
        uid: old.uid,
        judul: old.judul,
        isi: old.isi,
        dibaca: true,
        createdAt: old.createdAt,
      );
      notifyListeners();
    }
  }
}
