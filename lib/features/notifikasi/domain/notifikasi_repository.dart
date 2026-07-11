import 'package:dosen/features/notifikasi/domain/notifikasi.dart';

abstract class NotifikasiRepository {
  Future<List<Notifikasi>> fetchNotifikasi();

  Future<void> markAsRead(int id);
}
