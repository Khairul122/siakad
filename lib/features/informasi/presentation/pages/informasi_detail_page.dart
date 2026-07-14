import 'package:flutter/material.dart';
import 'package:dosen/core/constants/api_config.dart';
import 'package:dosen/core/constants/app_colors.dart';
import 'package:dosen/features/informasi/domain/informasi.dart';

class InformasiDetailPage extends StatelessWidget {
  final Informasi informasi;

  const InformasiDetailPage({super.key, required this.informasi});

  static const _bulan = [
    '',
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  String _formatTanggal(DateTime date) {
    return '${date.day} ${_bulan[date.month]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Informasi",
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: informasi.gambarUrl.isNotEmpty
                  ? Image.network(
                      ApiConfig.resolveImageUrl(informasi.gambarUrl),
                      headers: const {'localtonet-skip-warning': 'true'},
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _placeholderImage(),
                    )
                  : _placeholderImage(),
            ),
            const SizedBox(height: 14),
            Text(
              informasi.judul,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _formatTanggal(informasi.tanggal),
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              informasi.isi.isNotEmpty ? informasi.isi : "Tidak ada informasi tambahan.",
              style: const TextStyle(
                fontSize: 15,
                height: 1.55,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryLight,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "Kembali",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _placeholderImage() {
    return Container(
      width: double.infinity,
      height: 200,
      color: AppColors.surfaceTint,
      child: const Icon(Icons.image_outlined, size: 48, color: AppColors.primary),
    );
  }
}
