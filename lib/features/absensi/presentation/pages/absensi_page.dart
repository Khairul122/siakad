import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistem_akademik/core/constants/app_colors.dart';
import 'package:sistem_akademik/features/absensi/domain/absensi.dart';
import 'package:sistem_akademik/features/absensi/presentation/controllers/absensi_controller.dart';
import 'package:sistem_akademik/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:sistem_akademik/features/profile/presentation/pages/profil_page.dart';

class AbsensiPage extends StatelessWidget {
  const AbsensiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AbsensiController(),
      child: const _AbsensiView(),
    );
  }
}

class _AbsensiView extends StatefulWidget {
  const _AbsensiView();

  @override
  State<_AbsensiView> createState() => _AbsensiViewState();
}

class _AbsensiViewState extends State<_AbsensiView> {
  int _currentIndex = 1;
  int? _selectedKelasKuliahId;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AbsensiController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: AppColors.accent,
        elevation: 0,
        centerTitle: true,
        title: const Text('Absensi',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const DashboardPage()),
          ),
        ),
      ),
      body: controller.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.accent),
            )
          : controller.errorMessage != null
              ? Center(child: Text(controller.errorMessage!))
              : RefreshIndicator(
                  onRefresh: controller.refresh,
                  child: Builder(
                    builder: (context) {
                      final grouped = controller.groupByKelas(controller.absensiList);

                      return _selectedKelasKuliahId == null
                          ? _buildListView(grouped)
                          : _buildDetailView(grouped, _selectedKelasKuliahId!);
                    },
                  ),
                ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: AppColors.accent,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (_) => const DashboardPage()));
          } else if (index == 2) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (_) => const ProfilePage()));
          }
          setState(() => _currentIndex = index);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),
    );
  }

  ({int hadir, int izin, int sakit, int alpha}) _hitungKehadiran(List<Absensi> detail) {
    var hadir = 0, izin = 0, sakit = 0, alpha = 0;
    for (final d in detail) {
      switch (d.keterangan) {
        case 'Hadir':
          hadir++;
          break;
        case 'Izin':
          izin++;
          break;
        case 'Sakit':
          sakit++;
          break;
        case 'Alpha':
          alpha++;
          break;
      }
    }
    return (hadir: hadir, izin: izin, sakit: sakit, alpha: alpha);
  }

  Widget _buildListView(Map<int, List<Absensi>> grouped) {
    if (grouped.isEmpty) {
      return _buildEmptyState();
    }

    final kelasIds = grouped.keys.toList();

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: kelasIds.length,
      itemBuilder: (context, i) {
        final kelasKuliahId = kelasIds[i];
        final detail = grouped[kelasKuliahId] ?? const <Absensi>[];
        final info = detail.first;
        final rekap = _hitungKehadiran(detail);
        final total = detail.length;
        final persen = total > 0 ? ((rekap.hadir / total) * 100).round() : 0;
        final color = persen >= 75 ? AppColors.success : AppColors.error;

        return GestureDetector(
          onTap: () => setState(() => _selectedKelasKuliahId = kelasKuliahId),
          child: Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.12),
                    blurRadius: 8,
                    offset: const Offset(0, 3))
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(info.label,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 3),
                          if (info.jadwal.isNotEmpty)
                            Text('${info.jadwal}${info.ruangan.isNotEmpty ? ' (${info.ruangan})' : ''}',
                                style: const TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text('$persen%',
                          style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: total > 0 ? persen / 100 : 0,
                    backgroundColor: Colors.grey.shade200,
                    color: color,
                    minHeight: 7,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _chip('Hadir', rekap.hadir, AppColors.success),
                    _chip('Izin', rekap.izin, AppColors.warning),
                    _chip('Sakit', rekap.sakit, AppColors.primaryLight),
                    _chip('Alpha', rekap.alpha, AppColors.error),
                  ],
                ),
                const SizedBox(height: 8),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('Lihat detail',
                        style: TextStyle(
                            color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.w600)),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_forward_ios, size: 12, color: AppColors.accent),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.fact_check_outlined, size: 56, color: Colors.grey),
                    SizedBox(height: 12),
                    Text(
                      'Belum ada data absensi',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Data kehadiran akan muncul di sini setelah dosen mengisi presensi mata kuliah yang kamu ambil',
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailView(Map<int, List<Absensi>> grouped, int kelasKuliahId) {
    final detail = grouped[kelasKuliahId] ?? const <Absensi>[];
    final info = detail.isNotEmpty ? detail.first : null;
    final rekap = _hitungKehadiran(detail);
    final total = detail.length;
    final persen = total > 0 ? ((rekap.hadir / total) * 100).round() : 0;
    final color = persen >= 75 ? AppColors.success : AppColors.error;

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => setState(() => _selectedKelasKuliahId = null),
            child: const Row(
              children: [
                Icon(Icons.arrow_back_ios, size: 16, color: AppColors.accent),
                Text('Semua Kelas', style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: Colors.grey.withValues(alpha: 0.12), blurRadius: 8, offset: const Offset(0, 3))
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(info?.label ?? '-', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                if (info != null && info.jadwal.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text('${info.jadwal}${info.ruangan.isNotEmpty ? ' (${info.ruangan})' : ''}',
                      style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
                const SizedBox(height: 14),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: total > 0 ? persen / 100 : 0,
                    backgroundColor: Colors.grey.shade200,
                    color: color,
                    minHeight: 10,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('$persen% Kehadiran',
                        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14)),
                    Text('$total Pertemuan', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _rekapItem('Hadir', rekap.hadir, AppColors.success),
                    _rekapItem('Izin', rekap.izin, AppColors.warning),
                    _rekapItem('Sakit', rekap.sakit, AppColors.primaryLight),
                    _rekapItem('Alpha', rekap.alpha, AppColors.error),
                  ],
                ),
                if (total > 0 && persen < 75) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.warning_amber_outlined, color: AppColors.error, size: 16),
                        const SizedBox(width: 6),
                        const Expanded(
                          child: Text(
                            'Kehadiran di bawah 75%. Risiko tidak bisa ujian.',
                            style: TextStyle(color: AppColors.error, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text('Detail Per Pertemuan', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          if (detail.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 32),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: const Column(
                children: [
                  Icon(Icons.event_busy, size: 40, color: Colors.grey),
                  SizedBox(height: 10),
                  Text('Belum ada data pertemuan', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54)),
                ],
              ),
            )
          else
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: Colors.grey.withValues(alpha: 0.1), blurRadius: 6, offset: const Offset(0, 2))
                ],
              ),
              child: Column(
                children: detail.asMap().entries.map((entry) {
                  final i = entry.key;
                  final d = entry.value;
                  final ketColor = d.keterangan == 'Hadir'
                      ? AppColors.success
                      : d.keterangan == 'Alpha'
                          ? AppColors.error
                          : AppColors.warning;

                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      border: i < detail.length - 1 ? Border(bottom: BorderSide(color: Colors.grey.shade100)) : null,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Pertemuan ${d.pertemuan}', style: const TextStyle(fontSize: 14)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration:
                              BoxDecoration(color: ketColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
                          child: Text(d.keterangan,
                              style: TextStyle(color: ketColor, fontWeight: FontWeight.w600, fontSize: 13)),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _chip(String label, int value, Color color) {
    return Column(
      children: [
        Text('$value', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }

  Widget _rekapItem(String label, int value, Color color) {
    return Column(
      children: [
        Text('$value', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }
}
