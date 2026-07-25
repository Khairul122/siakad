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

  void updatePeriode(String tahunAkademikBaru, String semesterBaru) {
    tahunAkademik = tahunAkademikBaru;
    semester = semesterBaru;
  }

  Future<void> cariKelas(String tahunAkademikBaru, String semesterBaru) async {
    updatePeriode(tahunAkademikBaru, semesterBaru);
    if (tahunAkademik.trim().isEmpty || semester.trim().isEmpty) {
      kelasList = [];
      errorMessage = null;
      notifyListeners();
      return;
    }

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

  Future<Krs?> submit({String? inputTahunAkademik, String? inputSemester}) async {
    if (inputTahunAkademik != null && inputTahunAkademik.isNotEmpty) {
      tahunAkademik = inputTahunAkademik;
    }
    if (inputSemester != null && inputSemester.isNotEmpty) {
      semester = inputSemester;
    }

    final selectedKelasList = kelasList.where((k) => selectedIds.contains(k.id)).toList();
    if (selectedKelasList.isNotEmpty) {
      if (tahunAkademik.isEmpty && selectedKelasList.first.tahunAkademik.isNotEmpty) {
        tahunAkademik = selectedKelasList.first.tahunAkademik;
      }
      if (semester.isEmpty && selectedKelasList.first.semester.isNotEmpty) {
        semester = selectedKelasList.first.semester;
      }
    }

    if (selectedIds.isEmpty || melebihiKuota) return null;

    if (existingKrsId == null && (tahunAkademik.isEmpty || semester.isEmpty)) {
      submitError = 'Gagal mengajukan KRS: Tahun akademik dan semester wajib diisi.';
      notifyListeners();
      return null;
    }

    isSubmitting = true;
    submitError = null;
    notifyListeners();

    try {
      final Krs krs;
      if (existingKrsId != null) {
        krs = await _repository.updateKrs(
          existingKrsId!,
          kelasKuliahIds: selectedIds.toList(),
          tahunAkademik: tahunAkademik.isNotEmpty ? tahunAkademik : null,
          semester: semester.isNotEmpty ? semester : null,
        );
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
