-- siakad.sql
-- Skema database untuk aplikasi Sistem Informasi Akademik
-- Disusun berdasarkan struktur data yang benar-benar dipakai oleh kode Flutter
-- di project `sistem_akademik` (mahasiswa) dan `dosen` (dosen), lihat progres.md
-- masing-masing project untuk detail asal setiap tabel.
-- Dialect: MySQL 8+

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ==========================================
-- 1. AKUN PENGGUNA
-- ==========================================

CREATE TABLE dosen (
    uid VARCHAR(128) PRIMARY KEY,
    nama VARCHAR(255) NOT NULL,
    nip VARCHAR(50) UNIQUE,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL COMMENT 'bcrypt hash, dipakai oleh backend REST API JWT auth',
    photo_url VARCHAR(500) DEFAULT '',
    prodi VARCHAR(255) DEFAULT '',
    fcm_token VARCHAR(255) DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE mahasiswa (
    uid VARCHAR(128) PRIMARY KEY,
    nama VARCHAR(255) NOT NULL,
    nim VARCHAR(50) UNIQUE,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL COMMENT 'bcrypt hash, dipakai oleh backend REST API JWT auth',
    no_hp VARCHAR(50) DEFAULT '',
    tanggal_lahir VARCHAR(50) DEFAULT '',
    alamat TEXT,
    photo_url VARCHAR(500) DEFAULT '',
    kelas VARCHAR(100) DEFAULT '',
    angkatan VARCHAR(20) DEFAULT '',
    prodi VARCHAR(255) DEFAULT '',
    dosen_pembimbing_uid VARCHAR(128) DEFAULT NULL COMMENT 'aplikasi menulis string kosong saat belum ada pembimbing, bukan NULL - lakukan konversi ke NULL saat sinkronisasi agar FK ini valid',
    fcm_token VARCHAR(255) DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (dosen_pembimbing_uid) REFERENCES dosen(uid) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE otp_requests (
    email VARCHAR(255) PRIMARY KEY,
    otp VARCHAR(10) NOT NULL,
    expired_at BIGINT NOT NULL,
    used BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ==========================================
-- 2. JADWAL (mahasiswa/sistem_akademik & dosen/dosen)
-- ==========================================

CREATE TABLE jadwal_kuliah (
    id INT AUTO_INCREMENT PRIMARY KEY,
    uid VARCHAR(128) NOT NULL COMMENT 'uid mahasiswa pemilik jadwal',
    hari VARCHAR(20) NOT NULL,
    mata_kuliah VARCHAR(255) NOT NULL,
    jam_mulai VARCHAR(10) NOT NULL,
    jam_selesai VARCHAR(10) NOT NULL,
    ruangan VARCHAR(100) DEFAULT '',
    keterangan VARCHAR(255) DEFAULT '',
    FOREIGN KEY (uid) REFERENCES mahasiswa(uid) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE jadwal_mengajar (
    id INT AUTO_INCREMENT PRIMARY KEY,
    uid VARCHAR(128) NOT NULL COMMENT 'uid dosen pengajar',
    hari VARCHAR(20) NOT NULL,
    mata_kuliah VARCHAR(255) NOT NULL,
    jam_mulai VARCHAR(10) NOT NULL,
    jam_selesai VARCHAR(10) NOT NULL,
    ruangan VARCHAR(100) DEFAULT '',
    keterangan VARCHAR(255) DEFAULT '',
    FOREIGN KEY (uid) REFERENCES dosen(uid) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ==========================================
-- 3. KRS & KHS (sistem_akademik)
-- ==========================================

CREATE TABLE krs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    uid VARCHAR(128) NOT NULL,
    tahun_akademik VARCHAR(20) NOT NULL,
    semester VARCHAR(20) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (uid) REFERENCES mahasiswa(uid) ON DELETE CASCADE,
    UNIQUE (uid, tahun_akademik, semester)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE krs_mata_kuliah (
    id INT AUTO_INCREMENT PRIMARY KEY,
    krs_id INT NOT NULL,
    nama VARCHAR(255) NOT NULL,
    kode VARCHAR(20) DEFAULT '',
    sks VARCHAR(10) DEFAULT '' COMMENT 'disimpan sebagai teks di aplikasi (mk.sks.toString()), bukan angka murni',
    kelas VARCHAR(50) DEFAULT '',
    hari VARCHAR(20) DEFAULT '',
    pukul VARCHAR(30) DEFAULT '',
    ruang VARCHAR(100) DEFAULT '',
    status VARCHAR(30) DEFAULT '',
    FOREIGN KEY (krs_id) REFERENCES krs(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE khs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    uid VARCHAR(128) NOT NULL,
    tahun_akademik VARCHAR(20) NOT NULL,
    semester VARCHAR(20) NOT NULL,
    kode VARCHAR(20) DEFAULT '',
    mata_kuliah VARCHAR(255) NOT NULL,
    sks INT DEFAULT 0,
    kelas VARCHAR(50) DEFAULT '',
    tugas DECIMAL(5,2) DEFAULT 0,
    uts DECIMAL(5,2) DEFAULT 0,
    uas DECIMAL(5,2) DEFAULT 0,
    FOREIGN KEY (uid) REFERENCES mahasiswa(uid) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ==========================================
-- 4. NILAI & PRESENSI YANG DIINPUT DOSEN (dosen)
-- ==========================================

CREATE TABLE nilai (
    id INT AUTO_INCREMENT PRIMARY KEY,
    kelas VARCHAR(100) NOT NULL COMMENT 'nama kelas/mata kuliah, mis. Mobile Computing A1',
    mahasiswa_uid VARCHAR(128) NOT NULL,
    nim VARCHAR(50) DEFAULT '',
    nama VARCHAR(255) DEFAULT '',
    tugas INT DEFAULT 0,
    uts INT DEFAULT 0,
    uas INT DEFAULT 0,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (mahasiswa_uid) REFERENCES mahasiswa(uid) ON DELETE CASCADE,
    UNIQUE (kelas, mahasiswa_uid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE presensi (
    id INT AUTO_INCREMENT PRIMARY KEY,
    kelas VARCHAR(100) NOT NULL,
    pertemuan VARCHAR(50) NOT NULL COMMENT 'mis. Pertemuan 1',
    mahasiswa_uid VARCHAR(128) NOT NULL,
    nim VARCHAR(50) DEFAULT '',
    nama VARCHAR(255) DEFAULT '',
    keterangan ENUM('Hadir', 'Izin', 'Sakit', 'Alpha') DEFAULT 'Alpha',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (mahasiswa_uid) REFERENCES mahasiswa(uid) ON DELETE CASCADE,
    UNIQUE (kelas, pertemuan, mahasiswa_uid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ==========================================
-- 5. ABSENSI MANDIRI MAHASISWA (sistem_akademik, per mata kuliah)
-- ==========================================

CREATE TABLE absensi (
    id INT AUTO_INCREMENT PRIMARY KEY,
    uid VARCHAR(128) NOT NULL,
    matkul ENUM('algoritma', 'basis_data', 'mobile_computing', 'rekayasa_web', 'sistem_operasi', 'statistik') NOT NULL,
    pertemuan VARCHAR(50) NOT NULL,
    tanggal DATE NOT NULL,
    keterangan VARCHAR(255) DEFAULT '',
    ruangan VARCHAR(100) DEFAULT '',
    dosen VARCHAR(255) DEFAULT '',
    FOREIGN KEY (uid) REFERENCES mahasiswa(uid) ON DELETE CASCADE,
    INDEX idx_absensi_uid_matkul (uid, matkul)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ==========================================
-- 6. TAGIHAN & PEMBAYARAN (sistem_akademik)
-- ==========================================

CREATE TABLE tagihan (
    id INT AUTO_INCREMENT PRIMARY KEY,
    uid VARCHAR(128) NOT NULL,
    jenis VARCHAR(100) NOT NULL,
    nominal DECIMAL(15,2) NOT NULL DEFAULT 0,
    status ENUM('Belum Dibayar', 'Menunggu Konfirmasi', 'Lunas') DEFAULT 'Belum Dibayar',
    jatuh_tempo DATE,
    metode_pembayaran VARCHAR(50) DEFAULT '',
    bank_tujuan VARCHAR(100) DEFAULT '',
    no_rekening VARCHAR(50) DEFAULT '',
    bukti_url VARCHAR(500) DEFAULT '',
    catatan TEXT,
    tanggal_konfirmasi VARCHAR(50) DEFAULT '' COMMENT 'disimpan sebagai teks di aplikasi, bukan Timestamp',
    tanggal_lunas VARCHAR(50) DEFAULT '' COMMENT 'disimpan sebagai teks di aplikasi, bukan Timestamp',
    FOREIGN KEY (uid) REFERENCES mahasiswa(uid) ON DELETE CASCADE,
    INDEX idx_tagihan_uid_status (uid, status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ==========================================
-- 7. KONTEN GLOBAL: INFORMASI & KEGIATAN
-- (dibaca bersama oleh sistem_akademik dan dosen)
-- ==========================================

CREATE TABLE informasi (
    id INT AUTO_INCREMENT PRIMARY KEY,
    judul VARCHAR(255) NOT NULL,
    isi TEXT,
    tanggal DATETIME,
    gambar_url VARCHAR(500) DEFAULT '',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE kegiatan (
    id INT AUTO_INCREMENT PRIMARY KEY,
    judul VARCHAR(255) NOT NULL,
    deskripsi TEXT,
    tanggal DATETIME,
    gambar_url VARCHAR(500) DEFAULT '',
    lokasi VARCHAR(255) DEFAULT '',
    status VARCHAR(50) DEFAULT '',
    pemateri VARCHAR(255) DEFAULT '',
    kuota VARCHAR(20) DEFAULT '' COMMENT 'disimpan sebagai teks di aplikasi, bukan angka murni',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ==========================================
-- 8. NOTIFIKASI (dipisah per tipe user, sistem_akademik & dosen)
-- ==========================================

CREATE TABLE notifikasi (
    id INT AUTO_INCREMENT PRIMARY KEY,
    uid VARCHAR(128) NOT NULL COMMENT 'uid mahasiswa atau dosen penerima',
    tipe_user ENUM('Mahasiswa', 'Dosen') NOT NULL COMMENT 'tidak ada di dokumen Firestore asli - kedua app punya collection notifikasi terpisah dengan skema identik (uid, judul, isi, dibaca, createdAt) tanpa penanda tipe; kolom ini harus diisi oleh proses sync berdasarkan app asal data, bukan dibaca langsung dari field Firestore',
    judul VARCHAR(255) NOT NULL,
    isi TEXT,
    dibaca BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_notifikasi_uid (uid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ==========================================
-- 9. BANTUAN & MASUKAN (dosen)
-- ==========================================

CREATE TABLE masukan (
    id INT AUTO_INCREMENT PRIMARY KEY,
    uid VARCHAR(128) NOT NULL COMMENT 'uid dosen pengirim',
    kategori VARCHAR(255) DEFAULT '',
    pesan TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (uid) REFERENCES dosen(uid) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

SET FOREIGN_KEY_CHECKS = 1;
