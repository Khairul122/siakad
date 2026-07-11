import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dosen/core/constants/app_colors.dart';
import 'package:dosen/features/notifikasi/domain/notifikasi.dart';
import 'package:dosen/features/notifikasi/presentation/controllers/notifikasi_controller.dart';

class NotifikasiDetailPage extends StatefulWidget {
  final Notifikasi notifikasi;

  const NotifikasiDetailPage({super.key, required this.notifikasi});

  @override
  State<NotifikasiDetailPage> createState() => _NotifikasiDetailPageState();
}

class _NotifikasiDetailPageState extends State<NotifikasiDetailPage> {
  late final NotifikasiController _controller;

  @override
  void initState() {
    super.initState();
    _controller = NotifikasiController();
    if (!widget.notifikasi.dibaca) {
      _controller.markAsRead(widget.notifikasi.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _controller,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 40, 16, 20),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 20),
                  const Expanded(
                    child: Text(
                      "Notifikasi",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      widget.notifikasi.judul,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.notifikasi.isi.isNotEmpty
                        ? widget.notifikasi.isi
                        : "Detail notifikasi tidak tersedia.",
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
