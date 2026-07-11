import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dosen/core/constants/app_colors.dart';
import 'package:dosen/features/nilai/domain/mahasiswa_kelas.dart';
import 'package:dosen/features/nilai/domain/nilai.dart';
import 'package:dosen/features/nilai/presentation/controllers/nilai_controller.dart';

class DetailNilaiPage extends StatelessWidget {
  final String kelas;
  const DetailNilaiPage({super.key, required this.kelas});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NilaiController(),
      child: _DetailNilaiView(kelas: kelas),
    );
  }
}

class _DetailNilaiView extends StatefulWidget {
  final String kelas;
  const _DetailNilaiView({required this.kelas});

  @override
  State<_DetailNilaiView> createState() => _DetailNilaiViewState();
}

class _DetailNilaiViewState extends State<_DetailNilaiView> {
  final Map<String, Map<String, TextEditingController>> _controllers = {};
  bool _controllersInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NilaiController>().loadDetail(widget.kelas);
    });
  }

  void _initControllers(List<Nilai> nilaiList, List<MahasiswaKelas> mahasiswaList) {
    final nilaiByUid = {for (final n in nilaiList) n.uid: n};
    for (final mhs in mahasiswaList) {
      final n = nilaiByUid[mhs.uid];
      _controllers.putIfAbsent(
        mhs.uid,
        () => {
          'tugas': TextEditingController(text: (n?.tugas ?? 0).toString()),
          'uts': TextEditingController(text: (n?.uts ?? 0).toString()),
          'uas': TextEditingController(text: (n?.uas ?? 0).toString()),
        },
      );
    }
  }

  Future<void> _saveAll(NilaiController controller, List<MahasiswaKelas> mahasiswaList) async {
    final input = <String, Map<String, int>>{};
    for (final mhs in mahasiswaList) {
      final ctrl = _controllers[mhs.uid];
      if (ctrl == null) continue;
      input[mhs.uid] = {
        'tugas': int.tryParse(ctrl['tugas']!.text) ?? 0,
        'uts': int.tryParse(ctrl['uts']!.text) ?? 0,
        'uas': int.tryParse(ctrl['uas']!.text) ?? 0,
      };
    }

    final ok = await controller.saveAll(
      kelas: widget.kelas,
      mahasiswaList: mahasiswaList,
      nilaiInput: input,
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(ok ? 'Nilai berhasil disimpan' : controller.errorMessage ?? 'Gagal simpan'),
        backgroundColor: ok ? Colors.teal : Colors.red,
      ),
    );
  }

  @override
  void dispose() {
    for (final map in _controllers.values) {
      for (final ctrl in map.values) {
        ctrl.dispose();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<NilaiController>();
    final mahasiswaList = controller.mahasiswaList;

    if (!_controllersInitialized && !controller.isLoadingDetail && mahasiswaList.isNotEmpty) {
      _initControllers(controller.nilaiList, mahasiswaList);
      _controllersInitialized = true;
    }

    return Scaffold(
      backgroundColor: AppColors.surfaceTint,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                padding: const EdgeInsets.all(20),
                child: controller.isLoadingDetail && mahasiswaList.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : RefreshIndicator(
                        onRefresh: () => controller.refreshDetail(widget.kelas),
                        child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Text(
                                widget.kelas,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Daftar Penilaian',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            if (mahasiswaList.isEmpty)
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 40),
                                child: Center(
                                  child: Text(
                                    controller.errorMessage ?? 'Belum ada mahasiswa di kelas ini.',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(color: AppColors.textSecondary),
                                  ),
                                ),
                              )
                            else
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: AppColors.primaryLight, width: 2),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      decoration: const BoxDecoration(
                                        color: AppColors.primaryLight,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(14),
                                          topRight: Radius.circular(14),
                                        ),
                                      ),
                                      child: const Row(
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: Center(
                                              child: Text(
                                                'Nama',
                                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Center(
                                              child: Text(
                                                'Tugas',
                                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Center(
                                              child: Text(
                                                'UTS',
                                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Center(
                                              child: Text(
                                                'UAS',
                                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    ...mahasiswaList.map((mhs) {
                                      final ctrl = _controllers[mhs.uid];
                                      if (ctrl == null) return const SizedBox();
                                      return Container(
                                        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                                        decoration: BoxDecoration(
                                          border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 3,
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 8),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      mhs.nama,
                                                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                                                    ),
                                                    Text(
                                                      mhs.nim,
                                                      style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            _nilaiInput(ctrl['tugas']!),
                                            _nilaiInput(ctrl['uts']!),
                                            _nilaiInput(ctrl['uas']!),
                                          ],
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            const SizedBox(height: 20),
                            if (mahasiswaList.isNotEmpty)
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryLight,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                onPressed:
                                    controller.isSaving ? null : () => _saveAll(controller, mahasiswaList),
                                child: controller.isSaving
                                    ? const CircularProgressIndicator(color: Colors.white)
                                    : const Text(
                                        'Simpan Nilai',
                                        style: TextStyle(color: Colors.white, fontSize: 16),
                                      ),
                              ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _nilaiInput(TextEditingController ctrl) {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 13),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: const BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
          ),
          const Spacer(),
          const Text(
            'Nilai',
            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          const SizedBox(width: 28),
        ],
      ),
    );
  }
}
