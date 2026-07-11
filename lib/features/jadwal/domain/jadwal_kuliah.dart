class JadwalKuliah {
  final String id;
  final String uid;
  final String hari;
  final String mataKuliah;
  final String jamMulai;
  final String jamSelesai;
  final String ruangan;
  final String keterangan;

  const JadwalKuliah({
    required this.id,
    required this.uid,
    required this.hari,
    required this.mataKuliah,
    required this.jamMulai,
    required this.jamSelesai,
    required this.ruangan,
    this.keterangan = '',
  });

  factory JadwalKuliah.fromMap(String id, Map<String, dynamic> map) {
    return JadwalKuliah(
      id: id,
      uid: map['uid'] ?? '',
      hari: map['hari'] ?? '',
      mataKuliah: map['mata_kuliah'] ?? '',
      jamMulai: map['jam_mulai'] ?? '',
      jamSelesai: map['jam_selesai'] ?? '',
      ruangan: map['ruangan'] ?? '',
      keterangan: map['keterangan'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'hari': hari,
      'mataKuliah': mataKuliah,
      'jamMulai': jamMulai,
      'jamSelesai': jamSelesai,
      'ruangan': ruangan,
      'keterangan': keterangan,
    };
  }
}
