import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dosen/core/constants/app_colors.dart';
import 'package:dosen/features/jadwal/domain/jadwal_mengajar.dart';
import 'package:dosen/features/presensi/domain/mahasiswa_kelas.dart';
import 'package:dosen/features/presensi/presentation/controllers/presensi_controller.dart';

class PresensiDetailPage extends StatelessWidget {
  final JadwalMengajar kelas;
  final String pertemuan;

  const PresensiDetailPage({super.key, required this.kelas, required this.pertemuan});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PresensiController(),
      child: _PresensiDetailView(kelas: kelas, pertemuan: pertemuan),
    );
  }
}

class _PresensiDetailView extends StatefulWidget {
  final JadwalMengajar kelas;
  final String pertemuan;

  const _PresensiDetailView({required this.kelas, required this.pertemuan});

  @override
  State<_PresensiDetailView> createState() => _PresensiDetailViewState();
}

class _PresensiDetailViewState extends State<_PresensiDetailView> {
  late String _currentPertemuan;

  static const _options = ['Hadir', 'Izin', 'Sakit', 'Alpha'];
  static const _pertemuanList = [
    'Pertemuan 1',
    'Pertemuan 2',
    'Pertemuan 3',
    'Pertemuan 4',
    'Pertemuan 5',
    'Pertemuan 6',
    'Pertemuan 7',
    'Pertemuan 8',
  ];

  @override
  void initState() {
    super.initState();
    _currentPertemuan = widget.pertemuan;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = context.read<PresensiController>();
      controller.loadMahasiswa(widget.kelas.id);
      controller.loadDetail(widget.kelas.id, _currentPertemuan);
    });
  }

  Color _ketColor(String ket) {
    switch (ket) {
      case 'Hadir':
        return AppColors.success;
      case 'Alpha':
        return AppColors.error;
      default:
        return AppColors.warning;
    }
  }

  void _showPertemuanPicker(PresensiController controller) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Text('Pilih Pertemuan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          const Divider(height: 1),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _pertemuanList.length,
              itemBuilder: (_, i) {
                final p = _pertemuanList[i];
                final isSelected = _currentPertemuan == p;
                return ListTile(
                  title: Text(
                    p,
                    style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
                  ),
                  tileColor: isSelected ? AppColors.surfaceTint : null,
                  trailing: isSelected ? const Icon(Icons.check_circle, color: AppColors.primaryLight) : null,
                  onTap: () {
                    setState(() => _currentPertemuan = p);
                    controller.gantiPertemuan(widget.kelas.id, p);
                    Navigator.pop(ctx);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Future<void> _saveAll(PresensiController controller) async {
    final ok = await controller.saveAll(kelasKuliahId: widget.kelas.id, pertemuan: _currentPertemuan);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ok ? 'Presensi $_currentPertemuan berhasil disimpan' : controller.errorMessage ?? 'Gagal simpan',
        ),
        backgroundColor: ok ? Colors.teal : Colors.red,
        duration: ok ? const Duration(seconds: 4) : const Duration(seconds: 6),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<PresensiController>();
    final mahasiswaList = controller.mahasiswaList;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Presensi',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.black),
        ),
      ),
      body: controller.isLoadingMahasiswa
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => controller.loadMahasiswa(widget.kelas.id),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceTint,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.kelas.label,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () => _showPertemuanPicker(controller),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.primaryLight.withValues(alpha: 0.4),
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      const Icon(Icons.calendar_today, size: 14, color: AppColors.primaryLight),
                                      const SizedBox(width: 6),
                                      Text(
                                        _currentPertemuan,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.primaryLight,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryLight.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Ganti',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.primaryLight,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      Icon(Icons.swap_vert, size: 16, color: AppColors.primaryLight),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Text('Daftar Kehadiran', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 15),
                  if (mahasiswaList.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(40),
                        child: Text(
                          'Belum ada mahasiswa di kelas ini.\nMahasiswa akan muncul setelah KRS-nya disetujui untuk kelas ini.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ),
                    )
                  else
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Center(
                                    child: Text('No', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Center(
                                    child: Text('Nama', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Center(
                                    child: Text('Ket.', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ...mahasiswaList.asMap().entries.map((entry) {
                            final i = entry.key;
                            final mhs = entry.value;
                            return _mahasiswaRow(context, controller, i, mhs);
                          }),
                        ],
                      ),
                    ),
                  const SizedBox(height: 20),
                  if (mahasiswaList.isNotEmpty)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryLight,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: controller.isSaving ? null : () => _saveAll(controller),
                        child: controller.isSaving
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text(
                                'Simpan Presensi $_currentPertemuan',
                                style: const TextStyle(color: Colors.white, fontSize: 15),
                              ),
                      ),
                    ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
    );
  }

  Widget _mahasiswaRow(BuildContext context, PresensiController controller, int index, MahasiswaKelas mhs) {
    final ket = controller.keteranganFor(mhs.uid);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          Expanded(flex: 1, child: Center(child: Text('${index + 1}'))),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(mhs.nama, style: const TextStyle(fontSize: 14)),
                Text(mhs.nim, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: DropdownButton<String>(
              value: ket,
              isExpanded: true,
              underline: const SizedBox(),
              style: TextStyle(color: _ketColor(ket), fontWeight: FontWeight.w600, fontSize: 13),
              items: _options
                  .map(
                    (o) => DropdownMenuItem(
                      value: o,
                      child: Text(o, style: TextStyle(color: _ketColor(o))),
                    ),
                  )
                  .toList(),
              onChanged: (val) {
                if (val != null) controller.setKeterangan(mhs.uid, val);
              },
            ),
          ),
        ],
      ),
    );
  }
}
