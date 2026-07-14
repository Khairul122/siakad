class Kegiatan {
  final String id;
  final String judul;
  final String deskripsi;
  final DateTime tanggal;
  final String gambarUrl;
  final String lokasi;
  final String status;
  final String pemateri;
  final String kuota;
  final int pendaftaranCount;

  const Kegiatan({
    required this.id,
    required this.judul,
    required this.deskripsi,
    required this.tanggal,
    this.gambarUrl = '',
    this.lokasi = '',
    this.status = '',
    this.pemateri = '',
    this.kuota = '',
    this.pendaftaranCount = 0,
  });

  factory Kegiatan.fromMap(String id, Map<String, dynamic> map) {
    final rawTanggal = map['tanggal'];
    DateTime tanggal;
    if (rawTanggal is String) {
      tanggal = DateTime.tryParse(rawTanggal) ?? DateTime.now();
    } else {
      tanggal = DateTime.now();
    }

    return Kegiatan(
      id: id,
      judul: map['judul'] ?? '',
      deskripsi: map['deskripsi'] ?? '',
      tanggal: tanggal,
      gambarUrl: map['gambar_url']?.toString() ?? '',
      lokasi: map['lokasi']?.toString() ?? '',
      status: map['status']?.toString() ?? '',
      pemateri: map['pemateri']?.toString() ?? '',
      kuota: map['kuota']?.toString() ?? '',
      pendaftaranCount: map['pendaftaran_count'] is int
          ? map['pendaftaran_count'] as int
          : int.tryParse(map['pendaftaran_count']?.toString() ?? '') ?? 0,
    );
  }

  /// Total kuota sebagai angka, null kalau nilainya bukan angka (dianggap tanpa batas).
  int? get kuotaTotal => int.tryParse(kuota);

  /// Sisa kuota, null kalau kuota tanpa batas.
  int? get sisaKuota {
    final total = kuotaTotal;
    if (total == null) return null;
    final sisa = total - pendaftaranCount;
    return sisa < 0 ? 0 : sisa;
  }

  bool get kuotaPenuh => sisaKuota != null && sisaKuota == 0;

  static const List<String> _bulanIndo = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  String get tanggalFormatted {
    return '${tanggal.day} ${_bulanIndo[tanggal.month - 1]} ${tanggal.year}';
  }
}
