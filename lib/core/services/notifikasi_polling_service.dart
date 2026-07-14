import 'dart:async';

import 'package:sistem_akademik/core/services/notification_service.dart';
import 'package:sistem_akademik/features/notifikasi/data/notifikasi_repository.dart';
import 'package:sistem_akademik/features/notifikasi/domain/notifikasi.dart';

/// Polling ringan ke endpoint notifikasi selama app aktif, lalu menampilkan
/// notifikasi baru sebagai heads-up (banner langsung muncul di layar).
///
/// Backend belum punya push server (FCM), jadi ini cara paling sederhana
/// untuk memberi efek "heads-up" tanpa infrastruktur push tambahan: dibanding
/// [NotificationService.scheduleHarian] yang cuma pesan kalengan terjadwal,
/// ini benar-benar mengecek data notifikasi asli dari backend.
class NotifikasiPollingService {
  NotifikasiPollingService._();

  static final NotifikasiPollingService instance = NotifikasiPollingService._();

  static const _interval = Duration(seconds: 30);
  static const _headsUpIdOffset = 500000;

  final _repository = ApiNotifikasiRepository();
  Timer? _timer;
  final Set<String> _seenIds = {};
  bool _baselineLoaded = false;

  void start() {
    if (_timer != null) return;
    _poll(isBaseline: true);
    _timer = Timer.periodic(_interval, (_) => _poll());
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    _seenIds.clear();
    _baselineLoaded = false;
  }

  Future<void> _poll({bool isBaseline = false}) async {
    List<Notifikasi> list;
    try {
      list = await _repository.fetchNotifikasi();
    } catch (_) {
      return;
    }

    if (isBaseline || !_baselineLoaded) {
      _seenIds
        ..clear()
        ..addAll(list.map((n) => n.id));
      _baselineLoaded = true;
      return;
    }

    final notifikasiBaru = list.where((n) => !n.dibaca && !_seenIds.contains(n.id));

    for (final notifikasi in notifikasiBaru) {
      await NotificationService.showHeadsUp(
        id: _headsUpIdOffset + (int.tryParse(notifikasi.id) ?? notifikasi.id.hashCode.abs() % 100000),
        title: notifikasi.judul,
        body: notifikasi.isi,
      );
    }

    _seenIds
      ..clear()
      ..addAll(list.map((n) => n.id));
  }
}
