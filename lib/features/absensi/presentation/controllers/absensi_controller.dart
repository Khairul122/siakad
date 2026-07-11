import 'package:flutter/foundation.dart';
import 'package:sistem_akademik/features/absensi/data/absensi_repository.dart';
import 'package:sistem_akademik/features/absensi/domain/absensi.dart';
import 'package:sistem_akademik/features/absensi/domain/absensi_repository.dart';

class AbsensiController extends ChangeNotifier {
  final AbsensiRepository _repository;
  final String? matkul;

  AbsensiController({AbsensiRepository? repository, this.matkul})
      : _repository = repository ?? ApiAbsensiRepository() {
    load();
  }

  List<Absensi> absensiList = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      absensiList = matkul == null
          ? await _repository.fetchAllAbsensi()
          : await _repository.fetchAbsensiByMatkul(matkul!);
    } catch (e) {
      errorMessage = 'Gagal memuat data absensi: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() => load();

  List<Absensi> sortedByPertemuan(List<Absensi> data) {
    final sorted = [...data];
    sorted.sort((a, b) {
      final pa = int.tryParse(a.pertemuan) ?? 0;
      final pb = int.tryParse(b.pertemuan) ?? 0;
      return pa.compareTo(pb);
    });
    return sorted;
  }

  Map<String, List<Absensi>> groupByMatkul(List<Absensi> data) {
    final Map<String, List<Absensi>> grouped = {};
    for (final item in data) {
      grouped.putIfAbsent(item.matkul, () => []).add(item);
    }
    for (final entry in grouped.entries) {
      grouped[entry.key] = sortedByPertemuan(entry.value);
    }
    return grouped;
  }
}
