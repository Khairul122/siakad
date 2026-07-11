import 'package:flutter/foundation.dart';
import 'package:dosen/features/bimbingan/data/bimbingan_repository.dart';
import 'package:dosen/features/bimbingan/domain/bimbingan_repository.dart';
import 'package:dosen/features/bimbingan/domain/mahasiswa_bimbingan.dart';

class BimbinganController extends ChangeNotifier {
  final BimbinganRepository _repository;

  BimbinganController({BimbinganRepository? repository})
      : _repository = repository ?? ApiBimbinganRepository() {
    load();
  }

  List<MahasiswaBimbingan> bimbinganList = [];
  bool isLoading = false;
  String? errorMessage;

  String? _selectedAngkatan;
  String? get selectedAngkatan => _selectedAngkatan;

  void setAngkatan(String? angkatan) {
    _selectedAngkatan = angkatan;
    notifyListeners();
  }

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      bimbinganList = await _repository.fetchBimbingan();
    } catch (e) {
      errorMessage = 'Gagal memuat data bimbingan: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() => load();

  List<MahasiswaBimbingan> filter(List<MahasiswaBimbingan> data) {
    if (_selectedAngkatan == null) return data;
    return data.where((mhs) => mhs.angkatan == _selectedAngkatan).toList();
  }
}
