import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistem_akademik/core/constants/app_colors.dart';
import 'package:sistem_akademik/features/krs/domain/kelas_kuliah.dart';
import 'package:sistem_akademik/features/krs/presentation/controllers/pilih_mata_kuliah_controller.dart';

class PilihMataKuliahPage extends StatelessWidget {
  final String? existingKrsId;
  final String tahunAkademikAwal;
  final String semesterAwal;
  final List<int> preselectedIds;

  const PilihMataKuliahPage({
    super.key,
    this.existingKrsId,
    this.tahunAkademikAwal = '',
    this.semesterAwal = '',
    this.preselectedIds = const [],
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final controller = PilihMataKuliahController(
          existingKrsId: existingKrsId,
          preselectedIds: preselectedIds,
        );
        if (tahunAkademikAwal.isNotEmpty && semesterAwal.isNotEmpty) {
          controller.cariKelas(tahunAkademikAwal, semesterAwal);
        }
        return controller;
      },
      child: _PilihMataKuliahView(
        tahunAkademikAwal: tahunAkademikAwal,
        semesterAwal: semesterAwal,
      ),
    );
  }
}

class _PilihMataKuliahView extends StatefulWidget {
  final String tahunAkademikAwal;
  final String semesterAwal;

  const _PilihMataKuliahView({required this.tahunAkademikAwal, required this.semesterAwal});

  @override
  State<_PilihMataKuliahView> createState() => _PilihMataKuliahViewState();
}

class _PilihMataKuliahViewState extends State<_PilihMataKuliahView> {
  late final TextEditingController _tahunController =
      TextEditingController(text: widget.tahunAkademikAwal);
  late final TextEditingController _semesterController =
      TextEditingController(text: widget.semesterAwal);

  @override
  void dispose() {
    _tahunController.dispose();
    _semesterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<PilihMataKuliahController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.accent,
        centerTitle: true,
        title: const Text('Ajukan KRS', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _tahunController,
                    onChanged: (val) {
                      context.read<PilihMataKuliahController>().updatePeriode(
                            val.trim(),
                            _semesterController.text.trim(),
                          );
                    },
                    decoration: const InputDecoration(
                      labelText: 'Tahun Akademik',
                      hintText: '2025/2026',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _semesterController,
                    onChanged: (val) {
                      context.read<PilihMataKuliahController>().updatePeriode(
                            _tahunController.text.trim(),
                            val.trim(),
                          );
                    },
                    decoration: const InputDecoration(
                      labelText: 'Semester',
                      hintText: '1',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent),
                  onPressed: () {
                    context.read<PilihMataKuliahController>().cariKelas(
                          _tahunController.text.trim(),
                          _semesterController.text.trim(),
                        );
                  },
                  child: const Text('Cari', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: controller.melebihiKuota ? Colors.red.shade50 : Colors.green.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: controller.melebihiKuota ? Colors.red.shade200 : Colors.green.shade200,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total SKS dipilih: ${controller.totalSksTerpilih} / ${controller.maxSks}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: controller.melebihiKuota ? Colors.red.shade700 : Colors.green.shade700,
                  ),
                ),
                if (controller.ips != null)
                  Text('IPS terakhir: ${controller.ips!.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 12, color: Colors.black54)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Builder(builder: (context) {
              if (controller.isLoading && controller.kelasList.isEmpty) {
                return const Center(child: CircularProgressIndicator(color: AppColors.accent));
              }

              if (controller.errorMessage != null && controller.kelasList.isEmpty) {
                return Center(child: Text('Terjadi kesalahan: ${controller.errorMessage}'));
              }

              if (controller.kelasList.isEmpty) {
                final bool inputBelumLengkap = _tahunController.text.trim().isEmpty ||
                    _semesterController.text.trim().isEmpty;

                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          inputBelumLengkap ? Icons.search_outlined : Icons.event_busy,
                          size: 48,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          inputBelumLengkap
                              ? 'Isi Tahun Akademik & Semester'
                              : 'Tidak ada kelas ditawarkan',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          inputBelumLengkap
                              ? 'Silakan isi Tahun Akademik dan Semester di atas lalu tekan "Cari" untuk menampilkan penawaran mata kuliah.'
                              : 'Belum ada mata kuliah yang ditawarkan untuk periode ini.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: controller.kelasList.length,
                itemBuilder: (context, index) {
                  final kelas = controller.kelasList[index];
                  final selected = controller.selectedIds.contains(kelas.id);
                  final penuh = kelas.kuota > 0 && kelas.terisi >= kelas.kuota;

                  return _kelasCard(context, kelas, selected, penuh);
                },
              );
            }),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: (controller.selectedIds.isEmpty ||
                          controller.melebihiKuota ||
                          controller.isSubmitting)
                      ? null
                      : () async {
                          final krs = await controller.submit(
                            inputTahunAkademik: _tahunController.text.trim(),
                            inputSemester: _semesterController.text.trim(),
                          );
                          if (!context.mounted) return;
                          if (krs != null) {
                            Navigator.pop(context, true);
                          } else if (controller.submitError != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(controller.submitError!)),
                            );
                          }
                        },
                  child: controller.isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text('Ajukan KRS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _kelasCard(BuildContext context, KelasKuliah kelas, bool selected, bool penuh) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: selected ? AppColors.accent : Colors.transparent, width: 2),
        boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.15), blurRadius: 5, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Checkbox(
            value: selected,
            activeColor: AppColors.accent,
            onChanged: penuh ? null : (_) => context.read<PilihMataKuliahController>().toggle(kelas.id),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${kelas.mataKuliahNama} (${kelas.mataKuliahKode})',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text(
                  'Kelas ${kelas.namaKelas} • ${kelas.sks} SKS • ${kelas.hari} ${kelas.jamMulai}-${kelas.jamSelesai}',
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
                if (kelas.dosenNama.isNotEmpty)
                  Text('Dosen: ${kelas.dosenNama}', style: const TextStyle(fontSize: 12, color: Colors.black54)),
                Text(
                  penuh ? 'Kuota penuh (${kelas.terisi}/${kelas.kuota})' : 'Kuota: ${kelas.terisi}/${kelas.kuota}',
                  style: TextStyle(fontSize: 12, color: penuh ? Colors.red : Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
