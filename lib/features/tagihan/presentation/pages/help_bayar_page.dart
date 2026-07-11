import 'package:flutter/material.dart';
import 'package:sistem_akademik/core/constants/app_colors.dart';

class HelpBayarPage extends StatelessWidget {
  const HelpBayarPage({super.key});

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
          'Cara Membayar Tagihan',
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Cara Transfer via Mobile Banking (contoh: BCA Mobile)'),
              _buildSteps([
                'Buka aplikasi BCA Mobile → pilih m-BCA.',
                'Masukkan PIN m-BCA kamu.',
                'Pilih menu m-Transfer → BCA Virtual Account.',
                'Masukkan nomor Virtual Account (biasanya kode kampus + NIM kamu).',
                'Akan muncul nama kamu dan jumlah tagihan. Pastikan data sudah benar.',
                'Tekan OK / Kirim, lalu masukkan PIN untuk konfirmasi.',
                'Selesai — simpan bukti transaksi.',
              ]),
              const SizedBox(height: 20),
              _buildSectionTitle('Cara Transfer via ATM'),
              _buildSteps([
                'Masukkan kartu ATM dan PIN.',
                'Pilih menu Transaksi Lainnya → Transfer → Ke Rekening Virtual Account.',
                'Masukkan nomor Virtual Account kampus.',
                'Cek nama dan nominal tagihan.',
                'Tekan Ya / Benar untuk konfirmasi.',
                'Simpan struk pembayaran.',
              ]),
              const SizedBox(height: 20),
              _buildSectionTitle('Cara Bayar Lewat Indomaret / Alfamart'),
              _buildSteps([
                'Datangi kasir dan bilang: "Mau bayar tagihan universitas lewat Virtual Account."',
                'Sebutkan kode VA / nomor tagihan.',
                'Kasir akan kasih tahu jumlah yang harus dibayar.',
                'Bayar sesuai nominal dan simpan struk.',
              ]),
              const SizedBox(height: 30),
              const Center(
                child: Text(
                  'Pastikan selalu simpan bukti pembayaran untuk verifikasi.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.black54,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    );
  }

  Widget _buildSteps(List<String> steps) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(steps.length, (index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Text(
              '${index + 1}. ${steps[index]}',
              style: const TextStyle(fontSize: 15, height: 1.5),
            ),
          );
        }),
      ),
    );
  }
}
