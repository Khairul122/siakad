import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dosen/core/constants/api_config.dart';
import 'package:dosen/core/constants/app_colors.dart';
import 'package:dosen/features/bimbingan/domain/mahasiswa_bimbingan.dart';
import 'package:dosen/features/bimbingan/presentation/controllers/bimbingan_controller.dart';
import 'package:dosen/features/bimbingan/presentation/pages/detail_bimbingan_page.dart';

class BimbinganPage extends StatelessWidget {
  const BimbinganPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BimbinganController(),
      child: const _BimbinganView(),
    );
  }
}

class _BimbinganView extends StatelessWidget {
  const _BimbinganView();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<BimbinganController>();

    return Scaffold(
      backgroundColor: AppColors.surfaceTint,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, controller),
            const SizedBox(height: 10),
            Expanded(
              child: Builder(
                builder: (context) {
                  if (controller.isLoading && controller.bimbinganList.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final filteredData = controller.filter(controller.bimbinganList);

                  if (filteredData.isEmpty) {
                    return RefreshIndicator(
                      onRefresh: controller.refresh,
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: const [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 80),
                            child: Center(
                              child: Text(
                                'Belum ada mahasiswa bimbingan',
                                style: TextStyle(color: AppColors.textSecondary),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: controller.refresh,
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(20),
                      itemCount: filteredData.length,
                      itemBuilder: (context, index) {
                        return _buildMahasiswaCard(context, filteredData[index]);
                      },
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

  Widget _buildHeader(BuildContext context, BimbinganController controller) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          const Spacer(),
          const Text(
            "Bimbingan",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          PopupMenuButton<String?>(
            icon: const Icon(Icons.menu, color: Colors.white),
            onSelected: controller.setAngkatan,
            itemBuilder: (context) => const [
              PopupMenuItem(value: "2024", child: Text("Angkatan 2024")),
              PopupMenuItem(value: "2023", child: Text("Angkatan 2023")),
              PopupMenuItem(value: "2022", child: Text("Angkatan 2022")),
              PopupMenuItem(value: "2021", child: Text("Angkatan 2021")),
              PopupMenuItem(value: null, child: Text("Tampilkan Semua")),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMahasiswaCard(BuildContext context, MahasiswaBimbingan mhs) {
    final hasPhoto = mhs.photoUrl.isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundImage: hasPhoto
                    ? NetworkImage(
                        ApiConfig.resolveImageUrl(mhs.photoUrl),
                        headers: const {'localtonet-skip-warning': 'true'},
                      ) as ImageProvider
                    : const AssetImage('assets/pp.jpg'),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mhs.nama,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(mhs.nim),
                  Text(mhs.prodi, style: const TextStyle(color: AppColors.textSecondary)),
                  Text(
                    "Angkatan ${mhs.angkatan}",
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailBimbinganPage(
                    mahasiswa: mhs,
                    telepon: mhs.noHp,
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              decoration: BoxDecoration(
                color: AppColors.surfaceTint,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Text("Lihat Mahasiswa"),
                  Spacer(),
                  Icon(Icons.arrow_forward),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
