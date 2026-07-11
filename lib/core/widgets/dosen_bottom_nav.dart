import 'package:flutter/material.dart';
import 'package:dosen/core/constants/app_colors.dart';
import 'package:dosen/features/home/presentation/pages/home_page.dart';
import 'package:dosen/features/presensi/presentation/pages/presensi_page.dart';
import 'package:dosen/features/profile/presentation/pages/profile_page.dart';

class DosenBottomNav extends StatelessWidget {
  final int currentIndex;
  const DosenBottomNav({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home_rounded,
                label: 'Home',
                isActive: currentIndex == 0,
                onTap: currentIndex == 0
                    ? null
                    : () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const HomePage()),
                      ),
              ),
              _NavItem(
                icon: Icons.assignment_rounded,
                label: 'Presensi',
                isActive: currentIndex == 1,
                onTap: currentIndex == 1
                    ? null
                    : () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const PresensiPage()),
                      ),
              ),
              _NavItem(
                icon: Icons.person_rounded,
                label: 'Profil',
                isActive: currentIndex == 2,
                onTap: currentIndex == 2
                    ? null
                    : () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const ProfilePage()),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback? onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    this.onTap,
  });

  static const _grey = Color(0xFF9E9E9E);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 80,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 3,
              width: isActive ? 24 : 0,
              margin: const EdgeInsets.only(bottom: 4),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Icon(icon, size: 26, color: isActive ? AppColors.primary : _grey),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                color: isActive ? AppColors.primary : _grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
