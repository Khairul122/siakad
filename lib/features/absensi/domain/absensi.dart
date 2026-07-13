class Absensi {
  final String id;
  final int kelasKuliahId;
  final String mataKuliah;
  final String namaKelas;
  final String dosenNama;
  final String hari;
  final String jamMulai;
  final String jamSelesai;
  final String ruangan;
  final String pertemuan;
  final String keterangan;

  const Absensi({
    required this.id,
    required this.kelasKuliahId,
    required this.mataKuliah,
    this.namaKelas = '',
    this.dosenNama = '',
    this.hari = '',
    this.jamMulai = '',
    this.jamSelesai = '',
    this.ruangan = '',
    required this.pertemuan,
    required this.keterangan,
  });

  String get label => namaKelas.isEmpty ? mataKuliah : '$mataKuliah - Kelas $namaKelas';

  String get jadwal => (hari.isEmpty || jamMulai.isEmpty) ? '' : '$hari, $jamMulai - $jamSelesai';

  factory Absensi.fromMap(Map<String, dynamic> map) {
    final kelasKuliah = map['kelas_kuliah'] as Map<String, dynamic>?;
    final mataKuliah = kelasKuliah?['mata_kuliah'] as Map<String, dynamic>?;
    final dosen = kelasKuliah?['dosen'] as Map<String, dynamic>?;

    return Absensi(
      id: '${map['id']}',
      kelasKuliahId: map['kelas_kuliah_id'] is int
          ? map['kelas_kuliah_id'] as int
          : int.tryParse('${map['kelas_kuliah_id']}') ?? 0,
      mataKuliah: mataKuliah?['nama'] ?? '',
      namaKelas: kelasKuliah?['nama_kelas'] ?? '',
      dosenNama: dosen?['nama'] ?? '',
      hari: kelasKuliah?['hari'] ?? '',
      jamMulai: kelasKuliah?['jam_mulai'] ?? '',
      jamSelesai: kelasKuliah?['jam_selesai'] ?? '',
      ruangan: kelasKuliah?['ruangan'] ?? '',
      pertemuan: '${map['pertemuan'] ?? ''}',
      keterangan: map['keterangan'] ?? '',
    );
  }
}
