import 'package:flutter/material.dart';
import 'package:sistem_akademik/core/constants/app_colors.dart';

class HelpUploadPage extends StatelessWidget {
  const HelpUploadPage({super.key});

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
          'Cara Mengunggah Bukti Pembayaran',
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
              const Text(
                'Cara Mengunggah Bukti Pembayaran di Aplikasi Universitas',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 12),
              _buildStep(1, 'Buka Aplikasi Kampus', [
                'Jalankan aplikasi universitas di HP kamu.',
                'Login pakai akun mahasiswa (NIM & password).',
              ]),
              _buildStep(2, 'Masuk ke Menu Keuangan', [
                'Di beranda, cari dan pilih menu "Tagihan".',
                'Pilih Tagihan yang Ingin Dikonfirmasi.',
                'Akan muncul daftar tagihan kamu.',
                'Tekan tagihan yang statusnya "Belum Dibayar".',
              ]),
              _buildStep(3, 'Tekan Tombol "Unggah Bukti"', [
                'Biasanya ada tombol bertuliskan "Upload Bukti Pembayaran" atau ikon kamera/file.',
                'Klik tombol itu.',
              ]),
              _buildStep(4, 'Pilih File Bukti Pembayaran', [
                'Pilih dari galeri (foto/screenshot transfer) atau ambil langsung lewat kamera.',
                'Pastikan bukti jelas (terlihat nama, nominal, dan tanggal transfer).',
              ]),
              _buildStep(5, 'Isi Keterangan', [
                'Contoh:',
                '"Pembayaran SPP Semester Ganjil 2025 via BCA Mobile tanggal 8 Oktober 2025."',
              ]),
              _buildStep(6, 'Kirim / Submit', [
                'Setelah semua diisi, tekan "Kirim Konfirmasi Pembayaran".',
                'Tunggu notifikasi kalau bukti pembayaran kamu berhasil diunggah.',
              ]),
              _buildStep(7, 'Cek Status Pembayaran', [
                'Kembali ke menu keuangan dan lihat apakah statusnya berubah jadi masuk ke history pembayaran.',
              ]),
              const SizedBox(height: 30),
              const Center(
                child: Text(
                  'Pastikan foto bukti pembayaran jelas agar proses verifikasi cepat.',
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

  Widget _buildStep(int number, String title, List<String> points) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$number. $title',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15.5,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: points.map((p) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    '• $p',
                    style: const TextStyle(fontSize: 15, height: 1.5),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
