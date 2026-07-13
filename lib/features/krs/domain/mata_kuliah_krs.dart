class MataKuliahKrs {
  final int? kelasKuliahId;
  final String nama;
  final String kode;
  final String sks;
  final String kelas;
  final String hari;
  final String pukul;
  final String ruang;
  final String status;

  const MataKuliahKrs({
    this.kelasKuliahId,
    required this.nama,
    required this.kode,
    required this.sks,
    required this.kelas,
    required this.hari,
    required this.pukul,
    required this.ruang,
    required this.status,
  });

  factory MataKuliahKrs.fromMap(Map<String, dynamic> map) {
    return MataKuliahKrs(
      kelasKuliahId: map['kelas_kuliah_id'] is int
          ? map['kelas_kuliah_id'] as int
          : int.tryParse('${map['kelas_kuliah_id']}'),
      nama: map['nama'] ?? '',
      kode: map['kode'] ?? '',
      sks: map['sks']?.toString() ?? '',
      kelas: map['kelas'] ?? '',
      hari: map['hari'] ?? '',
      pukul: map['pukul'] ?? '',
      ruang: map['ruang'] ?? '',
      status: map['status'] ?? '',
    );
  }
}
