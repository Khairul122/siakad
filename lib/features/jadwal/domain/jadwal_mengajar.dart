class JadwalMengajar {
  final String id;
  final String uid;
  final String hari;
  final String mataKuliah;
  final String jamMulai;
  final String jamSelesai;
  final String ruangan;
  final String keterangan;

  const JadwalMengajar({
    this.id = '',
    required this.uid,
    required this.hari,
    required this.mataKuliah,
    required this.jamMulai,
    required this.jamSelesai,
    this.ruangan = '',
    this.keterangan = '',
  });

  factory JadwalMengajar.fromMap(Map<String, dynamic> map) => JadwalMengajar(
        id: map['id']?.toString() ?? '',
        uid: map['uid'] ?? '',
        hari: map['hari'] ?? '',
        mataKuliah: map['mata_kuliah'] ?? '',
        jamMulai: map['jam_mulai'] ?? '',
        jamSelesai: map['jam_selesai'] ?? '',
        ruangan: map['ruangan'] ?? '',
        keterangan: map['keterangan'] ?? '',
      );

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'hari': hari,
        'mata_kuliah': mataKuliah,
        'jam_mulai': jamMulai,
        'jam_selesai': jamSelesai,
        'ruangan': ruangan,
        'keterangan': keterangan,
      };
}
