import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dosen/core/constants/app_colors.dart';
import 'package:dosen/features/auth/domain/dosen.dart';
import 'package:dosen/features/profile/presentation/controllers/profile_controller.dart';

class EditProfilePage extends StatelessWidget {
  final Dosen? dosen;

  const EditProfilePage({super.key, this.dosen});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileController(),
      child: _EditProfileView(dosen: dosen),
    );
  }
}

class _EditProfileView extends StatefulWidget {
  final Dosen? dosen;

  const _EditProfileView({this.dosen});

  @override
  State<_EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<_EditProfileView> {
  late final TextEditingController _namaController;
  late final TextEditingController _prodiController;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.dosen?.nama ?? '');
    _prodiController = TextEditingController(text: widget.dosen?.prodi ?? '');
  }

  @override
  void dispose() {
    _namaController.dispose();
    _prodiController.dispose();
    super.dispose();
  }

  Future<void> _simpan(ProfileController controller) async {
    final success = await controller.saveProfile(
      nama: _namaController.text.trim(),
      prodi: _prodiController.text.trim(),
    );
    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil berhasil disimpan'), backgroundColor: AppColors.primary),
      );
      Navigator.pop(context);
    } else if (controller.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(controller.errorMessage!), backgroundColor: AppColors.error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ProfileController>();

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
                    const Text('Edit Profil', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 25),
                    _buildReadOnly(
                      'NIP/NIDN',
                      widget.dosen?.nip.isNotEmpty == true ? widget.dosen!.nip : '-',
                    ),
                    _buildReadOnly(
                      'Email',
                      widget.dosen?.email.isNotEmpty == true ? widget.dosen!.email : '-',
                    ),
                    const SizedBox(height: 8),
                    _buildInput('Nama', _namaController),
                    _buildInput('Program Studi', _prodiController),
                    const SizedBox(height: 25),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryLight,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: controller.isSaving ? null : () => _simpan(controller),
                        child: controller.isSaving
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('Simpan Perubahan', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadOnly(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        readOnly: true,
        controller: TextEditingController(text: value),
        style: const TextStyle(color: Colors.black54),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildInput(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          decoration: const InputDecoration(
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black26)),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primaryLight)),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
