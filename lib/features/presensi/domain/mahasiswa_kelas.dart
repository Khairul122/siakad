class MahasiswaKelas {
  final String uid, nama, nim, email, photoUrl, prodi, angkatan;

  const MahasiswaKelas({
    required this.uid,
    required this.nama,
    required this.nim,
    required this.email,
    this.photoUrl = '',
    this.prodi = '',
    this.angkatan = '',
  });

  factory MahasiswaKelas.fromMap(Map<String, dynamic> map) => MahasiswaKelas(
        uid: map['uid'] ?? '',
        nama: map['nama'] ?? '',
        nim: map['nim'] ?? '',
        email: map['email'] ?? '',
        photoUrl: map['photo_url'] ?? '',
        prodi: map['prodi'] ?? '',
        angkatan: map['angkatan'] ?? '',
      );
}
