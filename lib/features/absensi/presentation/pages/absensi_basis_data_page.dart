import 'package:flutter/material.dart';
import 'package:sistem_akademik/features/absensi/presentation/widgets/absensi_table.dart';

class AbsensiBasisDataPage extends StatelessWidget {
  const AbsensiBasisDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AbsensiMatkulPage(matkul: 'basis_data');
  }
}
