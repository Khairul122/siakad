import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dosen/core/constants/app_colors.dart';
import 'package:dosen/core/widgets/dosen_bottom_nav.dart';
import 'package:dosen/features/home/presentation/pages/home_page.dart';
import 'package:dosen/features/jadwal/domain/jadwal_mengajar.dart';
import 'package:dosen/features/presensi/presentation/controllers/presensi_controller.dart';
import 'package:dosen/features/presensi/presentation/pages/presensi_detail_page.dart';

class PresensiPage extends StatelessWidget {
  const PresensiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PresensiController(),
      child: const _PresensiView(),
    );
  }
}

class _PresensiView extends StatefulWidget {
  const _PresensiView();

  @override
  State<_PresensiView> createState() => _PresensiViewState();
}

class _PresensiViewState extends State<_PresensiView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PresensiController>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<PresensiController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomePage()),
          ),
        ),
        centerTitle: true,
        title: const Text(
          'Presensi',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.black),
        ),
      ),
      bottomNavigationBar: const DosenBottomNav(currentIndex: 1),
      body: Padding(
        padding: const EdgeInsets.only(left: 18, right: 18, top: 10),
        child: controller.isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: controller.refresh,
                child: _buildBody(controller),
              ),
      ),
    );
  }

  Widget _buildBody(PresensiController controller) {
    final kelasList = controller.kelasList;

    if (kelasList.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 120),
          Center(
            child: Text(
              controller.errorMessage ??
                  'Belum ada jadwal mengajar.\nDaftar kelas akan muncul otomatis setelah jadwal tersedia.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
        ],
      );
    }

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: kelasList.length,
      itemBuilder: (context, index) {
        final kelas = kelasList[index];
        return _kelasCard(context, kelas);
      },
    );
  }

  Widget _kelasCard(BuildContext context, JadwalMengajar kelas) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceTint,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.book, color: Colors.white, size: 26),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  kelas.label,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PresensiDetailPage(kelas: kelas, pertemuan: 'Pertemuan 1'),
              ),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
              decoration: BoxDecoration(
                color: AppColors.surfaceTint,
                border: Border.all(color: AppColors.primaryLight, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Lihat & Input Presensi',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  Icon(Icons.arrow_forward, size: 22),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
