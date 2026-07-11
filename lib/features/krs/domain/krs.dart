import 'package:sistem_akademik/features/krs/domain/mata_kuliah_krs.dart';

class Krs {
  final String id;
  final String uid;
  final String tahunAkademik;
  final String semester;
  final List<MataKuliahKrs> mataKuliah;

  const Krs({
    required this.id,
    required this.uid,
    required this.tahunAkademik,
    required this.semester,
    required this.mataKuliah,
  });

  int get totalSks {
    return mataKuliah.fold<int>(0, (total, mk) {
      final angka = int.tryParse(mk.sks.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      return total + angka;
    });
  }

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
      mataKuliah: daftar,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'tahunAkademik': tahunAkademik,
      'semester': semester,
      'mataKuliah': mataKuliah.map((mk) => mk.toMap()).toList(),
    };
  }
}
