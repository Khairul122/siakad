import 'package:flutter/foundation.dart';
import 'package:sistem_akademik/core/network/api_exception.dart';
import 'package:sistem_akademik/features/kegiatan/data/kegiatan_repository.dart';
import 'package:sistem_akademik/features/kegiatan/domain/kegiatan_repository.dart';

class PendaftaranKegiatanController extends ChangeNotifier {
  final KegiatanRepository _repository;
  final String kegiatanId;

  PendaftaranKegiatanController({required this.kegiatanId, KegiatanRepository? repository})
      : _repository = repository ?? ApiKegiatanRepository() {
    _cekStatus();
  }

  bool isChecking = true;
  bool sudahTerdaftar = false;
  bool isSubmitting = false;
  String? errorMessage;

  Future<void> _cekStatus() async {
    isChecking = true;
    notifyListeners();

    try {
      sudahTerdaftar = await _repository.cekStatusPendaftaran(kegiatanId);
    } catch (_) {
      // Gagal cek status tidak menghalangi pengguna mencoba daftar; validasi
      // duplikat tetap ditegakkan backend saat submit.
    } finally {
      isChecking = false;
      notifyListeners();
    }
  }

  Future<bool> daftar({
    required String nama,
    required String nim,
    required String prodi,
    required String noHp,
  }) async {
    isSubmitting = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _repository.daftarKegiatan(
        kegiatanId: kegiatanId,
        nama: nama,
        nim: nim,
        prodi: prodi,
        noHp: noHp,
      );
      sudahTerdaftar = true;
      return true;
    } on ApiException catch (e) {
      errorMessage = e.message;
      return false;
    } catch (e) {
      errorMessage = 'Gagal mendaftar: $e';
      return false;
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }
}
