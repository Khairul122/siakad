import 'package:flutter/material.dart';
import 'package:dosen/app/app.dart';
import 'package:dosen/core/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await NotificationService.scheduleHarian();
  } catch (e) {
    debugPrint('Notifikasi lokal gagal: $e');
  }
  runApp(const MyApp());
}
