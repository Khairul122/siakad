import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sistem_akademik/core/constants/api_config.dart';
import 'package:sistem_akademik/core/constants/app_colors.dart';
import 'package:sistem_akademik/features/auth/domain/app_user.dart';
import 'package:sistem_akademik/features/profile/presentation/controllers/profile_controller.dart';

class EditProfilPage extends StatelessWidget {
  final AppUser? user;

  const EditProfilPage({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileController(),
      child: _EditProfilView(user: user),
    );
  }
}

class _EditProfilView extends StatefulWidget {
  final AppUser? user;

  const _EditProfilView({this.user});

  @override
  State<_EditProfilView> createState() => _EditProfilViewState();
}

class _EditProfilViewState extends State<_EditProfilView> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  late final TextEditingController _namaController;
  late final TextEditingController _noHpController;
  late final TextEditingController _tanggalLahirController;
  late final TextEditingController _alamatController;
  late final TextEditingController _kelasController;
  late final TextEditingController _angkatanController;
  late final TextEditingController _prodiController;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.user?.nama ?? '');
    _noHpController = TextEditingController(text: widget.user?.noHp ?? '');
    _tanggalLahirController = TextEditingController(text: widget.user?.tanggalLahir ?? '');
    _alamatController = TextEditingController(text: widget.user?.alamat ?? '');
    _kelasController = TextEditingController(text: widget.user?.kelas ?? '');
    _angkatanController = TextEditingController(text: widget.user?.angkatan ?? '');
    _prodiController = TextEditingController(text: widget.user?.prodi ?? '');
  }

  @override
  void dispose() {
    _namaController.dispose();
    _noHpController.dispose();
    _tanggalLahirController.dispose();
    _alamatController.dispose();
    _kelasController.dispose();
    _angkatanController.dispose();
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
              leading: const Icon(Icons.camera_alt, color: AppColors.accent),
              title: const Text('Ambil Foto'),
              onTap: () => _pickImage(controller, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: AppColors.accent),
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

  Future<void> _selectTanggalLahir() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(_tanggalLahirController.text) ?? DateTime(2005),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.accent,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        final monthStr = picked.month.toString().padLeft(2, '0');
        final dayStr = picked.day.toString().padLeft(2, '0');
        _tanggalLahirController.text = '${picked.year}-$monthStr-$dayStr';
      });
    }
  }

  Future<void> _simpan(ProfileController controller) async {
    final success = await controller.saveProfile(
      nama: _namaController.text.trim(),
      noHp: _noHpController.text.trim(),
      tanggalLahir: _tanggalLahirController.text.trim(),
      alamat: _alamatController.text.trim(),
      kelas: _kelasController.text.trim(),
      angkatan: _angkatanController.text.trim(),
      prodi: _prodiController.text.trim(),
    );
    if (!mounted) return;
    if (success) {
      _showSnackBar('Profil berhasil disimpan');
      Navigator.pop(context);
    } else if (controller.errorMessage != null) {
      _showSnackBar(controller.errorMessage!, isError: true);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.error : AppColors.accent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ProfileController>();
    final photoUrl = widget.user?.photoUrl ?? '';

    return Scaffold(
      backgroundColor: AppColors.accent,
      appBar: AppBar(
        backgroundColor: AppColors.accent,
        elevation: 0,
        centerTitle: true,
        title: const Text('Edit Profil',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 30),
              GestureDetector(
                onTap: controller.isUploadingPhoto ? null : () => _showImageSourceDialog(controller),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: AppColors.accent.withValues(alpha: 0.15),
                      backgroundImage: _imageFile != null
                          ? FileImage(_imageFile!) as ImageProvider
                          : (photoUrl.isNotEmpty
                              ? NetworkImage(
                                  ApiConfig.resolveImageUrl(photoUrl),
                                  headers: const {'localtonet-skip-warning': 'true'},
                                )
                              : null),
                      child: _imageFile == null && photoUrl.isEmpty
                          ? const Icon(Icons.person, size: 60, color: AppColors.accent)
                          : null,
                    ),
                    if (controller.isUploadingPhoto)
                      const CircularProgressIndicator(color: AppColors.accent),
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
              const SizedBox(height: 30),
              _buildReadOnly('NIM', widget.user?.nim ?? '-'),
              _buildReadOnly('Email', widget.user?.email ?? '-'),
              const SizedBox(height: 8),
              _buildTextField('Nama Lengkap', _namaController),
              _buildTextField('No HP', _noHpController, type: TextInputType.phone),
              GestureDetector(
                onTap: _selectTanggalLahir,
                child: AbsorbPointer(
                  child: _buildTextField('Tanggal Lahir', _tanggalLahirController),
                ),
              ),
              _buildTextField('Alamat', _alamatController, maxLines: 2),
              const Divider(height: 32),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: AppColors.accent, size: 18),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Isi Kelas, Angkatan, dan Prodi agar data kamu terhubung dengan dosen.',
                        style: TextStyle(fontSize: 12, color: AppColors.accent),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              _buildTextField('Kelas', _kelasController, hint: 'contoh: Mobile Computing A1'),
              _buildTextField('Angkatan', _angkatanController,
                  type: TextInputType.number, hint: 'contoh: 2024'),
              _buildTextField('Program Studi', _prodiController, hint: 'contoh: Sistem Informasi'),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: controller.isSaving ? null : () => _simpan(controller),
                  child: controller.isSaving
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Simpan Perubahan', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
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
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          filled: true,
          fillColor: Colors.grey.shade100,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType type = TextInputType.text,
    int maxLines = 1,
    String? hint,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        keyboardType: type,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          enabledBorder: const UnderlineInputBorder(),
          focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.accent)),
        ),
      ),
    );
  }
}
