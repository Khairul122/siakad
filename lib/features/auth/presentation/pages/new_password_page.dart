import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dosen/app/app.dart';
import 'package:dosen/core/constants/app_colors.dart';
import 'package:dosen/features/auth/presentation/controllers/auth_controller.dart';

class NewPasswordPage extends StatelessWidget {
  final String email;
  final String otp;

  const NewPasswordPage({super.key, required this.email, required this.otp});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthController(),
      child: _NewPasswordView(email: email, otp: otp),
    );
  }
}

class _NewPasswordView extends StatefulWidget {
  final String email;
  final String otp;

  const _NewPasswordView({required this.email, required this.otp});

  @override
  State<_NewPasswordView> createState() => _NewPasswordViewState();
}

class _NewPasswordViewState extends State<_NewPasswordView> {
  final _passController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _showPass1 = false;
  bool _showPass2 = false;

  @override
  void dispose() {
    _passController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _updatePassword(AuthController controller) async {
    final success = await controller.resetPassword(
      email: widget.email,
      otp: widget.otp,
      password: _passController.text.trim(),
      confirm: _confirmController.text.trim(),
    );
    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password berhasil diperbarui!')),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MyApp()),
        (route) => false,
      );
    } else if (controller.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(controller.errorMessage!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AuthController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 30),
              Image.asset(
                'assets/logo_profil.jpg',
                width: 120,
                height: 120,
              ),
              const SizedBox(height: 20),
              const Text(
                'Create New Password',
                style: TextStyle(fontSize: 22, color: AppColors.primary),
              ),
              const SizedBox(height: 10),
              Text(
                'Resetting password for: ${widget.email}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _passController,
                obscureText: !_showPass1,
                decoration: InputDecoration(
                  hintText: 'Password Baru',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(_showPass1 ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => setState(() => _showPass1 = !_showPass1),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _confirmController,
                obscureText: !_showPass2,
                decoration: InputDecoration(
                  hintText: 'Konfirmasi Password',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(_showPass2 ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => setState(() => _showPass2 = !_showPass2),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: controller.isLoading ? null : () => _updatePassword(controller),
                  child: controller.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Konfirmasi', style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
