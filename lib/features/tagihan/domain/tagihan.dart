class Tagihan {
  final String id;
  final String uid;
  final String jenis;
  final double nominal;
  final String status;
  final String jatuhTempo;
  final String metodePembayaran;
  final String bankTujuan;
  final String noRekening;
  final String buktiUrl;
  final String catatan;
  final String tanggalKonfirmasi;
  final String tanggalLunas;

  const Tagihan({
    required this.id,
    required this.uid,
    required this.jenis,
    required this.nominal,
    this.status = 'Belum Dibayar',
    this.jatuhTempo = '',
    this.metodePembayaran = '',
    this.bankTujuan = '',
    this.noRekening = '',
    this.buktiUrl = '',
    this.catatan = '',
    this.tanggalKonfirmasi = '',
    this.tanggalLunas = '',
  });

  bool get sudahLunas => status == 'Lunas';

  factory Tagihan.fromMap(String id, Map<String, dynamic> map) {
    return Tagihan(
      id: id,
      uid: map['uid']?.toString() ?? '',
      jenis: map['jenis'] ?? '',
      nominal: map['nominal'] is num 
          ? (map['nominal'] as num).toDouble() 
          : double.tryParse('${map['nominal']}') ?? 0.0,
      status: map['status'] ?? 'Belum Dibayar',
      jatuhTempo: map['jatuh_tempo']?.toString() ?? '',
      metodePembayaran: map['metode_pembayaran']?.toString() ?? '',
      bankTujuan: map['bank_tujuan']?.toString() ?? '',
      noRekening: map['no_rekening']?.toString() ?? '',
      buktiUrl: map['bukti_url']?.toString() ?? '',
      catatan: map['catatan']?.toString() ?? '',
      tanggalKonfirmasi: map['tanggal_konfirmasi']?.toString() ?? '',
      tanggalLunas: map['tanggal_lunas']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'jenis': jenis,
      'nominal': nominal,
      'status': status,
      'jatuh_tempo': jatuhTempo,
      'metode_pembayaran': metodePembayaran,
      'bank_tujuan': bankTujuan,
      'no_rekening': noRekening,
      'bukti_url': buktiUrl,
      'catatan': catatan,
      'tanggal_konfirmasi': tanggalKonfirmasi,
      'tanggal_lunas': tanggalLunas,
    };
  }
}
