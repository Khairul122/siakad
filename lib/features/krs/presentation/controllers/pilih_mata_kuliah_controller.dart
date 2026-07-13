import 'package:flutter/foundation.dart';
import 'package:sistem_akademik/features/krs/data/krs_repository.dart';
import 'package:sistem_akademik/features/krs/domain/kelas_kuliah.dart';
import 'package:sistem_akademik/features/krs/domain/krs.dart';
import 'package:sistem_akademik/features/krs/domain/krs_repository.dart';

class PilihMataKuliahController extends ChangeNotifier {
  final KrsRepository _repository;
  final String? existingKrsId;

  PilihMataKuliahController({
    KrsRepository? repository,
    this.existingKrsId,
    List<int> preselectedIds = const [],
  })  : _repository = repository ?? ApiKrsRepository(),
        selectedIds = {...preselectedIds} {
    _load();
  }

  List<KelasKuliah> kelasList = [];
  Set<int> selectedIds;
  double? ips;
  int maxSks = 21;
  bool isLoading = false;
  bool isSubmitting = false;
  String? errorMessage;
  String? submitError;

  String tahunAkademik = '';
  String semester = '';

  int get totalSksTerpilih {
    return kelasList
        .where((k) => selectedIds.contains(k.id))
        .fold<int>(0, (total, k) => total + k.sks);
  }

  bool get melebihiKuota => totalSksTerpilih > maxSks;

  Future<void> _load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final kuota = await _repository.fetchKuota();
      ips = kuota.ips;
      maxSks = kuota.maxSks;
    } catch (e) {
      errorMessage = 'Gagal memuat kuota SKS: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> cariKelas(String tahunAkademikBaru, String semesterBaru) async {
    tahunAkademik = tahunAkademikBaru;
    semester = semesterBaru;
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      kelasList = await _repository.fetchKelasTersedia(
        tahunAkademik: tahunAkademik,
        semester: semester,
      );
    } catch (e) {
      errorMessage = 'Gagal memuat daftar kelas: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void toggle(int kelasId) {
    if (selectedIds.contains(kelasId)) {
      selectedIds.remove(kelasId);
    } else {
      selectedIds.add(kelasId);
    }
    notifyListeners();
  }

  Future<Krs?> submit() async {
    if (selectedIds.isEmpty || melebihiKuota) return null;

    isSubmitting = true;
    submitError = null;
    notifyListeners();

    try {
      final Krs krs;
      if (existingKrsId != null) {
        krs = await _repository.updateKrs(existingKrsId!, kelasKuliahIds: selectedIds.toList());
      } else {
        krs = await _repository.submitKrs(
          tahunAkademik: tahunAkademik,
          semester: semester,
          kelasKuliahIds: selectedIds.toList(),
        );
      }
      return krs;
    } catch (e) {
      submitError = 'Gagal mengajukan KRS: $e';
      return null;
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }
}
