import 'package:flutter/material.dart';
import 'package:dosen/core/services/session_service.dart';
import 'package:dosen/features/auth/presentation/pages/login_page.dart';
import 'package:dosen/features/home/presentation/pages/home_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sistem Informasi Akademik - Dosen',
      theme: ThemeData(primarySwatch: Colors.teal, fontFamily: 'Poppins'),
      home: const _AuthGate(),
    );
  }
}

class _AuthGate extends StatefulWidget {
  const _AuthGate();

  @override
  State<_AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<_AuthGate> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    await SessionService.instance.load();
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return SessionService.instance.isLoggedIn ? const HomePage() : const LoginPage();
  }
}
