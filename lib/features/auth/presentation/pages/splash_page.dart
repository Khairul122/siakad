import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sistem_akademik/core/services/session_service.dart';
import 'package:sistem_akademik/core/widgets/logo_widget.dart';
import 'package:sistem_akademik/features/auth/presentation/pages/login_page.dart';
import 'package:sistem_akademik/features/dashboard/presentation/pages/dashboard_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _decideInitialRoute();
  }

  Future<void> _decideInitialRoute() async {
    final delay = Future.delayed(const Duration(seconds: 2));
    await SessionService.instance.load();
    await delay;
    if (!mounted) return;

    if (SessionService.instance.isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardPage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: LogoWidget()),
    );
  }
}
