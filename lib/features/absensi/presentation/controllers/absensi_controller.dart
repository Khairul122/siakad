import 'package:flutter/foundation.dart';
import 'package:sistem_akademik/features/absensi/data/absensi_repository.dart';
import 'package:sistem_akademik/features/absensi/domain/absensi.dart';
import 'package:sistem_akademik/features/absensi/domain/absensi_repository.dart';

class AbsensiController extends ChangeNotifier {
  final AbsensiRepository _repository;
  final int? kelasKuliahId;

  AbsensiController({AbsensiRepository? repository, this.kelasKuliahId})
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
      final all = await _repository.fetchAllAbsensi();
      absensiList = kelasKuliahId == null
          ? all
          : all.where((a) => a.kelasKuliahId == kelasKuliahId).toList();
    } catch (e) {
      errorMessage = 'Gagal memuat data presensi: $e';
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

  Map<int, List<Absensi>> groupByKelas(List<Absensi> data) {
    final Map<int, List<Absensi>> grouped = {};
    for (final item in data) {
      grouped.putIfAbsent(item.kelasKuliahId, () => []).add(item);
    }
    for (final entry in grouped.entries) {
      grouped[entry.key] = sortedByPertemuan(entry.value);
    }
    return grouped;
  }
}
