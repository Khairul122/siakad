class Absensi {
  final String id;
  final String uid;
  final String matkul;
  final String pertemuan;
  final String tanggal;
  final String keterangan;
  final String ruangan;
  final String dosen;

  const Absensi({
    required this.id,
    required this.uid,
    required this.matkul,
    required this.pertemuan,
    required this.tanggal,
    required this.keterangan,
    this.ruangan = '',
    this.dosen = '',
  });

  factory Absensi.fromMap(String id, Map<String, dynamic> map) {
    return Absensi(
      id: id,
      uid: map['uid'] ?? '',
      matkul: map['matkul'] ?? '',
      pertemuan: '${map['pertemuan'] ?? ''}',
      tanggal: map['tanggal'] ?? '',
      keterangan: map['keterangan'] ?? '',
      ruangan: map['ruangan'] ?? '',
      dosen: map['dosen'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'matkul': matkul,
      'pertemuan': pertemuan,
      'tanggal': tanggal,
      'keterangan': keterangan,
      'ruangan': ruangan,
      'dosen': dosen,
    };
  }
}

class AbsensiMatkul {
  final String id;
  final String nama;
  final String kelas;
  final String dosen;
  final String jadwal;
  final String ruangan;

  const AbsensiMatkul({
    required this.id,
    required this.nama,
    required this.kelas,
    required this.dosen,
    required this.jadwal,
    required this.ruangan,
  });
}

const List<AbsensiMatkul> kDaftarAbsensiMatkul = [
  AbsensiMatkul(
    id: 'algoritma',
    nama: 'Algoritma & Pemrograman',
    kelas: 'Algoritma & Pemrograman A4',
    dosen: 'Abas Batubara S.T., M.T.',
    jadwal: 'Jumat, 08:30 - 11:00 WIB',
    ruangan: 'FT-06',
  ),
  AbsensiMatkul(
    id: 'basis_data',
    nama: 'Pengantar Basis Data',
    kelas: 'Pengantar Basis Data A2',
    dosen: 'Asaepudin Asahan S.T., M.T.',
    jadwal: 'Kamis, 09:00 - 12:00 WIB',
    ruangan: 'FT-05',
  ),
  AbsensiMatkul(
    id: 'mobile_computing',
    nama: 'Mobile Computing',
    kelas: 'Mobile Computing A1',
    dosen: 'Panjaitan S.T., M.T.',
    jadwal: 'Selasa, 14:20 - 15:40 WIB',
    ruangan: 'FT-04',
  ),
  AbsensiMatkul(
    id: 'rekayasa_web',
    nama: 'Rekayasa Web',
    kelas: 'Rekayasa Web Praktik A3',
    dosen: 'Kim Seokjin S.T., M.T.',
    jadwal: 'Rabu, 09:40 - 12:10 WIB',
    ruangan: 'FT-01',
  ),
  AbsensiMatkul(
    id: 'sistem_operasi',
    nama: 'Sistem Operasi',
    kelas: 'Sistem Operasi A3',
    dosen: 'Sahroni S.T., M.T.',
    jadwal: 'Rabu, 13:50 - 16:10 WIB',
    ruangan: 'FT-03',
  ),
  AbsensiMatkul(
    id: 'statistik',
    nama: 'Statistika & Probabilitas',
    kelas: 'Statistika & Probabilitas A2',
    dosen: 'Dr. Haji Kusuma S.T., M.T.',
    jadwal: 'Senin, 07:00 - 09:10 WIB',
    ruangan: 'K.1 H.21',
  ),
];

AbsensiMatkul absensiMatkulById(String id) {
  return kDaftarAbsensiMatkul.firstWhere(
    (m) => m.id == id,
    orElse: () => AbsensiMatkul(
      id: id,
      nama: id,
      kelas: id,
      dosen: '',
      jadwal: '',
      ruangan: '',
    ),
  );
}
