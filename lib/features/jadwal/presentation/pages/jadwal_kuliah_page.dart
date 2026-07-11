import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistem_akademik/core/constants/app_colors.dart';
import 'package:sistem_akademik/features/jadwal/domain/jadwal_kuliah.dart';
import 'package:sistem_akademik/features/jadwal/presentation/controllers/jadwal_controller.dart';

const List<String> _urutanHari = [
  'Senin',
  'Selasa',
  'Rabu',
  'Kamis',
  'Jumat',
  'Sabtu',
  'Minggu',
];

String _hariIniIndonesia() {
  final weekday = DateTime.now().weekday;
  return _urutanHari[weekday - 1];
}

class JadwalKuliahPage extends StatelessWidget {
  const JadwalKuliahPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => JadwalController(),
      child: const _JadwalKuliahView(),
    );
  }
}

class _JadwalKuliahView extends StatelessWidget {
  const _JadwalKuliahView();

  Map<String, List<JadwalKuliah>> _groupByHari(List<JadwalKuliah> jadwal) {
    final Map<String, List<JadwalKuliah>> grouped = {};
    for (final item in jadwal) {
      grouped.putIfAbsent(item.hari, () => []).add(item);
    }
    for (final list in grouped.values) {
      list.sort((a, b) => a.jamMulai.compareTo(b.jamMulai));
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<JadwalController>();
    final hariIni = _hariIniIndonesia();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Jadwal Kuliah'),
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: Builder(
        builder: (context) {
          if (controller.isLoading && controller.jadwalList.isEmpty) {
            return const Center(child: CircularProgressIndicator(color: AppColors.accent));
          }

          if (controller.errorMessage != null && controller.jadwalList.isEmpty) {
            return Center(
              child: Text('Terjadi kesalahan: ${controller.errorMessage}'),
            );
          }

          final jadwal = controller.jadwalList;

          if (jadwal.isEmpty) {
            return RefreshIndicator(
              onRefresh: controller.refresh,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: _buildEmptyState(hariIni),
                ),
              ),
            );
          }

          final grouped = _groupByHari(jadwal);
          final jadwalHariIni = grouped[hariIni] ?? [];
          final hariTerurut = _urutanHari.where(grouped.containsKey).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hariIni,
                      style: const TextStyle(
                          color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    if (jadwalHariIni.isEmpty)
                      const Text(
                        'Tidak ada jadwal hari ini',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      )
                    else
                      Column(
                        children: jadwalHariIni
                            .map((jadwal) => _jadwalCard(jadwal, highlight: true))
                            .toList(),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: controller.refresh,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.calendar_month, color: AppColors.accent, size: 20),
                            SizedBox(width: 6),
                            Text('Jadwal kuliah saya',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ...hariTerurut.map((hari) {
                          final listJadwal = grouped[hari] ?? [];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              Text(hari,
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 6),
                              Column(
                                children: listJadwal.map((jadwal) => _jadwalCard(jadwal)).toList(),
                              ),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(String hariIni) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: AppColors.accent,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                hariIni,
                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Tidak ada jadwal hari ini',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
        ),
        const Expanded(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.event_busy, size: 56, color: Colors.grey),
                  SizedBox(height: 12),
                  Text(
                    'Belum ada jadwal',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Jadwal kuliah kamu akan muncul di sini setelah tersedia',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _jadwalCard(JadwalKuliah jadwal, {bool highlight = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: highlight ? Colors.white.withValues(alpha: 0.9) : const Color(0xFFF6F6F6),
        borderRadius: BorderRadius.circular(12),
        boxShadow: highlight
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                )
              ]
            : [],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(jadwal.jamMulai, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              const Icon(Icons.arrow_downward, size: 14, color: AppColors.accent),
              Text(jadwal.jamSelesai, style: const TextStyle(fontSize: 13)),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(jadwal.mataKuliah,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(height: 3),
                if (jadwal.keterangan.isNotEmpty) ...[
                  Text(jadwal.keterangan, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                  const SizedBox(height: 3),
                ],
                Row(
                  children: [
                    const Icon(Icons.location_on, color: AppColors.accent, size: 16),
                    const SizedBox(width: 4),
                    Text(jadwal.ruangan, style: const TextStyle(fontSize: 13)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
