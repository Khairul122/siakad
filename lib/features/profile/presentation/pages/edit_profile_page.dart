import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:dosen/core/constants/api_config.dart';
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
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

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

  Future<void> _pickImage(ProfileController controller, ImageSource source) async {
    Navigator.pop(context);
    final pickedFile = await _picker.pickImage(
      source: source,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 80,
    );
    if (pickedFile == null || !mounted) return;

    setState(() => _imageFile = File(pickedFile.path));
    final success = await controller.uploadPhoto(pickedFile.path);
    if (!mounted) return;
    if (success) {
      _showSnackBar('Foto profil berhasil diperbarui');
    } else if (controller.errorMessage != null) {
      _showSnackBar(controller.errorMessage!, isError: true);
    }
  }

  void _showImageSourceDialog(ProfileController controller) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: AppColors.primary),
              title: const Text('Ambil Foto'),
              onTap: () => _pickImage(controller, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: AppColors.primary),
              title: const Text('Pilih dari Galeri'),
              onTap: () => _pickImage(controller, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.close, color: AppColors.error),
              title: const Text('Batal'),
              onTap: () => Navigator.pop(ctx),
            ),
          ],
        ),
      ),
    );
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
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: controller.isUploadingPhoto ? null : () => _showImageSourceDialog(controller),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircleAvatar(
                            radius: 55,
                            backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                            backgroundImage: _imageFile != null
                                ? FileImage(_imageFile!) as ImageProvider
                                : ((widget.dosen?.photoUrl ?? '').isNotEmpty
                                    ? NetworkImage(
                                        ApiConfig.resolveImageUrl(widget.dosen!.photoUrl),
                                        headers: const {'localtonet-skip-warning': 'true'},
                                      )
                                    : null),
                            child: _imageFile == null && (widget.dosen?.photoUrl ?? '').isEmpty
                                ? const Icon(Icons.person, size: 55, color: AppColors.primary)
                                : null,
                          ),
                          if (controller.isUploadingPhoto)
                            const CircularProgressIndicator(color: AppColors.primary),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: controller.isUploadingPhoto ? null : () => _showImageSourceDialog(controller),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            controller.isUploadingPhoto ? 'Mengupload...' : 'Edit Foto',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 5),
                          const Icon(Icons.edit, size: 16),
                        ],
                      ),
                    ),
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
