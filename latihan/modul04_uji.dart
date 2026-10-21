import '../lib/model/barang.dart';
import '../lib/model/gudang.dart';
import '../lib/model/pelanggan.dart';
import '../lib/model/pengiriman.dart';

/// Modul 04 - Pengujian Rancangan Kelas
/// Program ini menguji seluruh kelas model: Barang, Gudang, Pengiriman, Pelanggan.
void main() {
  print('=' * 60);
  print('  MODUL 04 - PENGUJIAN RANCANGAN KELAS OOP');
  print('=' * 60);

  // ============================================================
  // 1. Pengujian Kelas Barang
  // ============================================================
  print('\n--- 1. PENGUJIAN KELAS BARANG ---');

  // Konstruktor utama
  var sepatu = Barang(
    kode: 'B-1024',
    nama: 'Sepatu Olahraga',
    satuan: 'pasang',
    hargaSatuan: 350000,
  );
  print('Objek Barang (konstruktor utama): $sepatu');
  print('Nilai total 5 pasang: Rp${sepatu.hitungTotal(5).toStringAsFixed(0)}');

  // Konstruktor bernama dariScan
  var barangScan = Barang.dariScan(kode: 'B-2048');
  print('Objek Barang (konstruktor dariScan): $barangScan');
  print('Nilai total 10 unit: Rp${barangScan.hitungTotal(10).toStringAsFixed(0)}');

  // Barang dengan parameter default
  var barangDefault = Barang(kode: 'B-3072', nama: 'Kardus Kosong');
  print('Objek Barang (parameter default): $barangDefault');

  // ============================================================
  // 2. Pengujian Kelas Gudang
  // ============================================================
  print('\n--- 2. PENGUJIAN KELAS GUDANG ---');

  var gudangUtama = Gudang(
    kode: 'G-001',
    nama: 'Gudang Utama',
    kota: 'Bandung',
    kapasitas: 100,
    stokAwal: 20,
  );
  print('Objek Gudang: $gudangUtama');
  print('Sisa kapasitas: ${gudangUtama.sisaKapasitas}');
  print('Apakah penuh? ${gudangUtama.isFull}');

  // Menerima barang (berhasil)
  print('\nTerima 50 unit:');
  gudangUtama.terimaBarang(50);
  print('Stok sekarang: ${gudangUtama.stok}');

  // Menerima barang (gagal - melebihi kapasitas)
  print('\nTerima 50 unit lagi (melebihi kapasitas):');
  gudangUtama.terimaBarang(50);

  // Mengeluarkan barang (berhasil)
  print('\nKeluarkan 30 unit:');
  gudangUtama.keluarkanBarang(30);
  print('Stok sekarang: ${gudangUtama.stok}');

  // Mengeluarkan barang (gagal - stok tidak cukup)
  print('\nKeluarkan 100 unit (stok tidak cukup):');
  gudangUtama.keluarkanBarang(100);

  // Menerima barang dengan jumlah negatif (gagal)
  print('\nTerima -5 unit (jumlah tidak valid):');
  gudangUtama.terimaBarang(-5);

  print('\nKondisi akhir gudang: $gudangUtama');

  // ============================================================
  // 3. Pengujian Kelas Pelanggan (Tugas Praktikum No. 1)
  // ============================================================
  print('\n--- 3. PENGUJIAN KELAS PELANGGAN ---');

  var pelanggan1 = Pelanggan(
    kode: 'P-001',
    nama: 'Budi Santoso',
    telepon: '081234567890',
    alamat: 'Jl. Merdeka No. 10, Bandung',
  );
  print('Objek Pelanggan: $pelanggan1');
  print('Alamat ringkas: ${pelanggan1.alamatRingkas()}');

  var pelanggan2 = Pelanggan(
    kode: 'P-002',
    nama: 'Siti Aminah',
    telepon: '089876543210',
    alamat: 'Jl. Jenderal Sudirman No. 125 RT 05 RW 12, Kelurahan Cikutra, Kecamatan Cibeunying Kidul, Kota Bandung',
  );
  print('Objek Pelanggan: $pelanggan2');
  print('Alamat ringkas: ${pelanggan2.alamatRingkas()}');
  print('Panjang alamat asli: ${pelanggan2.alamat.length} karakter');
  print('Panjang alamat ringkas: ${pelanggan2.alamatRingkas().length} karakter');

  // ============================================================
  // 4. Pengujian Kelas Pengiriman (termasuk Tugas Praktikum No. 2)
  // ============================================================
  print('\n--- 4. PENGUJIAN KELAS PENGIRIMAN ---');

  // Konstruktor utama (dengan pelanggan)
  var kirim1 = Pengiriman(
    resi: 'RSI-20261019-001',
    kotaTujuan: 'Jakarta',
    jumlah: 5,
    tanggal: DateTime(2026, 10, 19),
    pelanggan: pelanggan1,
  );
  print('Objek Pengiriman: $kirim1');
  print('Status awal: ${kirim1.status}');

  // Majukan status secara berurutan
  print('\nMajukan status secara berurutan:');
  kirim1.majukanStatus(); // Menunggu → Diproses
  kirim1.majukanStatus(); // Diproses → Dikirim
  kirim1.majukanStatus(); // Dikirim → Dalam Perjalanan
  kirim1.majukanStatus(); // Dalam Perjalanan → Terkirim
  print('Status akhir: ${kirim1.status}');

  // Coba majukan status setelah Terkirim (gagal)
  print('\nCoba majukan status setelah Terkirim:');
  kirim1.majukanStatus();

  // Konstruktor bernama sudahDiproses
  print('\nPengiriman dengan konstruktor bernama (sudahDiproses):');
  var kirim2 = Pengiriman.sudahDiproses(
    resi: 'RSI-20261019-002',
    kotaTujuan: 'Surabaya',
    jumlah: 10,
    tanggal: DateTime(2026, 10, 19),
    pelanggan: pelanggan2,
  );
  print('Objek Pengiriman: $kirim2');
  print('Status awal: ${kirim2.status}');

  // Ubah status langsung (melompat, tapi tetap maju)
  print('\nUbah status langsung ke "Dalam Perjalanan":');
  kirim2.ubahStatus('Dalam Perjalanan');

  // Coba ubah status mundur (gagal)
  print('\nCoba ubah status mundur ke "Diproses":');
  kirim2.ubahStatus('Diproses');

  // Coba ubah ke status tidak valid
  print('\nCoba ubah ke status tidak valid "Hilang":');
  kirim2.ubahStatus('Hilang');

  print('\nKondisi akhir pengiriman: $kirim2');

  // ============================================================
  // 5. Demonstrasi Enkapsulasi
  // ============================================================
  print('\n--- 5. DEMONSTRASI ENKAPSULASI ---');
  print('Atribut _stok pada Gudang bersifat privat (diawali underscore).');
  print('Jika mencoba mengubah gudangUtama._stok = -10 dari luar file ini,');
  print('compiler Dart akan menampilkan error:');
  print('  "The setter \'_stok\' isn\'t defined for the class \'Gudang\'."');
  print('Hal ini membuktikan enkapsulasi: data internal dilindungi,');
  print('perubahan stok hanya melalui terimaBarang() dan keluarkanBarang().');

 
  print('\n${'=' * 60}');
  print('  PENGUJIAN SELESAI');
  print('=' * 60);
}
