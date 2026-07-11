import 'package:dosen/features/bimbingan/domain/mahasiswa_bimbingan.dart';

abstract class BimbinganRepository {
  Future<List<MahasiswaBimbingan>> fetchBimbingan();
}
