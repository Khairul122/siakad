import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dosen/app/app.dart';
import 'package:dosen/core/constants/app_colors.dart';
import 'package:dosen/core/widgets/dosen_bottom_nav.dart';
import 'package:dosen/features/auth/presentation/controllers/auth_controller.dart';
import 'package:dosen/features/bantuan/presentation/pages/bantuan_masukan_page.dart';
import 'package:dosen/features/home/presentation/pages/home_page.dart';
import 'package:dosen/features/profile/presentation/controllers/profile_controller.dart';
import 'package:dosen/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:dosen/features/profile/presentation/pages/ubah_password_page.dart';

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
  Future<void> _showLogoutDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text('Konfirmasi Keluar'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
            onPressed: () => Navigator.of(dialogContext).pop(),
          ),
          TextButton(
            child: const Text(
              'Keluar',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              try {
                await AuthController().logout();
                if (mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const MyApp()),
                    (route) => false,
                  );
                }
              } catch (e) {
                debugPrint('Logout error: $e');
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileController = context.watch<ProfileController>();

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Column(
        children: [
          const SizedBox(height: 60),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: GestureDetector(
                onTap: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const HomePage()),
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Builder(
                builder: (context) {
                  final dosen = profileController.dosen;
                  final nama = dosen?.nama ?? 'Dosen';
                  final nip = dosen?.nip ?? '-';
                  final photoUrl = dosen?.photoUrl ?? '';

                  return RefreshIndicator(
                    onRefresh: profileController.refresh,
                    child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        const SizedBox(height: 30),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.primary, width: 3),
                          ),
                          child: CircleAvatar(
                            radius: 55,
                            backgroundImage: photoUrl.isNotEmpty
                                ? NetworkImage(photoUrl) as ImageProvider
                                : const AssetImage('assets/profil.jpg'),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(nama, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 5),
                        Text('NIP/NIDN $nip', style: const TextStyle(fontSize: 14, color: AppColors.primary)),
                        const SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Menu Setting',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade900,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        _menuItem(
                          icon: Icons.key,
                          title: 'Ubah Password',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const UbahPasswordPage()),
                          ),
                        ),
                        _menuItem(
                          icon: Icons.person_outline,
                          title: 'Edit Profil',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => EditProfilePage(dosen: dosen)),
                          ),
                        ),
                        _menuItem(
                          icon: Icons.help_outline,
                          title: 'Bantuan dan Masukan',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const BantuanMasukanPage()),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 6),
                          child: InkWell(
                            onTap: _showLogoutDialog,
                            child: const Row(
                              children: [
                                Icon(Icons.logout, color: Colors.red),
                                SizedBox(width: 15),
                                Expanded(
                                  child: Text(
                                    'Keluar',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                                Icon(Icons.arrow_forward_ios, size: 18, color: Colors.red),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const DosenBottomNav(currentIndex: 2),
    );
  }

  Widget _menuItem({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 6),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Icon(icon, size: 24, color: Colors.black87),
            const SizedBox(width: 15),
            Expanded(
              child: Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
            ),
            const Icon(Icons.arrow_forward_ios, size: 18),
          ],
        ),
      ),
    );
  }
}
