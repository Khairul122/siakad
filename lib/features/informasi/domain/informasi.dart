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

  factory Informasi.fromMap(String id, Map<String, dynamic> map) {
    final rawTanggal = map['tanggal'];
    DateTime tanggal;
    if (rawTanggal is String) {
      tanggal = DateTime.tryParse(rawTanggal) ?? DateTime.now();
    } else {
      tanggal = DateTime.now();
    }

    return Informasi(
      id: id,
      judul: map['judul'] ?? '',
      isi: map['isi'] ?? '',
      tanggal: tanggal,
      gambarUrl: map['gambar_url']?.toString() ?? '',
    );
  }

  String get ringkasan {
    if (isi.length <= 80) return isi;
    return '${isi.substring(0, 80)}...';
  }
}
