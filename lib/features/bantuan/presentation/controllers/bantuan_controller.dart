import 'package:flutter/foundation.dart';
import 'package:dosen/features/bantuan/data/bantuan_repository.dart';
import 'package:dosen/features/bantuan/domain/bantuan_repository.dart';

class BantuanController extends ChangeNotifier {
  final BantuanRepository _repository;

  BantuanController({BantuanRepository? repository})
      : _repository = repository ?? ApiBantuanRepository();

  bool isSaving = false;
  String? errorMessage;

  Future<bool> kirimMasukan(String kategori, String pesan) async {
    if (kategori.trim().isEmpty || pesan.trim().isEmpty) {
      errorMessage = 'Kategori dan pesan tidak boleh kosong';
      notifyListeners();
      return false;
    }

    isSaving = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _repository.kirimMasukan(kategori: kategori.trim(), pesan: pesan.trim());
      return true;
    } catch (e) {
      errorMessage = 'Gagal mengirim masukan: $e';
      return false;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }
}
