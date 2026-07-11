class Dosen {
  final String uid;
  final String nama;
  final String nip;
  final String email;
  final String photoUrl;
  final String prodi;

  const Dosen({
    required this.uid,
    required this.nama,
    required this.nip,
    required this.email,
    this.photoUrl = '',
    this.prodi = '',
  });

  factory Dosen.fromMap(Map<String, dynamic> map) => Dosen(
        uid: map['uid'] ?? '',
        nama: map['nama'] ?? '',
        nip: map['nip'] ?? '',
        email: map['email'] ?? '',
        photoUrl: map['photo_url'] ?? '',
        prodi: map['prodi'] ?? '',
      );

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'nama': nama,
        'nip': nip,
        'email': email,
        'photo_url': photoUrl,
        'prodi': prodi,
      };
}
