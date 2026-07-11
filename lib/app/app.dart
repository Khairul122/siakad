import 'package:flutter/material.dart';
import 'package:sistem_akademik/features/auth/presentation/pages/splash_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Righteous'),
      home: const SplashPage(),
    );
  }
}
