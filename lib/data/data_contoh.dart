import '../model/barang.dart';
import '../model/gudang.dart';
import '../model/pelanggan.dart';
import '../model/pengiriman.dart';

final List<Pengiriman> dataPengirimanContoh = List.unmodifiable([
  Pengiriman(
    resi: 'SLG-2026-001',
    kotaTujuan: 'Jakarta',
    jumlah: 5,
    tanggal: DateTime(2026, 10, 28),
    barang: Barang(
      kode: 'BRG-001',
      nama: 'Peralatan kantor',
      satuan: 'paket',
      hargaSatuan: 250000,
    ),
    asal: Gudang(
      kode: 'GDG-BDG',
      nama: 'Gudang Bandung',
      kota: 'Bandung',
      kapasitas: 1000,
    ),
    pelanggan: Pelanggan(
      kode: 'PLG-001',
      nama: 'Nadia Putri',
      telepon: '081234567801',
      alamat: 'Jl. Merdeka No. 10, Jakarta',
    ),
  ),
  Pengiriman.sudahDiproses(
    resi: 'SLG-2026-002',
    kotaTujuan: 'Surabaya',
    jumlah: 2,
    tanggal: DateTime(2026, 10, 27),
    barang: Barang(
      kode: 'BRG-002',
      nama: 'Komponen elektronik',
      satuan: 'kotak',
      hargaSatuan: 750000,
    ),
    asal: Gudang(
      kode: 'GDG-JKT',
      nama: 'Gudang Jakarta',
      kota: 'Jakarta',
      kapasitas: 1500,
    ),
    pelanggan: Pelanggan(
      kode: 'PLG-002',
      nama: 'Rizky Maulana',
      telepon: '081234567802',
      alamat: 'Jl. Pahlawan No. 25, Surabaya',
    ),
  )..ubahStatus('Dalam Perjalanan'),
  Pengiriman(
    resi: 'SLG-2026-003',
    kotaTujuan: 'Yogyakarta',
    jumlah: 12,
    tanggal: DateTime(2026, 10, 25),
    barang: Barang(
      kode: 'BRG-003',
      nama: 'Buku dan dokumen',
      satuan: 'buah',
      hargaSatuan: 80000,
    ),
    asal: Gudang(
      kode: 'GDG-SMG',
      nama: 'Gudang Semarang',
      kota: 'Semarang',
      kapasitas: 800,
    ),
    pelanggan: Pelanggan(
      kode: 'PLG-003',
      nama: 'Dewi Anggraini',
      telepon: '081234567803',
      alamat: 'Jl. Kaliurang No. 8, Yogyakarta',
    ),
  )..ubahStatus('Terkirim'),
  Pengiriman.sudahDiproses(
    resi: 'SLG-2026-004',
    kotaTujuan: 'Makassar',
    jumlah: 3,
    tanggal: DateTime(2026, 10, 29),
    barang: Barang(
      kode: 'BRG-004',
      nama: 'Perlengkapan rumah',
      satuan: 'koli',
      hargaSatuan: 420000,
    ),
    asal: Gudang(
      kode: 'GDG-SBY',
      nama: 'Gudang Surabaya',
      kota: 'Surabaya',
      kapasitas: 1200,
    ),
    pelanggan: Pelanggan(
      kode: 'PLG-004',
      nama: 'Fajar Pratama',
      telepon: '081234567804',
      alamat: 'Jl. Jenderal Sudirman No. 4, Makassar',
    ),
  ),
]);
