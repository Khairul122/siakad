import 'package:flutter/foundation.dart';
import 'package:dosen/features/jadwal/data/jadwal_repository.dart';
import 'package:dosen/features/jadwal/domain/jadwal_mengajar.dart';
import 'package:dosen/features/jadwal/domain/jadwal_repository.dart';
import 'package:dosen/features/presensi/data/presensi_repository.dart';
import 'package:dosen/features/presensi/domain/mahasiswa_kelas.dart';
import 'package:dosen/features/presensi/domain/presensi_repository.dart';

class PresensiController extends ChangeNotifier {
  final PresensiRepository _repository;
  final JadwalRepository _jadwalRepository;

  PresensiController({PresensiRepository? repository, JadwalRepository? jadwalRepository})
      : _repository = repository ?? ApiPresensiRepository(),
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

  final Map<String, String> _localKet = {};
  List<MahasiswaKelas> mahasiswaList = [];
  bool isLoadingMahasiswa = true;
  bool isSaving = false;

  String keteranganFor(String uid) => _localKet[uid] ?? 'Hadir';

  Future<void> loadMahasiswa(int kelasKuliahId) async {
    isLoadingMahasiswa = true;
    notifyListeners();

    try {
      mahasiswaList = await _repository.fetchMahasiswaByKelas(kelasKuliahId);
      for (final mhs in mahasiswaList) {
        _localKet.putIfAbsent(mhs.uid, () => 'Hadir');
      }
    } catch (e) {
      errorMessage = 'Gagal memuat mahasiswa: $e';
    } finally {
      isLoadingMahasiswa = false;
      notifyListeners();
    }
  }

  Future<void> loadDetail(int kelasKuliahId, String pertemuan) async {
    try {
      final list = await _repository.fetchPresensi(kelasKuliahId, pertemuan);
      for (final p in list) {
        _localKet[p.uid] = p.keterangan;
      }
      notifyListeners();
    } catch (e) {
      errorMessage = 'Gagal memuat presensi: $e';
      notifyListeners();
    }
  }

  Future<void> gantiPertemuan(int kelasKuliahId, String pertemuan) async {
    _localKet.clear();
    await loadDetail(kelasKuliahId, pertemuan);
  }

  void setKeterangan(String uid, String value) {
    _localKet[uid] = value;
    notifyListeners();
  }

  Future<bool> saveAll({required int kelasKuliahId, required String pertemuan}) async {
    isSaving = true;
    errorMessage = null;
    notifyListeners();

    try {
      for (final mhs in mahasiswaList) {
        if (mhs.uid.isEmpty) continue;
        final ket = keteranganFor(mhs.uid);
        await _repository.simpanPresensi(
          kelasKuliahId: kelasKuliahId,
          pertemuan: pertemuan,
          uid: mhs.uid,
          nim: mhs.nim,
          nama: mhs.nama,
          keterangan: ket,
        );
      }
      return true;
    } catch (e) {
      errorMessage = '${e.runtimeType} — $e';
      return false;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }
}
