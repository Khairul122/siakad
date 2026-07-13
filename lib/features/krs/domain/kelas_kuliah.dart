class KelasKuliah {
  final int id;
  final String mataKuliahNama;
  final String mataKuliahKode;
  final int sks;
  final String namaKelas;
  final String dosenNama;
  final String hari;
  final String jamMulai;
  final String jamSelesai;
  final String ruangan;
  final int kuota;
  final int terisi;
  final String tahunAkademik;
  final String semester;

  const KelasKuliah({
    required this.id,
    required this.mataKuliahNama,
    required this.mataKuliahKode,
    required this.sks,
    required this.namaKelas,
    required this.dosenNama,
    required this.hari,
    required this.jamMulai,
    required this.jamSelesai,
    required this.ruangan,
    required this.kuota,
    required this.terisi,
    required this.tahunAkademik,
    required this.semester,
  });

  factory KelasKuliah.fromMap(Map<String, dynamic> map) {
    final mataKuliah = map['mata_kuliah'] as Map<String, dynamic>?;
    final dosen = map['dosen'] as Map<String, dynamic>?;

    return KelasKuliah(
      id: map['id'] is int ? map['id'] as int : int.tryParse('${map['id']}') ?? 0,
      mataKuliahNama: mataKuliah?['nama'] ?? '',
      mataKuliahKode: mataKuliah?['kode'] ?? '',
      sks: mataKuliah?['sks'] is int ? mataKuliah!['sks'] as int : int.tryParse('${mataKuliah?['sks']}') ?? 0,
      namaKelas: map['nama_kelas'] ?? '',
      dosenNama: dosen?['nama'] ?? '',
      hari: map['hari'] ?? '',
      jamMulai: map['jam_mulai'] ?? '',
      jamSelesai: map['jam_selesai'] ?? '',
      ruangan: map['ruangan'] ?? '',
      kuota: map['kuota'] is int ? map['kuota'] as int : int.tryParse('${map['kuota']}') ?? 0,
      terisi: map['krs_mata_kuliah_count'] is int
          ? map['krs_mata_kuliah_count'] as int
          : int.tryParse('${map['krs_mata_kuliah_count']}') ?? 0,
      tahunAkademik: map['tahun_akademik'] ?? '',
      semester: map['semester'] ?? '',
    );
  }
}
