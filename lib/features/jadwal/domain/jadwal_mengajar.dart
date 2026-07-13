class JadwalMengajar {
  final int id;
  final String uid;
  final String hari;
  final String mataKuliah;
  final String namaKelas;
  final String jamMulai;
  final String jamSelesai;
  final String ruangan;
  final String keterangan;

  const JadwalMengajar({
    this.id = 0,
    required this.uid,
    required this.hari,
    required this.mataKuliah,
    this.namaKelas = '',
    required this.jamMulai,
    required this.jamSelesai,
    this.ruangan = '',
    this.keterangan = '',
  });

  String get label => namaKelas.isEmpty ? mataKuliah : '$mataKuliah - Kelas $namaKelas';

  factory JadwalMengajar.fromMap(Map<String, dynamic> map) => JadwalMengajar(
        id: map['id'] is int ? map['id'] as int : int.tryParse('${map['id']}') ?? 0,
        uid: map['uid'] ?? '',
        hari: map['hari'] ?? '',
        mataKuliah: map['mata_kuliah'] ?? '',
        namaKelas: map['nama_kelas'] ?? '',
        jamMulai: map['jam_mulai'] ?? '',
        jamSelesai: map['jam_selesai'] ?? '',
        ruangan: map['ruangan'] ?? '',
        keterangan: map['keterangan'] ?? '',
      );

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'hari': hari,
        'mata_kuliah': mataKuliah,
        'nama_kelas': namaKelas,
        'jam_mulai': jamMulai,
        'jam_selesai': jamSelesai,
        'ruangan': ruangan,
        'keterangan': keterangan,
      };
}
