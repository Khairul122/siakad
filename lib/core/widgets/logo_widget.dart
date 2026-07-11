import 'package:flutter/material.dart';
import 'package:sistem_akademik/core/constants/app_colors.dart';

class LogoWidget extends StatelessWidget {
  final double width;

  const LogoWidget({super.key, this.width = 170});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo_universitas.png',
      width: width,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) =>
          Icon(Icons.school, size: width * 0.6, color: AppColors.primary),
    );
  }
}
