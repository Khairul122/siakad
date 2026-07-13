import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dosen/core/constants/app_colors.dart';
import 'package:dosen/features/krs_approval/domain/pengajuan_krs.dart';
import 'package:dosen/features/krs_approval/presentation/controllers/krs_approval_controller.dart';
import 'package:dosen/features/krs_approval/presentation/pages/krs_approval_detail_page.dart';

class KrsApprovalListPage extends StatelessWidget {
  const KrsApprovalListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => KrsApprovalController(),
      child: const _KrsApprovalListView(),
    );
  }
}

class _KrsApprovalListView extends StatelessWidget {
  const _KrsApprovalListView();

  Color _statusColor(String status) {
    switch (status) {
      case 'disetujui':
        return AppColors.success;
      case 'ditolak':
        return AppColors.error;
      default:
        return AppColors.warning;
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'disetujui':
        return 'Disetujui';
      case 'ditolak':
        return 'Ditolak';
      default:
        return 'Diajukan';
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<KrsApprovalController>();

    return Scaffold(
      backgroundColor: AppColors.surfaceTint,
      body: SafeArea(
        child: Column(
          children: [
            Container(
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
                    'Persetujuan KRS',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  const SizedBox(width: 24),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Builder(builder: (context) {
                if (controller.isLoading && controller.pengajuanList.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.errorMessage != null && controller.pengajuanList.isEmpty) {
                  return Center(child: Text('Terjadi kesalahan: ${controller.errorMessage}'));
                }

                if (controller.pengajuanList.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: controller.refresh,
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: const [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 80),
                          child: Center(
                            child: Text(
                              'Belum ada pengajuan KRS dari mahasiswa bimbingan',
                              style: TextStyle(color: AppColors.textSecondary),
                              textAlign: TextAlign.center,
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
                    itemCount: controller.pengajuanList.length,
                    itemBuilder: (context, index) {
                      final pengajuan = controller.pengajuanList[index];
                      return _card(context, pengajuan);
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _card(BuildContext context, PengajuanKrs pengajuan) {
    return GestureDetector(
      onTap: () async {
        final controller = context.read<KrsApprovalController>();
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => KrsApprovalDetailPage(pengajuan: pengajuan, controller: controller)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6, offset: const Offset(0, 3))],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(pengajuan.mahasiswaNama, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(pengajuan.mahasiswaNim, style: const TextStyle(color: AppColors.textSecondary)),
                  const SizedBox(height: 4),
                  Text(
                    '${pengajuan.tahunAkademik} • Semester ${pengajuan.semester} • ${pengajuan.totalSks} SKS',
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: _statusColor(pengajuan.status).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _statusLabel(pengajuan.status),
                style: TextStyle(color: _statusColor(pengajuan.status), fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
