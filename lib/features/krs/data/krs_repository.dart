import 'package:sistem_akademik/core/constants/api_paths.dart';
import 'package:sistem_akademik/core/network/api_client.dart';
import 'package:sistem_akademik/features/krs/domain/kelas_kuliah.dart';
import 'package:sistem_akademik/features/krs/domain/krs.dart';
import 'package:sistem_akademik/features/krs/domain/krs_repository.dart';

class ApiKrsRepository implements KrsRepository {
  final _api = ApiClient.instance;

  @override
  Future<Krs?> fetchKrs() async {
    final data = await _api.get(ApiPaths.krs) as List<dynamic>;
    if (data.isEmpty) return null;
    final item = data.first;
    return Krs.fromMap('${item['id']}', Map<String, dynamic>.from(item as Map));
  }

  @override
  Future<List<KelasKuliah>> fetchKelasTersedia({required String tahunAkademik, required String semester}) async {
    final data = await _api.get(ApiPaths.kelasKuliah, query: {
      'tahun_akademik': tahunAkademik,
      'semester': semester,
    }) as List<dynamic>;

    return data.map((item) => KelasKuliah.fromMap(Map<String, dynamic>.from(item as Map))).toList();
  }

  @override
  Future<KuotaSks> fetchKuota() async {
    final data = await _api.get(ApiPaths.krsKuota) as Map<String, dynamic>;
    return KuotaSks(
      ips: data['ips'] == null ? null : double.tryParse('${data['ips']}'),
      maxSks: data['max_sks'] is int ? data['max_sks'] as int : int.tryParse('${data['max_sks']}') ?? 21,
    );
  }

  @override
  Future<Krs> submitKrs({
    required String tahunAkademik,
    required String semester,
    required List<int> kelasKuliahIds,
  }) async {
    final data = await _api.post(ApiPaths.krs, body: {
      'tahun_akademik': tahunAkademik,
      'semester': semester,
      'kelas_kuliah_ids': kelasKuliahIds,
    }) as Map<String, dynamic>;

    return Krs.fromMap('${data['id']}', data);
  }

  @override
  Future<Krs> updateKrs(
    String id, {
    required List<int> kelasKuliahIds,
    String? tahunAkademik,
    String? semester,
  }) async {
    final body = <String, dynamic>{
      'kelas_kuliah_ids': kelasKuliahIds,
    };
    if (tahunAkademik != null && tahunAkademik.isNotEmpty) {
      body['tahun_akademik'] = tahunAkademik;
    }
    if (semester != null && semester.isNotEmpty) {
      body['semester'] = semester;
    }

    final data = await _api.put(ApiPaths.krsItem(id), body: body) as Map<String, dynamic>;

    return Krs.fromMap('${data['id']}', data);
  }
}
