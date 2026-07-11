import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistem_akademik/core/constants/app_colors.dart';
import 'package:sistem_akademik/features/khs/domain/khs_calculator.dart';
import 'package:sistem_akademik/features/khs/presentation/controllers/khs_controller.dart';

class KhsPage extends StatelessWidget {
  const KhsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => KhsController(),
      child: const _KhsView(),
    );
  }
}

class _KhsView extends StatelessWidget {
  const _KhsView();

  static Color _gradeColor(String grade) {
    switch (grade) {
      case 'A':
        return AppColors.success;
      case 'B':
        return AppColors.accent;
      case 'C':
        return AppColors.warning;
      case 'D':
        return AppColors.warningDark;
      default:
        return AppColors.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<KhsController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.accent,
        centerTitle: true,
        title: const Text('KHS',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _buildBody(context, controller),
    );
  }

  Widget _buildBody(BuildContext context, KhsController controller) {
    if (controller.isLoading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.accent));
    }

    if (controller.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(controller.errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.error)),
        ),
      );
    }

    if (controller.khsList.isEmpty) {
      return RefreshIndicator(
        onRefresh: controller.refresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: 400,
            child: const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text('Belum ada data KHS untuk semester ini.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textSecondary)),
              ),
            ),
          ),
        ),
      );
    }

    final nilaiList = controller.khsList;

    return RefreshIndicator(
      onRefresh: controller.refresh,
      child: SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.15),
                    blurRadius: 5,
                    offset: const Offset(0, 3))
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Detail Kartu Hasil Studi',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                const SizedBox(height: 12),
                _infoRow('Tahun Akademik', controller.tahunAkademik),
                const SizedBox(height: 6),
                _infoRow('Semester', controller.semester),
                const SizedBox(height: 6),
                _infoRow('Jumlah MK', '${nilaiList.length} Mata Kuliah'),
                const SizedBox(height: 6),
                _infoRow('Total SKS', '${controller.totalSks} SKS'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.15),
                    blurRadius: 5,
                    offset: const Offset(0, 3))
              ],
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(AppColors.accent),
                headingTextStyle:
                    const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                dataRowMinHeight: 52,
                dataRowMaxHeight: 52,
                columnSpacing: 16,
                columns: const [
                  DataColumn(label: Text('No')),
                  DataColumn(label: Text('Mata Kuliah')),
                  DataColumn(label: Text('SKS')),
                  DataColumn(label: Text('Tugas')),
                  DataColumn(label: Text('UTS')),
                  DataColumn(label: Text('UAS')),
                  DataColumn(label: Text('Nilai')),
                  DataColumn(label: Text('Grade')),
                ],
                rows: List.generate(nilaiList.length, (index) {
                  final mk = nilaiList[index];
                  final na = KhsCalculator.nilaiAkhir(mk);
                  final grade = KhsCalculator.grade(na);
                  final color = _gradeColor(grade);
                  return DataRow(cells: [
                    DataCell(Text('${index + 1}')),
                    DataCell(SizedBox(
                      width: 140,
                      child: Text(mk.mataKuliah, style: const TextStyle(fontSize: 13)),
                    )),
                    DataCell(Text('${mk.sks}')),
                    DataCell(Text(mk.tugas.toStringAsFixed(0))),
                    DataCell(Text(mk.uts.toStringAsFixed(0))),
                    DataCell(Text(mk.uas.toStringAsFixed(0))),
                    DataCell(Text(na.toStringAsFixed(1))),
                    DataCell(Text(grade,
                        style: TextStyle(
                            color: color, fontWeight: FontWeight.bold, fontSize: 15))),
                  ]);
                }),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total SKS: ${controller.totalSks} SKS',
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                Text('IP Semester: ${controller.ipSemester.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, color: AppColors.accent)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Keterangan Grade',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    _gradeBadge('A', '≥ 85', AppColors.success),
                    _gradeBadge('B', '75-84', AppColors.accent),
                    _gradeBadge('C', '65-74', AppColors.warning),
                    _gradeBadge('D', '55-64', AppColors.warningDark),
                    _gradeBadge('E', '< 55', AppColors.error),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black54)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _gradeBadge(String grade, String range, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text('$grade ($range)',
          style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}
