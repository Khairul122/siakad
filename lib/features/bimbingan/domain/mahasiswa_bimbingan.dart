class MahasiswaBimbingan {
  final String uid;
  final String nama;
  final String nim;
  final String email;
  final String photoUrl;
  final String prodi;
  final String fakultas;
  final String angkatan;
  final String noHp;

  const MahasiswaBimbingan({
    required this.uid,
    required this.nama,
    required this.nim,
    required this.email,
    this.photoUrl = '',
    this.prodi = '',
    this.fakultas = '',
    this.angkatan = '',
    this.noHp = '',
  });

  factory MahasiswaBimbingan.fromMap(Map<String, dynamic> map) => MahasiswaBimbingan(
        uid: map['uid'] ?? '',
        nama: map['nama'] ?? '',
        nim: map['nim'] ?? '',
        email: map['email'] ?? '',
        photoUrl: map['photo_url'] ?? '',
        prodi: map['prodi'] ?? '',
        fakultas: map['fakultas'] ?? '',
        angkatan: map['angkatan']?.toString() ?? '',
        noHp: map['no_hp'] ?? '',
      );

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'nama': nama,
        'nim': nim,
        'email': email,
        'photo_url': photoUrl,
        'prodi': prodi,
        'fakultas': fakultas,
        'angkatan': angkatan,
        'no_hp': noHp,
      };
}
