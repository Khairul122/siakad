class Nilai {
  final String uid, nim, nama;
  final int tugas, uts, uas;

  const Nilai({
    required this.uid,
    required this.nim,
    required this.nama,
    this.tugas = 0,
    this.uts = 0,
    this.uas = 0,
  });

  factory Nilai.fromMap(Map<String, dynamic> map) => Nilai(
        uid: map['mahasiswa_uid'] ?? map['uid'] ?? '',
        nim: map['nim'] ?? '',
        nama: map['nama'] ?? '',
        tugas: (map['tugas'] as num?)?.toInt() ?? 0,
        uts: (map['uts'] as num?)?.toInt() ?? 0,
        uas: (map['uas'] as num?)?.toInt() ?? 0,
      );

  double get nilaiAkhir => (tugas * 0.3) + (uts * 0.3) + (uas * 0.4);

  String get grade {
    final n = nilaiAkhir;
    if (n >= 85) return 'A';
    if (n >= 75) return 'B';
    if (n >= 65) return 'C';
    if (n >= 55) return 'D';
    return 'E';
  }
}
