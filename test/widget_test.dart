import 'package:flutter_test/flutter_test.dart';
import 'package:sistem_akademik/features/krs/domain/kelas_kuliah.dart';
import 'package:sistem_akademik/features/krs/domain/krs.dart';
import 'package:sistem_akademik/features/krs/domain/krs_repository.dart';
import 'package:sistem_akademik/features/krs/presentation/controllers/pilih_mata_kuliah_controller.dart';

class FakeKrsRepository implements KrsRepository {
  @override
  Future<Krs?> fetchKrs() async => null;

  @override
  Future<List<KelasKuliah>> fetchKelasTersedia({required String tahunAkademik, required String semester}) async => [];

  @override
  Future<KuotaSks> fetchKuota() async => const KuotaSks(ips: 3.5, maxSks: 24);

  @override
  Future<Krs> submitKrs({required String tahunAkademik, required String semester, required List<int> kelasKuliahIds}) async {
    return const Krs(
      id: '1',
      uid: 'user1',
      tahunAkademik: '2025/2026',
      semester: '1',
      status: 'diajukan',
      mataKuliah: [],
    );
  }

  @override
  Future<Krs> updateKrs(String id, {required List<int> kelasKuliahIds, String? tahunAkademik, String? semester}) async {
    return Krs(
      id: id,
      uid: 'user1',
      tahunAkademik: tahunAkademik ?? '2025/2026',
      semester: semester ?? '1',
      status: 'diajukan',
      mataKuliah: const [],
    );
  }
}

void main() {
  test('KuotaSks calculation test', () {
    const kuota = KuotaSks(ips: 3.8, maxSks: 24);
    expect(kuota.ips, equals(3.8));
    expect(kuota.maxSks, equals(24));
  });

  test('PilihMataKuliahController SKS calculation and kuota check', () {
    final controller = PilihMataKuliahController(repository: FakeKrsRepository());
    controller.maxSks = 20;
    controller.kelasList = [
      const KelasKuliah(
        id: 1,
        mataKuliahKode: 'IF101',
        mataKuliahNama: 'Algoritma',
        sks: 4,
        namaKelas: 'A',
        dosenNama: 'Dosen A',
        hari: 'Senin',
        jamMulai: '08:00',
        jamSelesai: '10:00',
        ruangan: 'R101',
        kuota: 30,
        terisi: 10,
        tahunAkademik: '2025/2026',
        semester: '1',
      ),
      const KelasKuliah(
        id: 2,
        mataKuliahKode: 'IF102',
        mataKuliahNama: 'Struktur Data',
        sks: 4,
        namaKelas: 'B',
        dosenNama: 'Dosen B',
        hari: 'Selasa',
        jamMulai: '10:00',
        jamSelesai: '12:00',
        ruangan: 'R102',
        kuota: 30,
        terisi: 5,
        tahunAkademik: '2025/2026',
        semester: '1',
      ),
    ];

    controller.toggle(1);
    controller.toggle(2);

    expect(controller.totalSksTerpilih, equals(8));
    expect(controller.melebihiKuota, isFalse);
  });
}
