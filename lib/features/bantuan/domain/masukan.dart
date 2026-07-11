class Masukan {
  final String id;
  final String uid;
  final String kategori;
  final String pesan;
  final DateTime? createdAt;

  const Masukan({
    required this.id,
    required this.uid,
    required this.kategori,
    required this.pesan,
    required this.createdAt,
  });

  factory Masukan.fromMap(Map<String, dynamic> map) {
    final createdAtRaw = map['created_at'];
    return Masukan(
      id: map['id']?.toString() ?? '',
      uid: map['uid'] as String? ?? '',
      kategori: map['kategori'] as String? ?? '',
      pesan: map['pesan'] as String? ?? '',
      createdAt: createdAtRaw is String ? DateTime.tryParse(createdAtRaw) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'kategori': kategori,
      'pesan': pesan,
    };
  }
}
