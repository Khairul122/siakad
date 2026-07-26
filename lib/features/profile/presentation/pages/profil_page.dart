import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistem_akademik/app/app.dart';
import 'package:sistem_akademik/core/constants/api_config.dart';
import 'package:sistem_akademik/core/constants/app_colors.dart';
import 'package:sistem_akademik/core/services/notifikasi_polling_service.dart';
import 'package:sistem_akademik/features/absensi/presentation/pages/absensi_page.dart';
import 'package:sistem_akademik/features/auth/presentation/controllers/auth_controller.dart';
import 'package:sistem_akademik/features/auth/presentation/pages/reset_password_page.dart';
import 'package:sistem_akademik/features/bantuan/presentation/pages/bantuan_masukan_page.dart';
import 'package:sistem_akademik/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:sistem_akademik/features/profile/presentation/controllers/profile_controller.dart';
import 'package:sistem_akademik/features/profile/presentation/pages/edit_profil_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileController(),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatefulWidget {
  const _ProfileView();

  @override
  State<_ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<_ProfileView> {
  int _currentIndex = 2;

  Future<void> _showLogoutDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text('Konfirmasi Keluar'),
          content: const Text('Apakah Anda yakin ingin keluar dari akun ini?'),
          actions: [
            TextButton(
              child: const Text('Batal', style: TextStyle(color: Colors.grey)),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: const Text('Keluar',
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                try {
                  NotifikasiPollingService.instance.stop();
                  await AuthController().logout();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Berhasil keluar dari sistem')),
                    );
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const MyApp()),
                      (route) => false,
                    );
                  }
                } catch (e) {
                  debugPrint('Error logout: $e');
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileController = context.watch<ProfileController>();

    return Scaffold(
      backgroundColor: AppColors.accent,
      appBar: AppBar(
        backgroundColor: AppColors.accent,
        elevation: 0,
        centerTitle: true,
        title: const Text('Profil', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const DashboardPage()),
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Builder(
          builder: (context) {
            final user = profileController.user;
            final nama = user?.nama ?? 'Mahasiswa';
            final nim = user?.nim ?? '-';
            final email = user?.email ?? '-';
            final photoUrl = user?.photoUrl ?? '';

            return RefreshIndicator(
              onRefresh: profileController.refresh,
              child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: AppColors.accent.withValues(alpha: 0.15),
                    backgroundImage: photoUrl.isNotEmpty
                        ? NetworkImage(
                            ApiConfig.resolveImageUrl(photoUrl),
                            headers: const {'localtonet-skip-warning': 'true'},
                          )
                        : null,
                    child: photoUrl.isEmpty
                        ? const Icon(Icons.person, size: 55, color: AppColors.accent)
                        : null,
                  ),
                  const SizedBox(height: 12),
                  Text(nama, style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 20)),
                  const SizedBox(height: 4),
                  Text(nim, style: const TextStyle(color: Colors.black54, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(email, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                  if (user != null && (user.prodi.isNotEmpty || user.fakultas.isNotEmpty)) ...[
                    const SizedBox(height: 4),
                    Text(
                      [if (user.prodi.isNotEmpty) user.prodi, if (user.fakultas.isNotEmpty) user.fakultas].join(' • '),
                      style: const TextStyle(color: Colors.black45, fontSize: 12),
                    ),
                  ],
                  const SizedBox(height: 40),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Menu Setting', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 15),
                      _buildMenuItem(
                        icon: Icons.lock_outline,
                        text: 'Ubah Password',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ResetPasswordPage()),
                        ),
                      ),
                      _buildMenuItem(
                        icon: Icons.edit,
                        text: 'Edit Profil',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => EditProfilPage(user: user)),
                        ),
                      ),
                      _buildMenuItem(
                        icon: Icons.help_outline,
                        text: 'Bantuan dan Masukan',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const BantuanMasukanPage()),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: _showLogoutDialog,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Keluar', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent)),
                          Icon(Icons.logout, color: Colors.redAccent),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: AppColors.accent,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DashboardPage()));
          } else if (index == 1) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AbsensiPage()));
          }
          setState(() => _currentIndex = index);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: AppColors.accent),
            const SizedBox(width: 15),
            Expanded(
              child: Text(text, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black54),
          ],
        ),
      ),
    );
  }
}
