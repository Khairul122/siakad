class MataKuliahKrs {
  final String nama;
  final String kode;
  final String sks;
  final String kelas;
  final String hari;
  final String pukul;
  final String ruang;

  const MataKuliahKrs({
    required this.nama,
    required this.kode,
    required this.sks,
    required this.kelas,
    required this.hari,
    required this.pukul,
    required this.ruang,
  });

  factory MataKuliahKrs.fromMap(Map<String, dynamic> map) {
    return MataKuliahKrs(
      nama: map['nama'] ?? '',
      kode: map['kode'] ?? '',
      sks: map['sks']?.toString() ?? '',
      kelas: map['kelas'] ?? '',
      hari: map['hari'] ?? '',
      pukul: map['pukul'] ?? '',
      ruang: map['ruang'] ?? '',
    );
  }
}
