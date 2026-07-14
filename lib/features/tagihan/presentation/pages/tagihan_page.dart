import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sistem_akademik/core/constants/app_colors.dart';
import 'package:sistem_akademik/features/tagihan/domain/tagihan.dart';
import 'package:sistem_akademik/features/tagihan/domain/tagihan_calculator.dart';
import 'package:sistem_akademik/features/tagihan/presentation/controllers/tagihan_controller.dart';
import 'package:sistem_akademik/features/dashboard/presentation/pages/dashboard_page.dart';

class TagihanPage extends StatelessWidget {
  const TagihanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TagihanController(),
      child: const _TagihanView(),
    );
  }
}

class _TagihanView extends StatelessWidget {
  const _TagihanView();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TagihanController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.accent,
        centerTitle: true,
        title: const Text('Tagihan',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _buildBody(context, controller),
    );
  }

  Widget _buildBody(BuildContext context, TagihanController controller) {
    if (controller.isLoading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.accent));
    }

    if (controller.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(controller.errorMessage!,
              textAlign: TextAlign.center, style: const TextStyle(color: AppColors.error)),
        ),
      );
    }

    final daftarTagihan = controller.daftarTagihan;
    final riwayat = controller.riwayatPembayaran;

    return RefreshIndicator(
      onRefresh: controller.refresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Total Tagihan',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Text(TagihanCalculator.formatRupiah(controller.totalTagihan),
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 25),
          const Text('Daftar tagihan',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 10),
          if (daftarTagihan.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text('Tidak ada tagihan yang belum dibayar.',
                  style: TextStyle(color: AppColors.textSecondary)),
            )
          else
            ...daftarTagihan.map((t) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: GestureDetector(
                    onTap: () {
                      final controller = context.read<TagihanController>();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChangeNotifierProvider.value(
                            value: controller,
                            child: UploadBuktiPage(tagihan: t),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(t.jenis, style: const TextStyle(fontWeight: FontWeight.w600)),
                                const SizedBox(height: 4),
                                Text(t.status,
                                    style: TextStyle(
                                        color: t.status == 'Belum Dibayar'
                                            ? AppColors.error
                                            : AppColors.warning)),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(TagihanCalculator.formatRupiah(t.nominal),
                              style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  ),
                )),
          const SizedBox(height: 25),
          const Text('History Pembayaran',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 10),
          if (riwayat.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text('Belum ada riwayat pembayaran.',
                  style: TextStyle(color: AppColors.textSecondary)),
            )
          else
            ...riwayat.map((t) => _historyItem(
                t.jenis,
                TagihanCalculator.formatRupiah(t.nominal),
                TagihanCalculator.formatTanggalIndo(t.tanggalLunas),
            )),
          ],
        ),
      ),
    );
  }

  Widget _historyItem(String title, String amount, String date) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                const Icon(Icons.check_box, color: AppColors.accent),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
                      Text(amount, style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Text(date, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

class UploadBuktiPage extends StatefulWidget {
  final Tagihan tagihan;

  const UploadBuktiPage({super.key, required this.tagihan});

  @override
  State<UploadBuktiPage> createState() => _UploadBuktiPageState();
}

class _UploadBuktiPageState extends State<UploadBuktiPage> {
  String? _selectedFile;
  File? _imageFile;
  final _picker = ImagePicker();
  final _catatanController = TextEditingController();

  @override
  void dispose() {
    _catatanController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    Navigator.pop(context);
    final picked = await _picker.pickImage(
      source: source,
      maxWidth: 1024,
      imageQuality: 85,
    );
    if (picked != null && mounted) {
      setState(() {
        _imageFile = File(picked.path);
        _selectedFile = picked.name;
      });
    }
  }

  void _selectFile() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: AppColors.accent),
              title: const Text('Ambil Foto'),
              onTap: () => _pickImage(ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: AppColors.accent),
              title: const Text('Pilih dari Galeri'),
              onTap: () => _pickImage(ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.close, color: AppColors.error),
              title: const Text('Batal'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _kirimKonfirmasi() async {
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan unggah bukti pembayaran terlebih dahulu')),
      );
      return;
    }

    final controller = context.read<TagihanController>();
    final berhasil = await controller.kirimKonfirmasi(
      tagihanId: widget.tagihan.id,
      buktiLocalPath: _imageFile!.path,
      catatan: _catatanController.text,
    );

    if (!mounted) return;

    if (berhasil) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => KonfirmasiBerhasilPage(tagihan: widget.tagihan)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(controller.errorMessage ?? 'Gagal mengirim konfirmasi')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TagihanController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.accent,
        centerTitle: true,
        title: const Text('Tagihan',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.tagihan.jenis, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(TagihanCalculator.formatRupiah(widget.tagihan.nominal)),
                  Text(widget.tagihan.metodePembayaran.isNotEmpty
                      ? widget.tagihan.metodePembayaran
                      : 'Transfer Bank'),
                  Text(widget.tagihan.noRekening),
                  Text(widget.tagihan.status),
                ],
              ),
            ),
            const SizedBox(height: 25),
            const Text('Upload Bukti Pembayaran', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: _selectFile,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black54),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _imageFile != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(_imageFile!,
                            height: 150, width: double.infinity, fit: BoxFit.cover),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.add),
                          const SizedBox(width: 8),
                          Text(_selectedFile ?? 'Upload Bukti Pembayaran',
                              style: const TextStyle(fontWeight: FontWeight.w500)),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 6),
            const Text('Format: JPG, PNG, PDF (maks. 2MB)',
                style: TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 25),
            const Text('Catatan', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _catatanController,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              maxLines: 3,
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: controller.isSubmitting ? null : _kirimKonfirmasi,
                child: controller.isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Text('Kirim Konfirmasi Pembayaran',
                        style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class KonfirmasiBerhasilPage extends StatelessWidget {
  final Tagihan tagihan;

  const KonfirmasiBerhasilPage({super.key, required this.tagihan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.accent,
        centerTitle: true,
        title: const Text('Tagihan',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Text('Konfirmasi Berhasil Dikirim',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            const Icon(Icons.check_circle, size: 100, color: AppColors.accent),
            const SizedBox(height: 20),
            const Text(
              'Bukti pembayaran anda telah diterima dan sedang menunggu verifikasi oleh admin.\nAnda akan menerima notifikasi setelah pembayaran dikonfirmasi.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const DashboardPage()),
                  (route) => false,
                );
              },
              child: const Text('Kembali Ke Beranda', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => StatusPembayaranPage(tagihan: tagihan)),
                );
              },
              child: const Text('Lihat Status Pembayaran', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

class StatusPembayaranPage extends StatelessWidget {
  final Tagihan tagihan;

  const StatusPembayaranPage({super.key, required this.tagihan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.accent,
        centerTitle: true,
        title: const Text('Tagihan',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tagihan.jenis, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(TagihanCalculator.formatRupiah(tagihan.nominal)),
                  Text(tagihan.metodePembayaran.isNotEmpty
                      ? tagihan.metodePembayaran
                      : 'Transfer Bank'),
                  Text(tagihan.noRekening),
                ],
              ),
            ),
            const SizedBox(height: 25),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Status Pembayaran', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.radio_button_checked, color: AppColors.accent, size: 18),
                      const SizedBox(width: 6),
                      Text(tagihan.status),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                      tagihan.tanggalKonfirmasi.isNotEmpty
                          ? 'Dikirim pada: ${TagihanCalculator.formatTanggalIndo(tagihan.tanggalKonfirmasi)}'
                          : 'Belum ada pengiriman bukti pembayaran',
                      style: const TextStyle(color: Colors.grey)),
                  if (tagihan.buktiUrl.isNotEmpty)
                    Row(
                      children: const [
                        Icon(Icons.attach_file, color: Colors.grey),
                        SizedBox(width: 6),
                        Text('bukti_pembayaran.jpg', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            const Text('Catatan', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(tagihan.catatan.isNotEmpty ? tagihan.catatan : '-'),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const DashboardPage()),
                    (route) => false,
                  );
                },
                child: const Text('Kembali Ke Beranda', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
