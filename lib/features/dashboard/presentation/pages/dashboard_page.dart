import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistem_akademik/core/constants/api_config.dart';
import 'package:sistem_akademik/core/constants/app_colors.dart';
import 'package:sistem_akademik/features/absensi/presentation/pages/absensi_page.dart';
import 'package:sistem_akademik/features/informasi/domain/informasi.dart';
import 'package:sistem_akademik/features/informasi/presentation/controllers/informasi_controller.dart';
import 'package:sistem_akademik/features/informasi/presentation/pages/informasi_detail_page.dart';
import 'package:sistem_akademik/features/informasi/presentation/pages/informasi_page.dart';
import 'package:sistem_akademik/features/jadwal/domain/jadwal_kuliah.dart';
import 'package:sistem_akademik/features/jadwal/presentation/controllers/jadwal_controller.dart';
import 'package:sistem_akademik/features/jadwal/presentation/pages/jadwal_kuliah_page.dart';
import 'package:sistem_akademik/features/kegiatan/presentation/pages/kegiatan_page.dart';
import 'package:sistem_akademik/features/khs/presentation/pages/khs_page.dart';
import 'package:sistem_akademik/features/krs/presentation/pages/krs_page.dart';
import 'package:sistem_akademik/features/notifikasi/presentation/pages/notifikasi_page.dart';
import 'package:sistem_akademik/features/profile/presentation/controllers/profile_controller.dart';
import 'package:sistem_akademik/features/profile/presentation/pages/profil_page.dart';
import 'package:sistem_akademik/features/tagihan/presentation/pages/tagihan_page.dart';

const List<String> _urutanHari = [
  'Senin',
  'Selasa',
  'Rabu',
  'Kamis',
  'Jumat',
  'Sabtu',
  'Minggu',
];

String _hariIniIndonesia() => _urutanHari[DateTime.now().weekday - 1];

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfileController()),
        ChangeNotifierProvider(create: (_) => JadwalController()),
        ChangeNotifierProvider(create: (_) => InformasiController()),
      ],
      child: const _DashboardView(),
    );
  }
}

class _DashboardView extends StatefulWidget {
  const _DashboardView();

  @override
  State<_DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<_DashboardView> {
  int _currentIndex = 0;

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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => _refreshAll(context),
          child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: const BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Builder(
                      builder: (context) {
                        final user = profileController.user;
                        final nama = user?.nama ?? 'Mahasiswa';
                        final nim = user?.nim ?? '-';
                        final photoUrl = user?.photoUrl ?? '';
                        debugPrint('DEBUG USER PHOTO: name=$nama, photoUrl=$photoUrl, resolved=${ApiConfig.resolveImageUrl(photoUrl)}');
                        return Row(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: Colors.white.withValues(alpha: 0.3),
                              backgroundImage: photoUrl.isNotEmpty
                                  ? NetworkImage(
                                      ApiConfig.resolveImageUrl(photoUrl),
                                      headers: const {'localtonet-skip-warning': 'true'},
                                    )
                                  : null,
                              child: photoUrl.isEmpty
                                  ? const Icon(Icons.person, size: 28, color: Colors.white)
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(nama,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                                Text(nim, style: const TextStyle(color: Colors.white70, fontSize: 14)),
                              ],
                            ),
                            const Spacer(),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const NotifikasiPage()),
                                );
                              },
                              child: const Icon(Icons.notifications_none, color: Colors.white, size: 28),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset(
                        'assets/images/universitas.jpg',
                        width: double.infinity,
                        height: 140,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Universitas Ular",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const Text(
                      "Jl. Ular, Nomer 13 Bengkulu",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Aktivitas", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          borderRadius: BorderRadius.circular(50),
                          splashColor: AppColors.accent.withValues(alpha: 0.2),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const JadwalKuliahPage()),
                            );
                          },
                          child: _menuButton(icon: Icons.schedule, label: "Jadwal"),
                        ),
                        InkWell(
                          borderRadius: BorderRadius.circular(50),
                          splashColor: AppColors.accent.withValues(alpha: 0.2),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const KrsPage()),
                            );
                          },
                          child: _menuButton(icon: Icons.insert_chart_outlined, label: "KRS"),
                        ),
                        InkWell(
                          borderRadius: BorderRadius.circular(50),
                          splashColor: AppColors.accent.withValues(alpha: 0.2),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const KhsPage()),
                            );
                          },
                          child: _menuButton(icon: Icons.assignment, label: "KHS"),
                        ),
                        InkWell(
                          borderRadius: BorderRadius.circular(50),
                          splashColor: AppColors.accent.withValues(alpha: 0.2),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const TagihanPage()),
                            );
                          },
                          child: _menuButton(icon: Icons.payment, label: "Tagihan"),
                        ),
                        InkWell(
                          borderRadius: BorderRadius.circular(50),
                          splashColor: AppColors.accent.withValues(alpha: 0.2),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const KegiatanPage()),
                            );
                          },
                          child: _menuButton(icon: Icons.event_note, label: "Kegiatan"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  splashColor: AppColors.accent.withValues(alpha: 0.2),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const JadwalKuliahPage()),
                    );
                  },
                  child: const Row(
                    children: [
                      Expanded(
                        child: Text("Jadwal kuliah hari ini",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                      Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildJadwalHariIni(jadwalController),
              ),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  splashColor: AppColors.accent.withValues(alpha: 0.2),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const InformasiPage()),
                    );
                  },
                  child: const Row(
                    children: [
                      Expanded(
                        child: Text("Informasi untuk kamu",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                      Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildInformasiTerbaru(context, informasiController),
              ),
              const SizedBox(height: 25),
            ],
          ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: AppColors.accent,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ProfilePage()),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const AbsensiPage()),
            );
          }
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
        ],
      ),
    );
  }

  Widget _menuButton({required IconData icon, required String label}) {
    return Column(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: AppColors.accent.withValues(alpha: 0.15),
          child: Icon(icon, color: AppColors.accent),
        ),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildJadwalHariIni(JadwalController controller) {
    if (controller.isLoading && controller.jadwalList.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: CircularProgressIndicator(color: AppColors.accent),
        ),
      );
    }

    final hariIni = _hariIniIndonesia();
    final jadwalHariIni = controller.jadwalList.where((j) => j.hari == hariIni).toList()
      ..sort((a, b) => a.jamMulai.compareTo(b.jamMulai));

    if (jadwalHariIni.isEmpty) {
      return _emptyCard('Tidak ada jadwal kuliah hari ini');
    }

    return Column(
      children: jadwalHariIni.map(_jadwalCard).toList(),
    );
  }

  Widget _jadwalCard(JadwalKuliah jadwal) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.15),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(jadwal.mataKuliah,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: AppColors.accent),
                    const SizedBox(width: 4),
                    Text(jadwal.ruangan, style: const TextStyle(fontSize: 13)),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              Text(jadwal.jamMulai, style: const TextStyle(fontSize: 13)),
              const Icon(Icons.arrow_downward, color: AppColors.success, size: 16),
              Text(jadwal.jamSelesai, style: const TextStyle(fontSize: 13)),
            ],
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
          child: CircularProgressIndicator(color: AppColors.accent),
        ),
      );
    }

    if (controller.informasiList.isEmpty) {
      return _emptyCard('Belum ada informasi');
    }

    final terbaru = [...controller.informasiList]..sort((a, b) => b.tanggal.compareTo(a.tanggal));
    final Informasi info = terbaru.first;

    return InkWell(
      borderRadius: BorderRadius.circular(15),
      splashColor: AppColors.accent.withValues(alpha: 0.2),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => InformasiDetailPage(informasi: info)),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          children: [
            info.gambarUrl.isNotEmpty
                ? Image.network(
                    ApiConfig.resolveImageUrl(info.gambarUrl),
                    headers: const {'localtonet-skip-warning': 'true'},
                    height: 150,
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
      height: 150,
      width: double.infinity,
      color: AppColors.background,
      child: const Icon(Icons.image_outlined, size: 40, color: AppColors.textSecondary),
    );
  }

  Widget _emptyCard(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F6F6),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.grey),
      ),
    );
  }
}
