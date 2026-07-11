import 'package:flutter/material.dart';
import 'package:sistem_akademik/core/constants/app_colors.dart';

class HelpTransferPage extends StatelessWidget {
  const HelpTransferPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.accent,
      appBar: AppBar(
        backgroundColor: AppColors.accent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Jika Salah Transfer',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Jika Anda melakukan kesalahan saat transfer '
                '(misalnya ke rekening atau nominal yang salah), '
                'segera hubungi bagian keuangan universitas melalui '
                'kontak resmi atau datang langsung ke kantor keuangan.',
                style: TextStyle(fontSize: 15, height: 1.6),
              ),
              SizedBox(height: 16),
              Text(
                'Sertakan bukti transfer dan informasi lengkap seperti '
                'nama, NIM, tanggal, serta nominal pembayaran agar '
                'proses pengecekan bisa dilakukan dengan cepat. '
                'Pihak keuangan akan membantu memverifikasi transaksi '
                'tersebut dan memberikan petunjuk lebih lanjut untuk '
                'proses pengembalian atau koreksi pembayaran.',
                style: TextStyle(fontSize: 15, height: 1.6),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
