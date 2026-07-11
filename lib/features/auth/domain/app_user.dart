class AppUser {
  final String uid;
  final String nama;
  final String nim;
  final String email;
  final String noHp;
  final String tanggalLahir;
  final String alamat;
  final String photoUrl;
  final String kelas;
  final String angkatan;
  final String prodi;

  const AppUser({
    required this.uid,
    required this.nama,
    required this.nim,
    required this.email,
    this.noHp = '',
    this.tanggalLahir = '',
    this.alamat = '',
    this.photoUrl = '',
    this.kelas = '',
    this.angkatan = '',
    this.prodi = '',
  });

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'] ?? '',
      nama: map['nama'] ?? '',
      nim: map['nim'] ?? '',
      email: map['email'] ?? '',
      noHp: map['no_hp'] ?? '',
      tanggalLahir: map['tanggal_lahir'] ?? '',
      alamat: map['alamat'] ?? '',
      photoUrl: map['photo_url'] ?? '',
      kelas: map['kelas'] ?? '',
      angkatan: map['angkatan'] ?? '',
      prodi: map['prodi'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'nama': nama,
      'nim': nim,
      'email': email,
      'no_hp': noHp,
      'tanggal_lahir': tanggalLahir,
      'alamat': alamat,
      'photo_url': photoUrl,
      'kelas': kelas,
      'angkatan': angkatan,
      'prodi': prodi,
    };
  }
}
