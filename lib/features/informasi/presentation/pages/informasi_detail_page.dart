import 'package:flutter/material.dart';
import 'package:sistem_akademik/core/constants/api_config.dart';
import 'package:sistem_akademik/core/constants/app_colors.dart';
import 'package:sistem_akademik/features/informasi/domain/informasi.dart';

class InformasiDetailPage extends StatelessWidget {
  final Informasi informasi;

  const InformasiDetailPage({super.key, required this.informasi});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              width: double.infinity,
              color: AppColors.primary,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  const Text(
                    'Informasi',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'Righteous',
                    ),
                  ),
                  const Spacer(flex: 2),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (informasi.gambarUrl.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          ApiConfig.resolveImageUrl(informasi.gambarUrl),
                          headers: const {'localtonet-skip-warning': 'true'},
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            height: 180,
                            width: double.infinity,
                            color: AppColors.background,
                            child: const Icon(Icons.image_outlined, size: 40, color: AppColors.textSecondary),
                          ),
                        ),
                      ),
                    const SizedBox(height: 12),
                    Text(
                      informasi.judul,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      informasi.isi,
                      style: const TextStyle(fontSize: 14, height: 1.5),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          minimumSize: const Size(130, 40),
                        ),
                        child: const Text(
                          'Kembali',
                          style: TextStyle(fontFamily: 'Righteous'),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
