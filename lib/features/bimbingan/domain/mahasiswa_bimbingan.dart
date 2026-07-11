class MahasiswaBimbingan {
  final String uid;
  final String nama;
  final String nim;
  final String email;
  final String photoUrl;
  final String prodi;
  final String angkatan;

  const MahasiswaBimbingan({
    required this.uid,
    required this.nama,
    required this.nim,
    required this.email,
    this.photoUrl = '',
    this.prodi = '',
    this.angkatan = '',
  });

  factory MahasiswaBimbingan.fromMap(Map<String, dynamic> map) => MahasiswaBimbingan(
        uid: map['uid'] ?? '',
        nama: map['nama'] ?? '',
        nim: map['nim'] ?? '',
        email: map['email'] ?? '',
        photoUrl: map['photo_url'] ?? '',
        prodi: map['prodi'] ?? '',
        angkatan: map['angkatan']?.toString() ?? '',
      );

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'nama': nama,
        'nim': nim,
        'email': email,
        'photo_url': photoUrl,
        'prodi': prodi,
        'angkatan': angkatan,
      };
}
