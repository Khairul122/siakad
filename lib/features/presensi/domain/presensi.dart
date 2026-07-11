class Presensi {
  final String uid, nim, nama, keterangan;

  const Presensi({
    required this.uid,
    required this.nim,
    required this.nama,
    required this.keterangan,
  });

  factory Presensi.fromMap(Map<String, dynamic> map) => Presensi(
        uid: map['mahasiswa_uid'] ?? map['uid'] ?? '',
        nim: map['nim'] ?? '',
        nama: map['nama'] ?? '',
        keterangan: map['keterangan'] ?? 'Alpha',
      );
}
