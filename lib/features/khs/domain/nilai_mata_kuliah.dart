class NilaiMataKuliah {
  final String id;
  final String uid;
  final String tahunAkademik;
  final String semester;
  final String kode;
  final String mataKuliah;
  final int sks;
  final String kelas;
  final double tugas;
  final double uts;
  final double uas;

  const NilaiMataKuliah({
    required this.id,
    required this.uid,
    required this.tahunAkademik,
    required this.semester,
    this.kode = '',
    required this.mataKuliah,
    this.sks = 0,
    this.kelas = '',
    required this.tugas,
    required this.uts,
    required this.uas,
  });

  factory NilaiMataKuliah.fromMap(String id, Map<String, dynamic> map) {
    return NilaiMataKuliah(
      id: id,
      uid: map['uid'] ?? '',
      tahunAkademik: map['tahun_akademik'] ?? '',
      semester: map['semester'] ?? '',
      kode: map['kode'] ?? '',
      mataKuliah: map['mata_kuliah'] ?? '',
      sks: map['sks'] is int 
          ? map['sks'] as int 
          : int.tryParse('${map['sks']}') ?? 0,
      kelas: map['kelas'] ?? '',
      tugas: map['tugas'] is num 
          ? (map['tugas'] as num).toDouble() 
          : double.tryParse('${map['tugas']}') ?? 0.0,
      uts: map['uts'] is num 
          ? (map['uts'] as num).toDouble() 
          : double.tryParse('${map['uts']}') ?? 0.0,
      uas: map['uas'] is num 
          ? (map['uas'] as num).toDouble() 
          : double.tryParse('${map['uas']}') ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'tahunAkademik': tahunAkademik,
      'semester': semester,
      'kode': kode,
      'mataKuliah': mataKuliah,
      'sks': sks,
      'kelas': kelas,
      'tugas': tugas,
      'uts': uts,
      'uas': uas,
    };
  }
}
