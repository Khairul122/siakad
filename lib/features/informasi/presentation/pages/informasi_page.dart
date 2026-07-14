import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistem_akademik/core/constants/api_config.dart';
import 'package:sistem_akademik/core/constants/app_colors.dart';
import 'package:sistem_akademik/features/informasi/domain/informasi.dart';
import 'package:sistem_akademik/features/informasi/presentation/controllers/informasi_controller.dart';
import 'package:sistem_akademik/features/informasi/presentation/pages/informasi_detail_page.dart';

class InformasiPage extends StatelessWidget {
  const InformasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => InformasiController(),
      child: const _InformasiView(),
    );
  }
}

class _InformasiView extends StatelessWidget {
  const _InformasiView();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<InformasiController>();

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
              child: Builder(
                builder: (context) {
                  if (controller.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.errorMessage != null) {
                    return Center(
                      child: Text(controller.errorMessage!),
                    );
                  }

                  final daftarInformasi = controller.informasiList;

                  if (daftarInformasi.isEmpty) {
                    return RefreshIndicator(
                      onRefresh: controller.refresh,
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: const [
                          SizedBox(height: 200),
                          Center(
                            child: Text(
                              'Belum ada informasi',
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: controller.refresh,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: daftarInformasi.map((item) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _InfoCard(informasi: item),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final Informasi informasi;

  const _InfoCard({required this.informasi});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: informasi.gambarUrl.isNotEmpty
                ? Image.network(
                    ApiConfig.resolveImageUrl(informasi.gambarUrl),
                    headers: const {'localtonet-skip-warning': 'true'},
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => _placeholder(),
                  )
                : _placeholder(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Text(
              informasi.judul,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              informasi.ringkasan,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InformasiDetailPage(informasi: informasi),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: const Size(130, 38),
              ),
              icon: const Icon(Icons.arrow_forward, size: 18),
              label: const Text(
                'Selanjutnya',
                style: TextStyle(fontSize: 14, fontFamily: 'Righteous'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      height: 140,
      width: double.infinity,
      color: AppColors.background,
      child: const Icon(Icons.image_outlined, size: 40, color: AppColors.textSecondary),
    );
  }
}
