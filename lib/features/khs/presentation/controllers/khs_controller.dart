import 'package:flutter/foundation.dart';
import 'package:sistem_akademik/features/khs/data/khs_repository.dart';
import 'package:sistem_akademik/features/khs/domain/khs_calculator.dart';
import 'package:sistem_akademik/features/khs/domain/khs_repository.dart';
import 'package:sistem_akademik/features/khs/domain/khs_ringkasan.dart';
import 'package:sistem_akademik/features/khs/domain/nilai_mata_kuliah.dart';

class KhsController extends ChangeNotifier {
  final KhsRepository _repository;

  KhsController({KhsRepository? repository})
      : _repository = repository ?? ApiKhsRepository() {
    load();
  }

  List<NilaiMataKuliah> khsList = [];
  KhsRingkasan ringkasan = const KhsRingkasan(semester: [], ipk: null);
  bool isLoading = false;
  String? errorMessage;

  String? _selectedKey;

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      khsList = await _repository.fetchKhs();
      ringkasan = await _repository.fetchRingkasan();
      if (ringkasan.semester.isNotEmpty) {
        _selectedKey ??= _keyOf(ringkasan.semester.last.tahunAkademik, ringkasan.semester.last.semester);
      }
    } catch (e) {
      errorMessage = 'Gagal memuat data KHS: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() => load();

  String _keyOf(String tahunAkademik, String semester) => '$tahunAkademik|$semester';

  List<RingkasanSemester> get daftarSemester => ringkasan.semester;

  String? get selectedKey => _selectedKey;

  void pilihSemester(String tahunAkademik, String semester) {
    _selectedKey = _keyOf(tahunAkademik, semester);
    notifyListeners();
  }

  List<NilaiMataKuliah> get nilaiSemesterTerpilih {
    if (_selectedKey == null) return khsList;
    return khsList.where((mk) => _keyOf(mk.tahunAkademik, mk.semester) == _selectedKey).toList();
  }

  int get totalSks => KhsCalculator.totalSks(nilaiSemesterTerpilih);

  double get ipSemester => KhsCalculator.ipSemester(nilaiSemesterTerpilih);

  double? get ipk => ringkasan.ipk;

  String get tahunAkademik =>
      nilaiSemesterTerpilih.isNotEmpty ? nilaiSemesterTerpilih.first.tahunAkademik : '-';

  String get semester => nilaiSemesterTerpilih.isNotEmpty ? nilaiSemesterTerpilih.first.semester : '-';
}
