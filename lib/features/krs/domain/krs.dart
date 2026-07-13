import 'package:sistem_akademik/features/krs/domain/mata_kuliah_krs.dart';

class Krs {
  final String id;
  final String uid;
  final String tahunAkademik;
  final String semester;
  final String status;
  final String? catatanDosen;
  final List<MataKuliahKrs> mataKuliah;

  const Krs({
    required this.id,
    required this.uid,
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

  bool get sudahDisetujui => status == 'disetujui';
  bool get ditolak => status == 'ditolak';

  factory Krs.fromMap(String id, Map<String, dynamic> map) {
    final rawList = map['mata_kuliah'];
    final List<MataKuliahKrs> daftar = rawList is List
        ? rawList
            .whereType<Map>()
            .map((item) => MataKuliahKrs.fromMap(Map<String, dynamic>.from(item)))
            .toList()
        : const [];

    return Krs(
      id: id,
      uid: map['uid'] ?? '',
      tahunAkademik: map['tahun_akademik'] ?? '',
      semester: map['semester'] ?? '',
      status: map['status'] ?? 'diajukan',
      catatanDosen: map['catatan_dosen'],
      mataKuliah: daftar,
    );
  }
}
