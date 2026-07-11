import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistem_akademik/core/constants/app_colors.dart';
import 'package:sistem_akademik/features/absensi/domain/absensi.dart';
import 'package:sistem_akademik/features/absensi/presentation/controllers/absensi_controller.dart';

class AbsensiMatkulPage extends StatelessWidget {
  final String matkul;

  const AbsensiMatkulPage({super.key, required this.matkul});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AbsensiController(matkul: matkul),
      child: _AbsensiMatkulView(matkul: matkul),
    );
  }
}

class _AbsensiMatkulView extends StatelessWidget {
  final String matkul;

  const _AbsensiMatkulView({required this.matkul});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AbsensiController>();
    final info = absensiMatkulById(matkul);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.accent,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Absensi',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
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
                  child: _buildBody(
                    info,
                    controller.sortedByPertemuan(controller.absensiList),
                  ),
                ),
    );
  }

  Widget _buildBody(AbsensiMatkul info, List<Absensi> data) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            info.nama,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(info.dosen,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14)),
                Text(info.jadwal, style: const TextStyle(fontSize: 13)),
                Text('(${info.ruangan})', style: const TextStyle(fontSize: 13)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Daftar Kehadiran',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 10),
          if (data.isEmpty)
            _buildEmptyTable()
          else
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    headingRowColor:
                        WidgetStateProperty.all(AppColors.accent.withValues(alpha: 0.2)),
                    columns: const [
                      DataColumn(label: Text('Pertemuan')),
                      DataColumn(label: Text('Tanggal')),
                      DataColumn(label: Text('Keterangan')),
                    ],
                    rows: data
                        .map(
                          (item) => DataRow(cells: [
                            DataCell(Text(item.pertemuan)),
                            DataCell(Text(item.tanggal)),
                            DataCell(Text(item.keterangan)),
                          ]),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 20),
          const Text(
            'Catatan Tambahan',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Mahasiswa disarankan untuk menjaga kehadiran minimal 75% agar dapat mengikuti ujian akhir semester.',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyTable() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Column(
        children: [
          Icon(Icons.event_busy, size: 40, color: Colors.grey),
          SizedBox(height: 10),
          Text(
            'Belum ada data absensi',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
          ),
          SizedBox(height: 4),
          Text(
            'Data kehadiran untuk mata kuliah ini akan muncul di sini',
            style: TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
