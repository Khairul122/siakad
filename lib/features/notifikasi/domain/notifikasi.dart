class Notifikasi {
  final int id;
  final String uid;
  final String judul;
  final String isi;
  final bool dibaca;
  final DateTime? createdAt;

  const Notifikasi({
    required this.id,
    required this.uid,
    required this.judul,
    required this.isi,
    required this.dibaca,
    this.createdAt,
  });

  factory Notifikasi.fromMap(Map<String, dynamic> map) {
    final createdAtRaw = map['created_at'];
    final rawId = map['id'];
    return Notifikasi(
      id: rawId is int ? rawId : int.tryParse(rawId?.toString() ?? '') ?? 0,
      uid: map['uid'] ?? '',
      judul: map['judul'] ?? '',
      isi: map['isi'] ?? '',
      dibaca: map['dibaca'] == true || map['dibaca'] == 1,
      createdAt: createdAtRaw is String ? DateTime.tryParse(createdAtRaw) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'judul': judul,
      'isi': isi,
      'dibaca': dibaca,
    };
  }
}
