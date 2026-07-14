import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dosen/core/constants/api_config.dart';
import 'package:dosen/core/constants/app_colors.dart';
import 'package:dosen/core/widgets/dosen_bottom_nav.dart';
import 'package:dosen/features/bimbingan/presentation/pages/bimbingan_page.dart';
import 'package:dosen/features/informasi/domain/informasi.dart';
import 'package:dosen/features/informasi/presentation/controllers/informasi_controller.dart';
import 'package:dosen/features/informasi/presentation/pages/informasi_detail_page.dart';
import 'package:dosen/features/informasi/presentation/pages/informasi_dosen_page.dart';
import 'package:dosen/features/jadwal/domain/jadwal_mengajar.dart';
import 'package:dosen/features/jadwal/presentation/controllers/jadwal_controller.dart';
import 'package:dosen/features/jadwal/presentation/pages/jadwal_mengajar_page.dart';
import 'package:dosen/features/krs_approval/presentation/pages/krs_approval_list_page.dart';
import 'package:dosen/features/nilai/presentation/pages/nilai_page.dart';
import 'package:dosen/features/notifikasi/presentation/pages/notifikasi_page.dart';
import 'package:dosen/features/profile/presentation/controllers/profile_controller.dart';

const List<String> _urutanHari = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];

String _hariIniIndonesia() => _urutanHari[DateTime.now().weekday - 1];

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfileController()),
        ChangeNotifierProvider(create: (_) => JadwalController()),
        ChangeNotifierProvider(create: (_) => InformasiController()),
      ],
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  Future<void> _refreshAll(BuildContext context) async {
    await Future.wait([
      context.read<ProfileController>().refresh(),
      context.read<JadwalController>().refresh(),
      context.read<InformasiController>().refresh(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final profileController = context.watch<ProfileController>();
    final jadwalController = context.watch<JadwalController>();
    final informasiController = context.watch<InformasiController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: const DosenBottomNav(currentIndex: 0),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => _refreshAll(context),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(28),
                      bottomRight: Radius.circular(28),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Builder(
                        builder: (context) {
                          final dosen = profileController.dosen;
                          final nama = dosen?.nama ?? 'Dosen';
                          final nip = dosen?.nip ?? '-';
                          final photoUrl = dosen?.photoUrl ?? '';
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 28,
                                      backgroundColor: Colors.white.withValues(alpha: 0.25),
                                      backgroundImage: photoUrl.isNotEmpty
                                          ? NetworkImage(
                                              ApiConfig.resolveImageUrl(photoUrl),
                                              headers: const {'localtonet-skip-warning': 'true'},
                                            )
                                          : const AssetImage('assets/profil.jpg') as ImageProvider,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            nama,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                          Text(
                                            'NIP/NIDN $nip',
                                            style: const TextStyle(color: Colors.white70, fontSize: 13),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const NotifikasiPage()),
                                ),
                                icon: const Icon(
                                  Icons.notifications_none_rounded,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 14),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.asset(
                          'assets/logo_universitas.jpg',
                          width: double.infinity,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Universitas Ular",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15),
                      ),
                      const Text(
                        "Jl. Ular, nomor 13, Jakarta",
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "Aktivitas",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _MenuItem(
                          icon: Icons.calendar_today,
                          label: "Jadwal\nMengajar",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const JadwalMengajarPage()),
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: _MenuItem(
                          icon: Icons.bar_chart,
                          label: "Nilai",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const NilaiPage()),
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: _MenuItem(
                          icon: Icons.people,
                          label: "Bimbingan",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const BimbinganPage()),
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: _MenuItem(
                          icon: Icons.fact_check,
                          label: "Persetujuan\nKRS",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const KrsApprovalListPage()),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _SectionHeader(
                    title: "Jadwal mengajar hari ini",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const JadwalMengajarPage()),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildJadwalHariIni(jadwalController),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _SectionHeader(
                    title: "Informasi untuk dosen",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const InformasiDosenPage()),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildInformasiTerbaru(context, informasiController),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildJadwalHariIni(JadwalController controller) {
    if (controller.isLoading && controller.jadwalList.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    final hariIni = _hariIniIndonesia();
    final jadwalHariIni = controller.jadwalList.where((j) => j.hari == hariIni).toList()
      ..sort((a, b) => a.jamMulai.compareTo(b.jamMulai));

    if (jadwalHariIni.isEmpty) {
      return _emptyCard('Tidak ada jadwal mengajar hari ini');
    }

    return Column(
      children: jadwalHariIni.map(_jadwalCard).toList(),
    );
  }

  Widget _jadwalCard(JadwalMengajar jadwal) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.schedule, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  jadwal.label,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  '${jadwal.jamMulai} - ${jadwal.jamSelesai}'
                  '${jadwal.ruangan.isNotEmpty ? ' | ${jadwal.ruangan}' : ''}',
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInformasiTerbaru(BuildContext context, InformasiController controller) {
    if (controller.isLoading && controller.informasiList.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    if (controller.informasiList.isEmpty) {
      return _emptyCard('Belum ada informasi');
    }

    final terbaru = [...controller.informasiList]..sort((a, b) => b.tanggal.compareTo(a.tanggal));
    final Informasi info = terbaru.first;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => InformasiDetailPage(informasi: info)),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Stack(
          children: [
            info.gambarUrl.isNotEmpty
                ? Image.network(
                    ApiConfig.resolveImageUrl(info.gambarUrl),
                    headers: const {'localtonet-skip-warning': 'true'},
                    height: 170,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => _imagePlaceholder(),
                  )
                : _imagePlaceholder(),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black.withValues(alpha: 0.6), Colors.transparent],
                  ),
                ),
                child: Text(
                  info.judul,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      height: 170,
      width: double.infinity,
      color: AppColors.surfaceTint,
      child: const Icon(Icons.image_outlined, size: 40, color: AppColors.primary),
    );
  }

  Widget _emptyCard(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.grey),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _SectionHeader({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary),
        ),
        GestureDetector(
          onTap: onTap,
          child: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _MenuItem({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.primary,
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 6),
          Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
