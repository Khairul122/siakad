import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistem_akademik/core/constants/api_config.dart';
import 'package:sistem_akademik/core/constants/app_colors.dart';
import 'package:sistem_akademik/features/kegiatan/domain/kegiatan.dart';
import 'package:sistem_akademik/features/kegiatan/presentation/controllers/kegiatan_controller.dart';
import 'package:sistem_akademik/features/kegiatan/presentation/controllers/pendaftaran_kegiatan_controller.dart';
import 'package:sistem_akademik/features/profile/presentation/controllers/profile_controller.dart';

const List<IconData> _kegiatanIkon = [
  Icons.laptop_mac,
  Icons.photo_camera_outlined,
  Icons.volunteer_activism,
  Icons.school_outlined,
  Icons.groups_outlined,
];

const List<Color> _kegiatanWarna = [
  AppColors.accent,
  AppColors.success,
  AppColors.warning,
  AppColors.primary,
  AppColors.primaryDark,
];

class KegiatanPage extends StatelessWidget {
  const KegiatanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => KegiatanController(),
      child: const _KegiatanView(),
    );
  }
}

class _KegiatanView extends StatelessWidget {
  const _KegiatanView();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<KegiatanController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.accent,
        centerTitle: true,
        title: const Text(
          'Kegiatan',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Builder(
        builder: (context) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.errorMessage != null) {
            return Center(
              child: Text(controller.errorMessage!),
            );
          }

          final daftarKegiatan = controller.kegiatanList;

          if (daftarKegiatan.isEmpty) {
            return RefreshIndicator(
              onRefresh: controller.refresh,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 200),
                  Center(
                    child: Text(
                      'Belum ada kegiatan',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: controller.refresh,
            child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: daftarKegiatan.length,
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final item = daftarKegiatan[index];
              final ikon = _kegiatanIkon[index % _kegiatanIkon.length];
              final warna = _kegiatanWarna[index % _kegiatanWarna.length];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailKegiatanPage(
                        kegiatan: item,
                        icon: ikon,
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: warna.withValues(alpha: 0.1),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: item.gambarUrl.isNotEmpty
                                ? Image.network(
                                    ApiConfig.resolveImageUrl(item.gambarUrl),
                                    headers: const {'localtonet-skip-warning': 'true'},
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                        Icon(ikon, size: 28, color: warna),
                                  )
                                : Icon(ikon, size: 28, color: warna),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.judul,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                                  const SizedBox(width: 6),
                                  Text(
                                    item.tanggalFormatted,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (item.status.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: item.status == 'Aktif' ? AppColors.success : AppColors.accent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              item.status,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
            ),
          );
        },
      ),
    );
  }
}

class DetailKegiatanPage extends StatefulWidget {
  final Kegiatan kegiatan;
  final IconData icon;

  const DetailKegiatanPage({
    super.key,
    required this.kegiatan,
    required this.icon,
  });

  @override
  State<DetailKegiatanPage> createState() => _DetailKegiatanPageState();
}

class _DetailKegiatanPageState extends State<DetailKegiatanPage> {
  late final PendaftaranKegiatanController _pendaftaranController;

  @override
  void initState() {
    super.initState();
    _pendaftaranController = PendaftaranKegiatanController(kegiatanId: widget.kegiatan.id);
  }

  @override
  void dispose() {
    _pendaftaranController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final kegiatan = widget.kegiatan;
    final icon = widget.icon;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.accent,
        centerTitle: true,
        title: const Text(
          'Detail Kegiatan',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (kegiatan.gambarUrl.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    ApiConfig.resolveImageUrl(kegiatan.gambarUrl),
                    headers: const {'localtonet-skip-warning': 'true'},
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: AppColors.background,
                      alignment: Alignment.center,
                      child: Icon(icon, size: 70, color: AppColors.accent),
                    ),
                  ),
                ),
              )
            else ...[
              Icon(icon, size: 70, color: AppColors.accent),
              const SizedBox(height: 12),
            ],
            Text(
              kegiatan.judul,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.15),
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_month, color: Colors.black54),
                      const SizedBox(width: 8),
                      Text(kegiatan.tanggalFormatted, style: const TextStyle(color: AppColors.textPrimary)),
                    ],
                  ),
                  if (kegiatan.lokasi.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.black54),
                        const SizedBox(width: 8),
                        Text(kegiatan.lokasi, style: const TextStyle(color: AppColors.textPrimary)),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 14),
            if (kegiatan.status.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: kegiatan.status == 'Aktif' ? AppColors.success : AppColors.accent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  kegiatan.status.toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.15),
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Deskripsi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 6),
                  Text(kegiatan.deskripsi, style: const TextStyle(color: Colors.grey)),
                  if (kegiatan.pemateri.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    const Text('Pemateri', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 6),
                    Text(kegiatan.pemateri, style: const TextStyle(color: Colors.grey)),
                  ],
                  if (kegiatan.kuota.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    const Text('Kuota Peserta', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 6),
                    Text(
                      kegiatan.kuotaTotal != null
                          ? '${kegiatan.pendaftaranCount} / ${kegiatan.kuotaTotal} peserta terdaftar'
                          : '${kegiatan.pendaftaranCount} peserta terdaftar',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),
            AnimatedBuilder(
              animation: _pendaftaranController,
              builder: (context, _) {
                final c = _pendaftaranController;

                if (c.isChecking) {
                  return const SizedBox(
                    height: 48,
                    child: Center(child: CircularProgressIndicator(color: AppColors.accent)),
                  );
                }

                if (c.sudahTerdaftar) {
                  return ElevatedButton.icon(
                    onPressed: null,
                    icon: const Icon(Icons.check_circle, color: Colors.white),
                    label: const Text(
                      'Anda Sudah Terdaftar',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      disabledBackgroundColor: AppColors.success,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                }

                if (kegiatan.kuotaPenuh) {
                  return ElevatedButton(
                    onPressed: null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text(
                      'Kuota Penuh',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                    ),
                  );
                }

                return ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FormDaftarPage(
                          kegiatan: kegiatan,
                          icon: icon,
                          controller: _pendaftaranController,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text(
                    'Daftar Sekarang',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class FormDaftarPage extends StatefulWidget {
  final Kegiatan kegiatan;
  final IconData icon;
  final PendaftaranKegiatanController controller;

  const FormDaftarPage({
    super.key,
    required this.kegiatan,
    required this.icon,
    required this.controller,
  });

  @override
  State<FormDaftarPage> createState() => _FormDaftarPageState();
}

class _FormDaftarPageState extends State<FormDaftarPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController namaC = TextEditingController();
  final TextEditingController nimC = TextEditingController();
  final TextEditingController prodiC = TextEditingController();
  final TextEditingController hpC = TextEditingController();

  late final ProfileController _profileController;

  @override
  void initState() {
    super.initState();
    _profileController = ProfileController();
    _profileController.addListener(_prefillFromProfile);
  }

  void _prefillFromProfile() {
    final user = _profileController.user;
    if (user == null || !mounted) return;

    setState(() {
      if (namaC.text.isEmpty) namaC.text = user.nama;
      if (nimC.text.isEmpty) nimC.text = user.nim;
      if (prodiC.text.isEmpty) prodiC.text = user.prodi;
      if (hpC.text.isEmpty) hpC.text = user.noHp;
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final berhasil = await widget.controller.daftar(
      nama: namaC.text.trim(),
      nim: nimC.text.trim(),
      prodi: prodiC.text.trim(),
      noHp: hpC.text.trim(),
    );

    if (!mounted) return;

    if (berhasil) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const KonfirmasiPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.controller.errorMessage ?? 'Gagal mendaftar')),
      );
    }
  }

  @override
  void dispose() {
    _profileController.removeListener(_prefillFromProfile);
    _profileController.dispose();
    namaC.dispose();
    nimC.dispose();
    prodiC.dispose();
    hpC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.accent,
        centerTitle: true,
        title: const Text('Kegiatan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Icon(widget.icon, size: 70, color: AppColors.accent),
              const SizedBox(height: 8),
              Text(widget.kegiatan.judul, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 16),
              const Text('FORM PENDAFTARAN', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 24),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: namaC,
                      decoration: const InputDecoration(labelText: 'Nama'),
                      validator: (v) => v!.isEmpty ? 'Nama tidak boleh kosong' : null,
                    ),
                    TextFormField(
                      controller: nimC,
                      decoration: const InputDecoration(labelText: 'NIM'),
                      validator: (v) => v!.isEmpty ? 'NIM tidak boleh kosong' : null,
                    ),
                    TextFormField(
                      controller: prodiC,
                      decoration: const InputDecoration(labelText: 'Prodi'),
                    ),
                    TextFormField(
                      controller: hpC,
                      decoration: const InputDecoration(labelText: 'Nomor HP'),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 32),
                    AnimatedBuilder(
                      animation: widget.controller,
                      builder: (context, _) {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: widget.controller.isSubmitting ? null : _submit,
                          child: widget.controller.isSubmitting
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                )
                              : const Text('Daftar Sekarang', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class KonfirmasiPage extends StatelessWidget {
  const KonfirmasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.accent,
        centerTitle: true,
        title: const Text('Kegiatan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, color: AppColors.success, size: 100),
              const SizedBox(height: 20),
              const Text(
                'Pendaftaran berhasil!\nAnda telah terdaftar sebagai peserta kegiatan ini.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 15),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const KegiatanPage()),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Kembali Ke Daftar Kegiatan', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
