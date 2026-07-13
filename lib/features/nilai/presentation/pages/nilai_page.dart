import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dosen/core/constants/app_colors.dart';
import 'package:dosen/features/jadwal/domain/jadwal_mengajar.dart';
import 'package:dosen/features/nilai/presentation/controllers/nilai_controller.dart';
import 'package:dosen/features/nilai/presentation/pages/detail_nilai_page.dart';

class NilaiPage extends StatelessWidget {
  const NilaiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NilaiController(),
      child: const _NilaiView(),
    );
  }
}

class _NilaiView extends StatefulWidget {
  const _NilaiView();

  @override
  State<_NilaiView> createState() => _NilaiViewState();
}

class _NilaiViewState extends State<_NilaiView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NilaiController>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<NilaiController>();

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
                child: controller.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : RefreshIndicator(
                        onRefresh: controller.refresh,
                        child: _buildBody(controller),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(NilaiController controller) {
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

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 20),
      children: [
        for (final kelas in kelasList) _buildNilaiCard(context, kelas),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: const BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
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
            'Nilai',
            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          const SizedBox(width: 28),
        ],
      ),
    );
  }

  Widget _buildNilaiCard(BuildContext context, JadwalMengajar kelas) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryLight, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.book, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  kelas.label,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => DetailNilaiPage(kelas: kelas)),
              );
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.surfaceTint,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Masukkan Nilai',
                    style: TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  Icon(Icons.arrow_forward, color: Colors.black54),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
