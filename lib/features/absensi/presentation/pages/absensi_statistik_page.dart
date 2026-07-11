import 'package:flutter/material.dart';
import 'package:sistem_akademik/features/absensi/presentation/widgets/absensi_table.dart';

class AbsensiStatistikPage extends StatelessWidget {
  const AbsensiStatistikPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AbsensiMatkulPage(matkul: 'statistik');
  }
}
