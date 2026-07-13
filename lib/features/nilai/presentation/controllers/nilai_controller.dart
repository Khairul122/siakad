import 'package:flutter/foundation.dart';
import 'package:dosen/features/jadwal/data/jadwal_repository.dart';
import 'package:dosen/features/jadwal/domain/jadwal_mengajar.dart';
import 'package:dosen/features/jadwal/domain/jadwal_repository.dart';
import 'package:dosen/features/nilai/data/nilai_repository.dart';
import 'package:dosen/features/nilai/domain/mahasiswa_kelas.dart';
import 'package:dosen/features/nilai/domain/nilai.dart';
import 'package:dosen/features/nilai/domain/nilai_repository.dart';

class NilaiController extends ChangeNotifier {
  final NilaiRepository _repository;
  final JadwalRepository _jadwalRepository;

  NilaiController({NilaiRepository? repository, JadwalRepository? jadwalRepository})
      : _repository = repository ?? ApiNilaiRepository(),
        _jadwalRepository = jadwalRepository ?? ApiJadwalRepository();

  List<JadwalMengajar> kelasList = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      kelasList = await _jadwalRepository.watchJadwal().first;
    } catch (e) {
      errorMessage = 'Gagal memuat kelas: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() => load();

  List<Nilai> nilaiList = [];
  List<MahasiswaKelas> mahasiswaList = [];
  bool isLoadingDetail = false;

  Future<void> loadDetail(int kelasKuliahId) async {
    isLoadingDetail = true;
    errorMessage = null;
    notifyListeners();

    try {
      nilaiList = await _repository.fetchNilai(kelasKuliahId);
      mahasiswaList = await _repository.fetchMahasiswaByKelas(kelasKuliahId);
    } catch (e) {
      errorMessage = 'Gagal memuat data: $e';
    } finally {
      isLoadingDetail = false;
      notifyListeners();
    }
  }

  Future<void> refreshDetail(int kelasKuliahId) => loadDetail(kelasKuliahId);

  bool isSaving = false;

  Future<bool> saveAll({
    required int kelasKuliahId,
    required List<MahasiswaKelas> mahasiswaList,
    required Map<String, Map<String, int>> nilaiInput,
  }) async {
    isSaving = true;
    errorMessage = null;
    notifyListeners();

    try {
      for (final mhs in mahasiswaList) {
        if (mhs.uid.isEmpty) continue;
        final input = nilaiInput[mhs.uid];
        if (input == null) continue;
        await _repository.simpanNilai(
          kelasKuliahId: kelasKuliahId,
          uid: mhs.uid,
          nim: mhs.nim,
          nama: mhs.nama,
          tugas: input['tugas'] ?? 0,
          uts: input['uts'] ?? 0,
          uas: input['uas'] ?? 0,
        );
      }
      return true;
    } catch (e) {
      errorMessage = 'Gagal simpan: $e';
      return false;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }
}
