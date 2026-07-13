import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistem_akademik/core/constants/app_colors.dart';
import 'package:sistem_akademik/features/krs/domain/krs.dart';
import 'package:sistem_akademik/features/krs/domain/mata_kuliah_krs.dart';
import 'package:sistem_akademik/features/krs/presentation/controllers/krs_controller.dart';
import 'package:sistem_akademik/features/krs/presentation/pages/pilih_mata_kuliah_page.dart';

class KrsPage extends StatelessWidget {
  const KrsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => KrsController(),
      child: const _KrsView(),
    );
  }
}

class _KrsView extends StatelessWidget {
  const _KrsView();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<KrsController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.accent,
        centerTitle: true,
        title: const Text(
          'KRS',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Builder(
        builder: (context) {
          if (controller.isLoading && controller.krs == null) {
            return const Center(child: CircularProgressIndicator(color: AppColors.accent));
          }

          if (controller.errorMessage != null && controller.krs == null) {
            return Center(child: Text('Terjadi kesalahan: ${controller.errorMessage}'));
          }

          final krs = controller.krs;

          if (krs == null || krs.mataKuliah.isEmpty) {
            return RefreshIndicator(
              onRefresh: controller.refresh,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.menu_book, size: 56, color: Colors.grey),
                          const SizedBox(height: 12),
                          const Text(
                            'Belum ada KRS',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Ajukan KRS untuk memilih mata kuliah pada semester ini',
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent),
                            onPressed: () => _bukaPilihMataKuliah(context, controller),
                            icon: const Icon(Icons.add, color: Colors.white),
                            label: const Text('Ajukan KRS', style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: controller.refresh,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _statusBanner(krs.status, krs.catatanDosen),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildInfoRow(Icons.menu_book, 'Detail kartu rencana studi',
                          '${krs.mataKuliah.length} MK'),
                      const Divider(),
                      _buildInfoRow(Icons.layers, 'Jumlah SKS', '${krs.totalSks} SKS'),
                      const Divider(),
                      _buildInfoRow(Icons.date_range, 'Tahun Ajaran', krs.tahunAkademik),
                      const Divider(),
                      _buildInfoRow(Icons.timelapse, 'Semester', krs.semester),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Daftar mata kuliah yang diambil',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 10),
                Column(
                  children: krs.mataKuliah.map((mk) {
                    return InkWell(
                      onTap: () => _showDetailBottomSheet(context, mk),
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withValues(alpha: 0.1),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: AppColors.accent.withValues(alpha: 0.1),
                              child: const Icon(Icons.verified, color: AppColors.accent),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(mk.nama,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                  const SizedBox(height: 3),
                                  Text(mk.kode,
                                      style: const TextStyle(fontSize: 13, color: Colors.grey)),
                                ],
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                if (!krs.sudahDisetujui) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(foregroundColor: AppColors.accent),
                      onPressed: () => _bukaPilihMataKuliah(context, controller, krs: krs),
                      icon: const Icon(Icons.edit),
                      label: const Text('Ubah KRS'),
                    ),
                  ),
                ],
              ],
            ),
            ),
          );
        },
      ),
    );
  }

  Widget _statusBanner(String status, String? catatanDosen) {
    late final Color color;
    late final IconData icon;
    late final String label;

    switch (status) {
      case 'disetujui':
        color = Colors.green;
        icon = Icons.check_circle;
        label = 'KRS disetujui dosen wali';
        break;
      case 'ditolak':
        color = Colors.red;
        icon = Icons.cancel;
        label = 'KRS ditolak dosen wali';
        break;
      default:
        color = Colors.orange;
        icon = Icons.hourglass_top;
        label = 'Menunggu persetujuan dosen wali';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
            ],
          ),
          if (catatanDosen != null && catatanDosen.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text('Catatan: $catatanDosen', style: const TextStyle(fontSize: 13, color: Colors.black87)),
          ],
        ],
      ),
    );
  }

  Future<void> _bukaPilihMataKuliah(BuildContext context, KrsController controller, {Krs? krs}) async {
    final hasil = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => PilihMataKuliahPage(
          existingKrsId: krs?.id,
          tahunAkademikAwal: krs?.tahunAkademik ?? '',
          semesterAwal: krs?.semester ?? '',
          preselectedIds: krs == null
              ? const []
              : krs.mataKuliah
                  .where((mk) => mk.kelasKuliahId != null)
                  .map<int>((mk) => mk.kelasKuliahId as int)
                  .toList(),
        ),
      ),
    );

    if (hasil == true) {
      controller.refresh();
    }
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.accent),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontSize: 14)),
          ],
        ),
        Text(value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black)),
      ],
    );
  }

  void _showDetailBottomSheet(BuildContext context, MataKuliahKrs mk) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.drag_handle, color: Colors.grey),
              const SizedBox(height: 10),
              Text(mk.nama, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text(mk.kode, style: const TextStyle(color: Colors.grey, fontSize: 13)),
              const SizedBox(height: 20),
              _buildDetailItem(Icons.school, 'SKS', mk.sks),
              _buildDetailItem(Icons.people, 'Kelas', mk.kelas),
              _buildDetailItem(Icons.calendar_today, 'Hari', mk.hari),
              _buildDetailItem(Icons.access_time, 'Pukul', mk.pukul),
              _buildDetailItem(Icons.location_on, 'Ruang', mk.ruang),
              _buildDetailItem(Icons.check_circle, 'Status', mk.status, valueColor: Colors.teal),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailItem(IconData icon, String title, String value, {Color valueColor = Colors.black}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: AppColors.accent),
          const SizedBox(width: 10),
          Expanded(
            child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          ),
          Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: valueColor)),
        ],
      ),
    );
  }
}
