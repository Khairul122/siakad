class Informasi {
  final String id;
  final String judul;
  final String isi;
  final DateTime tanggal;
  final String gambarUrl;

  const Informasi({
    required this.id,
    required this.judul,
    required this.isi,
    required this.tanggal,
    this.gambarUrl = '',
  });

  factory Informasi.fromMap(Map<String, dynamic> map) {
    final rawTanggal = map['tanggal'];
    DateTime tanggal;
    if (rawTanggal is String) {
      tanggal = DateTime.tryParse(rawTanggal) ?? DateTime.now();
    } else {
      tanggal = DateTime.now();
    }

    return Informasi(
      id: map['id']?.toString() ?? '',
      judul: map['judul'] ?? '',
      isi: map['isi'] ?? '',
      tanggal: tanggal,
      gambarUrl: map['gambar_url'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'judul': judul,
      'isi': isi,
      'tanggal': tanggal.toIso8601String(),
      'gambar_url': gambarUrl,
    };
  }
}
