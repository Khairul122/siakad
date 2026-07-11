import 'package:flutter/foundation.dart';
import 'package:sistem_akademik/features/tagihan/data/tagihan_repository.dart';
import 'package:sistem_akademik/features/tagihan/domain/tagihan.dart';
import 'package:sistem_akademik/features/tagihan/domain/tagihan_calculator.dart';
import 'package:sistem_akademik/features/tagihan/domain/tagihan_repository.dart';

class TagihanController extends ChangeNotifier {
  final TagihanRepository _repository;

  TagihanController({TagihanRepository? repository})
      : _repository = repository ?? ApiTagihanRepository() {
    load();
  }

  List<Tagihan> tagihanList = [];
  bool isLoading = true;
  bool isSubmitting = false;
  String? errorMessage;

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      tagihanList = await _repository.fetchTagihan();
    } catch (e) {
      errorMessage = 'Gagal memuat data tagihan: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() => load();

  List<Tagihan> get daftarTagihan => TagihanCalculator.daftarBelumLunas(tagihanList);

  List<Tagihan> get riwayatPembayaran => TagihanCalculator.riwayatLunas(tagihanList);

  double get totalTagihan => TagihanCalculator.totalBelumLunas(tagihanList);

  Future<bool> kirimKonfirmasi({
    required String tagihanId,
    required String buktiLocalPath,
    required String catatan,
  }) async {
    isSubmitting = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _repository.kirimKonfirmasiPembayaran(
        tagihanId: tagihanId,
        buktiLocalPath: buktiLocalPath,
        catatan: catatan,
      );
      await load();
      return true;
    } catch (e) {
      errorMessage = 'Gagal mengirim konfirmasi: $e';
      return false;
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }
}
