import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dosen/core/constants/api_config.dart';
import 'package:dosen/core/constants/app_colors.dart';
import 'package:dosen/features/profile/presentation/controllers/profile_controller.dart';
import 'package:dosen/features/profile/presentation/pages/success_save_page.dart';

class UbahPasswordPage extends StatelessWidget {
  const UbahPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileController(),
      child: const _UbahPasswordView(),
    );
  }
}

class _UbahPasswordView extends StatefulWidget {
  const _UbahPasswordView();

  @override
  State<_UbahPasswordView> createState() => _UbahPasswordViewState();
}

class _UbahPasswordViewState extends State<_UbahPasswordView> {
  final _oldPassController = TextEditingController();
  final _newPassController = TextEditingController();
  final _confirmPassController = TextEditingController();

  @override
  void dispose() {
    _oldPassController.dispose();
    _newPassController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  Future<void> _konfirmasi(ProfileController controller) async {
    final success = await controller.changePassword(
      oldPassword: _oldPassController.text.trim(),
      newPassword: _newPassController.text.trim(),
      confirmPassword: _confirmPassController.text.trim(),
    );
    if (!mounted) return;
    if (success) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const SuccessSavePage(message: 'Password kamu telah berhasil diperbarui'),
        ),
      );
    } else if (controller.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(controller.errorMessage!), backgroundColor: AppColors.error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ProfileController>();
    final photoUrl = controller.dosen?.photoUrl ?? '';

    return Scaffold(
      backgroundColor: AppColors.primaryLight,
      body: Column(
        children: [
          const SizedBox(height: 40),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 25),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    const Text('Ganti Password', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primary, width: 3),
                        image: DecorationImage(
                          image: photoUrl.isNotEmpty
                              ? NetworkImage(
                                  ApiConfig.resolveImageUrl(photoUrl),
                                  headers: const {'localtonet-skip-warning': 'true'},
                                ) as ImageProvider
                              : const AssetImage('assets/profil.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    _inputField(
                      icon: Icons.lock_outline,
                      hint: 'Password Lama',
                      controller: _oldPassController,
                    ),
                    _inputField(
                      icon: Icons.lock_outline,
                      hint: 'Password Baru',
                      controller: _newPassController,
                    ),
                    _inputField(
                      icon: Icons.lock_outline,
                      hint: 'Konfirmasi Password',
                      controller: _confirmPassController,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                        onPressed: controller.isSaving ? null : () => _konfirmasi(controller),
                        child: controller.isSaving
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                'Konfirmasi',
                                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputField({
    required IconData icon,
    required String hint,
    required TextEditingController controller,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          icon: Icon(icon),
        ),
        obscureText: true,
      ),
    );
  }
}
