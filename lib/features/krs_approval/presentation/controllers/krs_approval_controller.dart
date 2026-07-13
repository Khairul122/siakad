import 'package:flutter/foundation.dart';
import 'package:dosen/features/krs_approval/data/krs_approval_repository.dart';
import 'package:dosen/features/krs_approval/domain/krs_approval_repository.dart';
import 'package:dosen/features/krs_approval/domain/pengajuan_krs.dart';

class KrsApprovalController extends ChangeNotifier {
  final KrsApprovalRepository _repository;

  KrsApprovalController({KrsApprovalRepository? repository})
      : _repository = repository ?? ApiKrsApprovalRepository() {
    load();
  }

  List<PengajuanKrs> pengajuanList = [];
  bool isLoading = false;
  bool isProcessing = false;
  String? errorMessage;

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      pengajuanList = await _repository.fetchPengajuan();
    } catch (e) {
      errorMessage = 'Gagal memuat pengajuan KRS: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() => load();

  Future<String?> approve(int id, {String? catatan}) async {
    isProcessing = true;
    notifyListeners();

    try {
      final hasil = await _repository.approve(id, catatan: catatan);
      _replace(hasil);
      return null;
    } catch (e) {
      return 'Gagal menyetujui KRS: $e';
    } finally {
      isProcessing = false;
      notifyListeners();
    }
  }

  Future<String?> reject(int id, {required String catatan}) async {
    isProcessing = true;
    notifyListeners();

    try {
      final hasil = await _repository.reject(id, catatan: catatan);
      _replace(hasil);
      return null;
    } catch (e) {
      return 'Gagal menolak KRS: $e';
    } finally {
      isProcessing = false;
      notifyListeners();
    }
  }

  void _replace(PengajuanKrs hasil) {
    pengajuanList = pengajuanList.map((p) => p.id == hasil.id ? hasil : p).toList();
  }
}
