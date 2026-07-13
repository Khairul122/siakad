import 'package:dosen/features/krs_approval/domain/mata_kuliah_krs.dart';

class PengajuanKrs {
  final int id;
  final String mahasiswaNama;
  final String mahasiswaNim;
  final String tahunAkademik;
  final String semester;
  final String status;
  final String? catatanDosen;
  final List<MataKuliahKrs> mataKuliah;

  const PengajuanKrs({
    required this.id,
    required this.mahasiswaNama,
    required this.mahasiswaNim,
    required this.tahunAkademik,
    required this.semester,
    required this.status,
    this.catatanDosen,
    required this.mataKuliah,
  });

  int get totalSks {
    return mataKuliah.fold<int>(0, (total, mk) {
      final angka = int.tryParse(mk.sks.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      return total + angka;
    });
  }

  factory PengajuanKrs.fromMap(Map<String, dynamic> map) {
    final mahasiswa = map['mahasiswa'] as Map<String, dynamic>?;
    final rawList = map['mata_kuliah'];
    final daftar = rawList is List
        ? rawList
            .whereType<Map>()
            .map((item) => MataKuliahKrs.fromMap(Map<String, dynamic>.from(item)))
            .toList()
        : const <MataKuliahKrs>[];

    return PengajuanKrs(
      id: map['id'] is int ? map['id'] as int : int.tryParse('${map['id']}') ?? 0,
      mahasiswaNama: mahasiswa?['nama'] ?? '',
      mahasiswaNim: mahasiswa?['nim'] ?? '',
      tahunAkademik: map['tahun_akademik'] ?? '',
      semester: map['semester'] ?? '',
      status: map['status'] ?? 'diajukan',
      catatanDosen: map['catatan_dosen'],
      mataKuliah: daftar,
    );
  }
}
