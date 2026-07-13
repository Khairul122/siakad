class RingkasanSemester {
  final String tahunAkademik;
  final String semester;
  final double? ips;
  final int totalSks;

  const RingkasanSemester({
    required this.tahunAkademik,
    required this.semester,
    required this.ips,
    required this.totalSks,
  });

  factory RingkasanSemester.fromMap(Map<String, dynamic> map) {
    return RingkasanSemester(
      tahunAkademik: map['tahun_akademik'] ?? '',
      semester: map['semester'] ?? '',
      ips: map['ips'] == null ? null : double.tryParse('${map['ips']}'),
      totalSks: map['total_sks'] is int ? map['total_sks'] as int : int.tryParse('${map['total_sks']}') ?? 0,
    );
  }
}

class KhsRingkasan {
  final List<RingkasanSemester> semester;
  final double? ipk;

  const KhsRingkasan({required this.semester, required this.ipk});

  factory KhsRingkasan.fromMap(Map<String, dynamic> map) {
    final rawList = map['semester'];
    return KhsRingkasan(
      semester: rawList is List
          ? rawList.whereType<Map>().map((e) => RingkasanSemester.fromMap(Map<String, dynamic>.from(e))).toList()
          : const [],
      ipk: map['ipk'] == null ? null : double.tryParse('${map['ipk']}'),
    );
  }
}
