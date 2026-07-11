import 'package:flutter/material.dart';
import 'package:sistem_akademik/app/app.dart';
import 'package:sistem_akademik/core/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await NotificationService.scheduleHarian();
  } catch (e) {
    debugPrint('Notifikasi lokal gagal: $e');
  }
  runApp(const MyApp());
}
