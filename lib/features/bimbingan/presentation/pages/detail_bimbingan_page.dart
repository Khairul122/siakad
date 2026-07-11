import 'package:flutter/material.dart';
import 'package:dosen/core/constants/app_colors.dart';
import 'package:dosen/features/bimbingan/domain/mahasiswa_bimbingan.dart';

class DetailBimbinganPage extends StatelessWidget {
  final MahasiswaBimbingan mahasiswa;
  final String telepon;

  const DetailBimbinganPage({
    super.key,
    required this.mahasiswa,
    this.telepon = '',
  });

  ImageProvider _resolveFoto(String foto) {
    if (foto.startsWith('http')) {
      return NetworkImage(foto);
    }
    return AssetImage(foto.isEmpty ? 'assets/pp.jpg' : foto);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceTint,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                padding: const EdgeInsets.all(20),
                child: ListView(
                  children: [
                    _buildProfile(),
                    const SizedBox(height: 30),
                    _buildInfoBox(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(35),
          bottomRight: Radius.circular(35),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
          ),
          const Spacer(),
          const Text(
            "Bimbingan",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          const SizedBox(width: 28),
        ],
      ),
    );
  }

  Widget _buildProfile() {
    return Column(
      children: [
        CircleAvatar(
          radius: 55,
          backgroundImage: _resolveFoto(mahasiswa.photoUrl),
        ),
        const SizedBox(height: 18),
        Text(
          mahasiswa.nama,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Text(
          mahasiswa.nim,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 15),
        ),
      ],
    );
  }

  Widget _buildInfoBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceTint, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildItem("Email", mahasiswa.email.isEmpty ? "-" : mahasiswa.email),
          const SizedBox(height: 10),
          _buildItem("Program Studi", mahasiswa.prodi),
          _buildItem("Telepon", telepon.isEmpty ? "-" : telepon),
        ],
      ),
    );
  }

  Widget _buildItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 15, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
