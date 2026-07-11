import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dosen/core/constants/app_colors.dart';
import 'package:dosen/features/jadwal/domain/jadwal_mengajar.dart';
import 'package:dosen/features/jadwal/presentation/controllers/jadwal_controller.dart';

class JadwalMengajarPage extends StatelessWidget {
  const JadwalMengajarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => JadwalController(),
      child: const _JadwalMengajarView(),
    );
  }
}

class _JadwalMengajarView extends StatelessWidget {
  const _JadwalMengajarView();

  static const _hariUrutan = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];

  Map<String, List<JadwalMengajar>> _groupByHari(List<JadwalMengajar> list) {
    final map = <String, List<JadwalMengajar>>{};
    for (final j in list) {
      map.putIfAbsent(j.hari, () => []).add(j);
    }
    for (final entries in map.values) {
      entries.sort((a, b) => a.jamMulai.compareTo(b.jamMulai));
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<JadwalController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  const SizedBox(width: 15),
                  const Text(
                    'Jadwal Mengajar',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Builder(
                builder: (context) {
                  if (controller.isLoading && controller.jadwalList.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final list = controller.jadwalList;
                  if (list.isEmpty) {
                    return RefreshIndicator(
                      onRefresh: controller.refresh,
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: const [
                          Padding(
                            padding: EdgeInsets.all(40),
                            child: Text(
                              'Belum ada jadwal mengajar.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final grouped = _groupByHari(list);
                  final hariList = grouped.keys.toList()
                    ..sort((a, b) {
                      final ia = _hariUrutan.indexOf(a);
                      final ib = _hariUrutan.indexOf(b);
                      return (ia == -1 ? 999 : ia).compareTo(ib == -1 ? 999 : ib);
                    });

                  return RefreshIndicator(
                    onRefresh: controller.refresh,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (final hari in hariList) ...[
                            _hariTitle(hari),
                            for (final j in grouped[hari]!) _jadwalCard(j),
                            const SizedBox(height: 10),
                          ],
                          const SizedBox(height: 10),
                        ],
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

  Widget _hariTitle(String hari) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4),
      child: Text(
        hari,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _jadwalCard(JadwalMengajar jadwal) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade300, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(jadwal.jamMulai, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const Icon(Icons.arrow_downward, size: 16),
              Text(jadwal.jamSelesai, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  jadwal.mataKuliah,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                if (jadwal.keterangan.isNotEmpty)
                  Text(
                    jadwal.keterangan,
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                  ),
                const SizedBox(height: 4),
                if (jadwal.ruangan.isNotEmpty)
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: AppColors.primary),
                      const SizedBox(width: 4),
                      Text(
                        jadwal.ruangan,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                      ),
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
