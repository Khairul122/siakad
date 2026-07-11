import 'package:sistem_akademik/features/khs/domain/nilai_mata_kuliah.dart';

class KhsCalculator {
  KhsCalculator._();

  static const double bobotTugas = 0.3;
  static const double bobotUts = 0.3;
  static const double bobotUas = 0.4;

  static double nilaiAkhir(NilaiMataKuliah mk) =>
      (mk.tugas * bobotTugas) + (mk.uts * bobotUts) + (mk.uas * bobotUas);

  static String grade(double nilai) {
    if (nilai >= 85) return 'A';
    if (nilai >= 75) return 'B';
    if (nilai >= 65) return 'C';
    if (nilai >= 55) return 'D';
    return 'E';
  }

  static double bobotGrade(String grade) {
    switch (grade) {
      case 'A':
        return 4.0;
      case 'B':
        return 3.0;
      case 'C':
        return 2.0;
      case 'D':
        return 1.0;
      default:
        return 0.0;
    }
  }

  static int totalSks(List<NilaiMataKuliah> list) =>
      list.fold(0, (sum, mk) => sum + mk.sks);

  static double ipSemester(List<NilaiMataKuliah> list) {
    if (list.isEmpty) return 0.0;
    var totalSks = 0;
    var totalBobot = 0.0;
    for (final mk in list) {
      final na = nilaiAkhir(mk);
      final g = grade(na);
      final bobot = bobotGrade(g);
      totalSks += mk.sks;
      totalBobot += bobot * mk.sks;
    }
    return totalSks > 0 ? totalBobot / totalSks : 0.0;
  }
}
