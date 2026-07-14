import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  static const _channelId = 'dosen_daily';
  static const _channelName = 'Notifikasi Harian Dosen';

  static const _headsUpChannelId = 'dosen_headsup';
  static const _headsUpChannelName = 'Notifikasi Masuk';
  static const _headsUpChannelDescription =
      'Notifikasi baru dari Sistem Akademik (KRS, nilai, presensi, tagihan, dll) yang muncul langsung sebagai heads-up.';

  static Future<void> init() async {
    if (_initialized) return;

    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));

    await _plugin.initialize(
      InitializationSettings(
        android: const AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: const DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        ),
      ),
    );

    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidPlugin?.createNotificationChannel(
      const AndroidNotificationChannel(
        _channelId,
        _channelName,
        importance: Importance.high,
      ),
    );

    await androidPlugin?.createNotificationChannel(
      const AndroidNotificationChannel(
        _headsUpChannelId,
        _headsUpChannelName,
        description: _headsUpChannelDescription,
        importance: Importance.max,
      ),
    );

    await androidPlugin?.requestNotificationsPermission();

    _initialized = true;
  }

  static Future<void> scheduleHarian() async {
    await init();
    await _plugin.cancelAll();

    await _scheduleDaily(
      id: 2,
      title: '☀️ Selamat Siang!',
      body: 'Jangan lupa input presensi dan nilai mahasiswa.',
      hour: 12,
      minute: 0,
    );

    _showIfCurrentTime(DateTime.now());
  }

  static void _showIfCurrentTime(DateTime now) {
    final h = now.hour;
    if (h >= 12 && h < 15) {
      _showNow(
        id: 20,
        title: '☀️ Selamat Siang!',
        body: 'Jangan lupa input presensi dan nilai mahasiswa.',
      );
    }
  }

  static NotificationDetails get _details => const NotificationDetails(
    android: AndroidNotificationDetails(
      _channelId,
      _channelName,
      importance: Importance.high,
      priority: Priority.high,
    ),
    iOS: DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    ),
  );

  static Future<void> _scheduleDaily({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      scheduled,
      _details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static Future<void> _showNow({
    required int id,
    required String title,
    required String body,
  }) async {
    await _plugin.show(id, title, body, _details);
  }

  static NotificationDetails get _headsUpDetails => const NotificationDetails(
    android: AndroidNotificationDetails(
      _headsUpChannelId,
      _headsUpChannelName,
      channelDescription: _headsUpChannelDescription,
      importance: Importance.max,
      priority: Priority.max,
      category: AndroidNotificationCategory.message,
      playSound: true,
      enableVibration: true,
    ),
    iOS: DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      interruptionLevel: InterruptionLevel.timeSensitive,
    ),
  );

  /// Menampilkan notifikasi heads-up (langsung muncul sebagai banner di layar,
  /// bukan cuma masuk ke tray) untuk notifikasi baru dari backend. Dipanggil
  /// oleh [NotifikasiPollingService] saat menemukan notifikasi baru.
  static Future<void> showHeadsUp({
    required int id,
    required String title,
    required String body,
  }) async {
    await init();
    await _plugin.show(id, title, body, _headsUpDetails);
  }
}
