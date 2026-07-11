import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistem_akademik/core/constants/app_colors.dart';
import 'package:sistem_akademik/core/widgets/rounded_input.dart';
import 'package:sistem_akademik/features/auth/presentation/controllers/auth_controller.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthController(),
      child: const _RegisterView(),
    );
  }
}

class _RegisterView extends StatefulWidget {
  const _RegisterView();

  @override
  State<_RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<_RegisterView> {
  final _namaController = TextEditingController();
  final _nimController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();

  bool _obscurePass = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _namaController.dispose();
    _nimController.dispose();
    _emailController.dispose();
    _passController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  Future<void> _register(AuthController controller) async {
    final success = await controller.register(
      nama: _namaController.text.trim(),
      nim: _nimController.text.trim(),
      email: _emailController.text.trim(),
      password: _passController.text.trim(),
      confirmPassword: _confirmPassController.text.trim(),
    );
    if (!mounted) return;
    if (success) {
      _showSnackBar('Akun berhasil dibuat! Silakan login.');
      Navigator.popUntil(context, (route) => route.isFirst);
    } else if (controller.errorMessage != null) {
      _showSnackBar(controller.errorMessage!, isError: true);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.error : AppColors.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AuthController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 30),
          child: Column(
            children: [
              const SizedBox(height: 10),
              const Text('SISTEM INFORMASI AKADEMIK',
                  style: TextStyle(
                      color: AppColors.accent, fontSize: 16, fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center),
              const SizedBox(height: 6),
              const Text('Universitas Langit Raya',
                  style: TextStyle(color: AppColors.accent), textAlign: TextAlign.center),
              const SizedBox(height: 18),
              Image.asset('assets/images/logo_universitas.png',
                  width: 120,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.school, size: 80, color: AppColors.accent)),
              const SizedBox(height: 24),
              const Text('Daftar Akun Mahasiswa',
                  style: TextStyle(
                      color: AppColors.accent, fontSize: 22, fontWeight: FontWeight.w700)),
              const SizedBox(height: 18),
              RoundedInput(
                  controller: _namaController,
                  hint: 'Nama Lengkap',
                  prefixIcon: Icons.person_outline),
              const SizedBox(height: 12),
              RoundedInput(
                  controller: _nimController,
                  hint: 'NIM Mahasiswa',
                  prefixIcon: Icons.badge_outlined,
                  keyboardType: TextInputType.number),
              const SizedBox(height: 12),
              RoundedInput(
                  controller: _emailController,
                  hint: 'Email',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 12),
              RoundedInput(
                controller: _passController,
                hint: 'Password',
                prefixIcon: Icons.lock_outline,
                obscure: _obscurePass,
                suffixIcon: IconButton(
                  icon: Icon(_obscurePass ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey),
                  onPressed: () => setState(() => _obscurePass = !_obscurePass),
                ),
              ),
              const SizedBox(height: 12),
              RoundedInput(
                controller: _confirmPassController,
                hint: 'Konfirmasi Password',
                prefixIcon: Icons.lock,
                obscure: _obscureConfirm,
                suffixIcon: IconButton(
                  icon: Icon(_obscureConfirm ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey),
                  onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                ),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: controller.isLoading ? null : () => _register(controller),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                  ),
                  child: controller.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Daftar', style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Sudah punya akun? ', style: TextStyle(color: Colors.grey)),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text('Login',
                        style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
