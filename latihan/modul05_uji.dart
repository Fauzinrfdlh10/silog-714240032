
import '../lib/layanan/layanan_pengiriman.dart';
import '../lib/layanan/moda.dart';

void main() {
  final List<LayananPengiriman> daftarLayanan = [
    PengirimanTruk(
      kodeLayanan: 'TRK-REG', jarakKm: 780, beratKg: 1200),
    PengirimanTruk(
      kodeLayanan: 'TRK-EXP', jarakKm: 780, beratKg: 1200, ekspres: true),
    PengirimanKeretaApi(
      kodeLayanan: 'KA-CARGO',
      jarakKm: 780,
      beratKg: 1200,
      stasiunAsal: 'Kiaracondong',
      stasiunTujuan: 'Pasar Turi',
    ),
    PengirimanKapal(
      kodeLayanan: 'KPL-PETI',
      jarakKm: 1450,
      beratKg: 1200,
      volumeM3: 8.5,
    ),
    PengirimanUdara(
      kodeLayanan: 'UDR-CARGO',
      jarakKm: 1200,
      beratKg: 1200,
      panjangCm: 250,
      lebarCm: 200,
      tinggiCm: 180,
    ),
  ];

  print('=== Perbandingan Layanan Pengiriman ===');

  for (final layanan in daftarLayanan) {
    print(layanan.ringkasan());
  }

  daftarLayanan.sort((a, b) => a.hitungTarif().compareTo(b.hitungTarif()));

  print('\nLayanan termurah : ${daftarLayanan.first.kodeLayanan}');
  print('Layanan tercepat : '
      '${daftarLayanan.reduce((a, b) => a.estimasiHari() <= b.estimasiHari() ? a :
      b).kodeLayanan}');

  // Pemanfaatan mixin Terlacak
  final truk = daftarLayanan
      .whereType<PengirimanTruk>()
      .first;

  truk.catatPosisi('Gudang Utama Bandung');
  truk.catatPosisi('Rest Area KM 207');
  truk.catatPosisi('Gudang Transit Semarang');

  print('\nRiwayat posisi ${truk.kodeLayanan}:');

  for (final r in truk.riwayat) {
    print(' $r');
  }

  print('Posisi terakhir: ${truk.posisiTerakhir()}');

  // ==========================================
  // F. Tugas Praktikum: Pengujian Mixin Terasuransi
  // ==========================================
  print('\n=== Pengujian Mixin Terasuransi ===');
  const nilaiBarang = 50000000.0;

  final kapal = daftarLayanan.whereType<PengirimanKapal>().first;
  final udara = daftarLayanan.whereType<PengirimanUdara>().first;

  print('Kapal (${kapal.kodeLayanan}) nilai barang Rp${nilaiBarang.toStringAsFixed(0)}:');
  print('  Premi Asuransi: Rp${kapal.hitungPremi(nilaiBarang).toStringAsFixed(0)} (tarif ${(kapal.persentasePremi * 100).toStringAsFixed(1)}%)');

  print('Udara (${udara.kodeLayanan}) nilai barang Rp${nilaiBarang.toStringAsFixed(0)}:');
  print('  Premi Asuransi: Rp${udara.hitungPremi(nilaiBarang).toStringAsFixed(0)} (tarif ${(udara.persentasePremi * 100).toStringAsFixed(1)}%)');

  // Menunjukkan bahwa PengirimanTruk TIDAK memiliki metode/fitur Terasuransi
  if (truk is Terasuransi) {
    print('Truk memiliki fitur Terasuransi');
  } else {
    print('\nPembuktian Truk tidak memiliki Terasuransi:');
    print('  - Pemeriksaan tipe (truk is Terasuransi): false');
    print('  - Memanggil `truk.hitungPremi(...)` akan ditolak oleh compiler:');
    print('    "The method \'hitungPremi\' isn\'t defined for the type \'PengirimanTruk\'"');
  }
}
