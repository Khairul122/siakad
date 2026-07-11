class Notifikasi {
  final String id;
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

  Notifikasi copyWith({bool? dibaca}) {
    return Notifikasi(
      id: id,
      uid: uid,
      judul: judul,
      isi: isi,
      dibaca: dibaca ?? this.dibaca,
      createdAt: createdAt,
    );
  }

  factory Notifikasi.fromMap(String id, Map<String, dynamic> map) {
    final createdAtRaw = map['created_at'];
    return Notifikasi(
      id: id,
      uid: map['uid']?.toString() ?? '',
      judul: map['judul'] ?? '',
      isi: map['isi'] ?? '',
      dibaca: map['dibaca'] == true || map['dibaca'] == 1,
      createdAt: createdAtRaw is String ? DateTime.tryParse(createdAtRaw) : null,
    );
  }
}
