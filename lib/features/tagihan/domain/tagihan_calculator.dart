import 'package:sistem_akademik/features/tagihan/domain/tagihan.dart';

class TagihanCalculator {
  TagihanCalculator._();

  static double totalBelumLunas(List<Tagihan> list) {
    return list
        .where((t) => !t.sudahLunas)
        .fold(0.0, (sum, t) => sum + t.nominal);
  }

  static List<Tagihan> daftarBelumLunas(List<Tagihan> list) {
    return list.where((t) => !t.sudahLunas).toList();
  }

  static List<Tagihan> riwayatLunas(List<Tagihan> list) {
    return list.where((t) => t.sudahLunas).toList();
  }

  static String formatRupiah(double nominal) {
    final s = nominal.toStringAsFixed(0);
    final buffer = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      final posFromEnd = s.length - i;
      buffer.write(s[i]);
      if (posFromEnd > 1 && posFromEnd % 3 == 1) {
        buffer.write('.');
      }
    }
    return 'Rp $buffer';
  }
}
