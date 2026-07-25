import 'package:sistem_akademik/features/krs/domain/kelas_kuliah.dart';
import 'package:sistem_akademik/features/krs/domain/krs.dart';

class KuotaSks {
  final double? ips;
  final int maxSks;

  const KuotaSks({required this.ips, required this.maxSks});
}

abstract class KrsRepository {
  Future<Krs?> fetchKrs();
  Future<List<KelasKuliah>> fetchKelasTersedia({required String tahunAkademik, required String semester});
  Future<KuotaSks> fetchKuota();
  Future<Krs> submitKrs({
    required String tahunAkademik,
    required String semester,
    required List<int> kelasKuliahIds,
  });
  Future<Krs> updateKrs(
    String id, {
    required List<int> kelasKuliahIds,
    String? tahunAkademik,
    String? semester,
  });
}
