import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dosen/core/constants/app_colors.dart';
import 'package:dosen/features/bantuan/presentation/controllers/bantuan_controller.dart';
import 'package:dosen/features/bantuan/presentation/pages/detail_masukan_page.dart';
import 'package:dosen/features/bantuan/presentation/pages/detail_pertanyaan_page.dart';

class BantuanMasukanPage extends StatelessWidget {
  const BantuanMasukanPage({super.key});

  static String formatParagraph(String text) {
    List<String> words = text.split(" ");
    List<String> paragraphs = [];
    String current = "";
    int count = 0;

    for (var w in words) {
      current += "$w ";
      count++;

      if (count >= 25) {
        paragraphs.add(current.trim());
        current = "";
        count = 0;
      }
    }

    if (current.isNotEmpty) {
      paragraphs.add(current.trim());
    }

    return paragraphs.join("\n\n");
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BantuanController(),
      child: const _BantuanMasukanView(),
    );
  }
}

class _BantuanMasukanView extends StatefulWidget {
  const _BantuanMasukanView();

  @override
  State<_BantuanMasukanView> createState() => _BantuanMasukanViewState();
}

class _BantuanMasukanViewState extends State<_BantuanMasukanView> {
  final _kategoriController = TextEditingController();
  final _pesanController = TextEditingController();

  @override
  void dispose() {
    _kategoriController.dispose();
    _pesanController.dispose();
    super.dispose();
  }

  Future<void> _kirim(BantuanController controller) async {
    final success = await controller.kirimMasukan(
      _kategoriController.text,
      _pesanController.text,
    );
    if (!mounted) return;
    if (success) {
      _kategoriController.clear();
      _pesanController.clear();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const DetailMasukanPage()),
      );
    } else if (controller.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(controller.errorMessage!), backgroundColor: AppColors.error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<BantuanController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 50,
              left: 20,
              right: 20,
              bottom: 30,
            ),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 15),
                Container(
                  width: 28,
                  height: 28,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(Icons.help_outline, color: AppColors.primary),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  "Bantuan & Masukan",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildQuestion(
                    context,
                    "Apa kebijakan kampus terkait keterlambatan masuk kelas atau pengganti perkuliahan?",
                    BantuanMasukanPage.formatParagraph(
                      "Kebijakan kampus umumnya mengatur bahwa keterlambatan masuk kelas baik oleh mahasiswa maupun dosen harus mengikuti aturan disiplin akademik yang telah ditetapkan. Bagi mahasiswa, keterlambatan lebih dari batas waktu yang ditentukan—biasanya antara 10 hingga 15 menit—dapat dianggap sebagai ketidakhadiran dan berdampak pada absensi serta penilaian kehadiran. Kebijakan ini dibuat agar proses pembelajaran berlangsung tertib dan tidak mengganggu konsentrasi kelas. Sementara itu, apabila dosen berhalangan hadir atau tidak dapat melaksanakan perkuliahan sesuai jadwal, kampus mewajibkan adanya kelas pengganti yang harus dijadwalkan berdasarkan kesepakatan antara dosen dan mahasiswa agar materi tetap tersampaikan secara lengkap. Selain itu, jika dosen terlambat melebihi batas waktu yang diperbolehkan, mahasiswa berhak membubarkan kelas dan perkuliahan harus dijadwalkan ulang. Kebijakan ini diterapkan untuk menjaga kualitas pembelajaran, kedisiplinan, dan keadilan bagi seluruh peserta didik dalam lingkungan akademik.",
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buildQuestion(
                    context,
                    "Bagaimana cara mendapatkan dana penelitian atau hibah dari kampus?",
                    BantuanMasukanPage.formatParagraph(
                      "Untuk mendapatkan dana penelitian atau hibah dari kampus, mahasiswa maupun dosen biasanya perlu mengikuti prosedur pengajuan yang telah ditetapkan oleh lembaga penelitian kampus. Proses ini umumnya dimulai dari penyusunan proposal penelitian yang berisi latar belakang, rumusan masalah, tujuan, metodologi, serta anggaran biaya yang dibutuhkan. Proposal tersebut kemudian diajukan ke lembaga penelitian kampus atau bagian kemahasiswaan sesuai jenis hibah yang ingin diperoleh. Setelah itu, proposal akan melalui tahap seleksi atau review oleh tim penilai untuk memastikan kelayakan penelitian. Jika dinyatakan lolos, peneliti akan menerima surat keputusan serta dana yang dapat digunakan untuk menjalankan penelitian sesuai aturan. Selain itu, beberapa kampus juga mengadakan program hibah kompetitif yang mengharuskan peserta mengikuti presentasi proposal atau tahapan wawancara. Pada akhirnya, peneliti wajib membuat laporan kemajuan dan laporan akhir sebagai bentuk pertanggungjawaban penggunaan dana. Kebijakan ini dibuat untuk memastikan bahwa setiap penelitian berjalan secara profesional, transparan, dan memberikan kontribusi nyata bagi perkembangan ilmu pengetahuan di lingkungan kampus.",
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buildQuestion(
                    context,
                    "Apakah dosen boleh melakukan penelitian mandiri di luar kegiatan kampus?",
                    BantuanMasukanPage.formatParagraph(
                      "Boleh, selama penelitian tersebut tidak melanggar aturan kampus dan tidak menggunakan nama universitas tanpa izin. Jika dosen ingin mencantumkan nama universitas dalam publikasi, maka wajib mengajukan izin resmi ke Lembaga Penelitian dan Pengabdian kepada Masyarakat (LPPM). Hal ini penting agar karya penelitian diakui sebagai kontribusi resmi universitas dan dapat dimasukkan ke dalam laporan kinerja dosen (BKD). Selain itu, penelitian mandiri tetap diharapkan selaras dengan bidang keahlian dosen.",
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "Kategori/Perihal Masukan",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  _buildInput(_kategoriController),
                  const SizedBox(height: 18),
                  const Text(
                    "Pesan/Masukan",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  _buildInput(_pesanController, maxLines: 5),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: controller.isSaving ? null : () => _kirim(controller),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35),
                        ),
                      ),
                      child: controller.isSaving
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Text(
                              "Kirim Masukan",
                              style: TextStyle(fontSize: 18, color: Colors.white),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestion(
    BuildContext context,
    String text,
    String detailContent,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                DetailPertanyaanPage(title: text, content: detailContent),
          ),
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 12,
            height: 12,
            margin: const EdgeInsets.only(top: 6),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 15, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInput(TextEditingController controller, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryLight),
        ),
      ),
    );
  }
}
