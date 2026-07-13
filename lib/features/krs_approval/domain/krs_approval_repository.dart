import 'package:dosen/features/krs_approval/domain/pengajuan_krs.dart';

abstract class KrsApprovalRepository {
  Future<List<PengajuanKrs>> fetchPengajuan({String? status});
  Future<PengajuanKrs> approve(int id, {String? catatan});
  Future<PengajuanKrs> reject(int id, {required String catatan});
}
