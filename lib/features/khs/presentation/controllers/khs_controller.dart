import 'package:flutter/foundation.dart';
import 'package:sistem_akademik/features/khs/data/khs_repository.dart';
import 'package:sistem_akademik/features/khs/domain/khs_calculator.dart';
import 'package:sistem_akademik/features/khs/domain/khs_repository.dart';
import 'package:sistem_akademik/features/khs/domain/nilai_mata_kuliah.dart';

class KhsController extends ChangeNotifier {
  final KhsRepository _repository;

  KhsController({KhsRepository? repository})
      : _repository = repository ?? ApiKhsRepository() {
    load();
  }

  List<NilaiMataKuliah> khsList = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      khsList = await _repository.fetchKhs();
    } catch (e) {
      errorMessage = 'Gagal memuat data KHS: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() => load();

  int get totalSks => KhsCalculator.totalSks(khsList);

  double get ipSemester => KhsCalculator.ipSemester(khsList);

  String get tahunAkademik =>
      khsList.isNotEmpty ? khsList.first.tahunAkademik : '-';

  String get semester => khsList.isNotEmpty ? khsList.first.semester : '-';
}
