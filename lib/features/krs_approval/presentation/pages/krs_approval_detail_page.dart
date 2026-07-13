import 'package:flutter/material.dart';
import 'package:dosen/core/constants/app_colors.dart';
import 'package:dosen/features/krs_approval/domain/pengajuan_krs.dart';
import 'package:dosen/features/krs_approval/presentation/controllers/krs_approval_controller.dart';

class KrsApprovalDetailPage extends StatefulWidget {
  final PengajuanKrs pengajuan;
  final KrsApprovalController controller;

  const KrsApprovalDetailPage({super.key, required this.pengajuan, required this.controller});

  @override
  State<KrsApprovalDetailPage> createState() => _KrsApprovalDetailPageState();
}

class _KrsApprovalDetailPageState extends State<KrsApprovalDetailPage> {
  final _catatanController = TextEditingController();
  late PengajuanKrs _pengajuan = widget.pengajuan;

  @override
  void dispose() {
    _catatanController.dispose();
    super.dispose();
  }

  Future<void> _setujui() async {
    final error = await widget.controller.approve(
      _pengajuan.id,
      catatan: _catatanController.text.trim().isEmpty ? null : _catatanController.text.trim(),
    );
    if (!mounted) return;
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      return;
    }
    setState(() {
      _pengajuan = widget.controller.pengajuanList.firstWhere((p) => p.id == _pengajuan.id, orElse: () => _pengajuan);
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('KRS berhasil disetujui')));
  }

  Future<void> _tolak() async {
    if (_catatanController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Catatan alasan penolakan wajib diisi')));
      return;
    }

    final error = await widget.controller.reject(_pengajuan.id, catatan: _catatanController.text.trim());
    if (!mounted) return;
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      return;
    }
    setState(() {
      _pengajuan = widget.controller.pengajuanList.firstWhere((p) => p.id == _pengajuan.id, orElse: () => _pengajuan);
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('KRS berhasil ditolak')));
  }

  @override
  Widget build(BuildContext context) {
    final sudahDiputuskan = _pengajuan.status != 'diajukan';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text('Detail Pengajuan KRS'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_pengajuan.mahasiswaNama, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                Text(_pengajuan.mahasiswaNim, style: const TextStyle(color: AppColors.textSecondary)),
                const SizedBox(height: 8),
                Text('${_pengajuan.tahunAkademik} • Semester ${_pengajuan.semester}'),
                Text('Total ${_pengajuan.totalSks} SKS', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text('Mata kuliah diambil', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 10),
          ..._pengajuan.mataKuliah.map((mk) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${mk.nama} (${mk.kode})', style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('Kelas ${mk.kelas} • ${mk.sks} SKS • ${mk.hari} ${mk.pukul}',
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    if (mk.ruang.isNotEmpty)
                      Text('Ruang ${mk.ruang}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  ],
                ),
              )),
          const SizedBox(height: 16),
          if (sudahDiputuskan) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: (_pengajuan.status == 'disetujui' ? AppColors.success : AppColors.error).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _pengajuan.status == 'disetujui' ? 'KRS telah disetujui' : 'KRS telah ditolak',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _pengajuan.status == 'disetujui' ? AppColors.success : AppColors.error,
                    ),
                  ),
                  if (_pengajuan.catatanDosen != null && _pengajuan.catatanDosen!.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text('Catatan: ${_pengajuan.catatanDosen}'),
                  ],
                ],
              ),
            ),
          ] else ...[
            TextField(
              controller: _catatanController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Catatan (wajib diisi jika menolak)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(foregroundColor: AppColors.error),
                    onPressed: widget.controller.isProcessing ? null : _tolak,
                    child: const Text('Tolak'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                    onPressed: widget.controller.isProcessing ? null : _setujui,
                    child: const Text('Setujui', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
