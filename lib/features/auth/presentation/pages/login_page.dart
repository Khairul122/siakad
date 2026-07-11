import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistem_akademik/core/constants/app_colors.dart';
import 'package:sistem_akademik/core/widgets/logo_widget.dart';
import 'package:sistem_akademik/core/widgets/rounded_input.dart';
import 'package:sistem_akademik/features/auth/presentation/controllers/auth_controller.dart';
import 'package:sistem_akademik/features/auth/presentation/pages/register_page.dart';
import 'package:sistem_akademik/features/auth/presentation/pages/reset_password_page.dart';
import 'package:sistem_akademik/features/dashboard/presentation/pages/dashboard_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthController(),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  Future<void> _login(AuthController controller) async {
    final success =
        await controller.login(_emailController.text.trim(), _passController.text.trim());
    if (!mounted) return;
    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardPage()),
      );
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
              const Text(
                'SISTEM INFORMASI AKADEMIK',
                style: TextStyle(
                    color: AppColors.primary, fontSize: 18, fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              const Text(
                'Universitas Langit Raya',
                style: TextStyle(color: AppColors.primaryLight),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 18),
              const LogoWidget(),
              const SizedBox(height: 28),
              const Text(
                'Login Mahasiswa',
                style: TextStyle(
                    color: AppColors.primary, fontSize: 26, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 18),
              RoundedInput(
                controller: _emailController,
                hint: 'Email',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              RoundedInput(
                controller: _passController,
                hint: 'Password',
                prefixIcon: Icons.lock,
                obscure: _obscure,
                suffixIcon: IconButton(
                  icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: controller.isLoading ? null : () => _login(controller),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                  ),
                  child: controller.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Login', style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.push(
                    context, MaterialPageRoute(builder: (_) => const ResetPasswordPage())),
                child: const Text('Lupa Password?', style: TextStyle(color: AppColors.primary)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Belum punya akun? ', style: TextStyle(color: Colors.grey)),
                  GestureDetector(
                    onTap: () => Navigator.push(
                        context, MaterialPageRoute(builder: (_) => const RegisterPage())),
                    child: const Text('Daftar',
                        style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
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
