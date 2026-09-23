class Kiriman {
  final String resi;
  final String kota;
  final double berat;

  Kiriman({
    required this.resi,
    required this.kota,
    required this.berat,
  });
}

double hitungTotalBerat(List<Kiriman> kiriman) {
  double total = 0;

  for (final item in kiriman) {
    total += item.berat;
  }

  return total;
}

double hitungRataRataBerat(List<Kiriman> kiriman) {
  if (kiriman.isEmpty) {
    return 0;
  }

  return hitungTotalBerat(kiriman) / kiriman.length;
}

Kiriman cariTerberat(List<Kiriman> kiriman) {
  return kiriman.reduce(
    (a, b) => a.berat > b.berat ? a : b,
  );
}

Kiriman cariTeringan(List<Kiriman> kiriman) {
  return kiriman.reduce(
    (a, b) => a.berat < b.berat ? a : b,
  );
}

String tentukanKategori(double berat) {
  if (berat <= 5) {
    return 'Paket Kecil';
  } else if (berat <= 20) {
    return 'Paket Sedang';
  } else {
    return 'Kargo';
  }
}

Map<String, int> hitungJumlahKategori(
  List<Kiriman> kiriman,
) {
  final jumlah = {
    'Paket Kecil': 0,
    'Paket Sedang': 0,
    'Kargo': 0,
  };

  for (final item in kiriman) {
    final kategori = tentukanKategori(item.berat);
    jumlah[kategori] = jumlah[kategori]! + 1;
  }

  return jumlah;
}

void tampilkanData(List<Kiriman> kiriman) {
  print('=== DATA KIRIMAN ===');

  for (final item in kiriman) {
    print(
      '${item.resi} | '
      '${item.kota} | '
      '${item.berat.toStringAsFixed(1)} kg | '
      '${tentukanKategori(item.berat)}',
    );
  }
}

void main() {
  final kiriman = [
    Kiriman(
      resi: 'SLG-001',
      kota: 'Bandung',
      berat: 3.0,
    ),
    Kiriman(
      resi: 'SLG-002',
      kota: 'Surabaya',
      berat: 12.5,
    ),
    Kiriman(
      resi: 'SLG-003',
      kota: 'Makassar',
      berat: 7.2,
    ),
    Kiriman(
      resi: 'SLG-004',
      kota: 'Surabaya',
      berat: 4.8,
    ),
    Kiriman(
      resi: 'SLG-005',
      kota: 'Jayapura',
      berat: 18.0,
    ),
    Kiriman(
      resi: 'SLG-006',
      kota: 'Bandung',
      berat: 6.5,
    ),
    Kiriman(
      resi: 'SLG-007',
      kota: 'Makassar',
      berat: 10.0,
    ),
    Kiriman(
      resi: 'SLG-008',
      kota: 'Jayapura',
      berat: 25.0,
    ),
  ];

  final totalBerat = hitungTotalBerat(kiriman);
  final rataRata = hitungRataRataBerat(kiriman);
  final terberat = cariTerberat(kiriman);
  final teringan = cariTeringan(kiriman);
  final jumlahKategori = hitungJumlahKategori(kiriman);

  tampilkanData(kiriman);

  print('\n=== HASIL PERHITUNGAN ===');
  print(
    'Total berat : '
    '${totalBerat.toStringAsFixed(2)} kg',
  );

  print(
    'Rata-rata berat : '
    '${rataRata.toStringAsFixed(2)} kg',
  );

  print(
    'Kiriman terberat : '
    '${terberat.resi} - '
    '${terberat.berat.toStringAsFixed(2)} kg',
  );

  print(
    'Kiriman teringan : '
    '${teringan.resi} - '
    '${teringan.berat.toStringAsFixed(2)} kg',
  );

  print('\n=== JUMLAH KATEGORI ===');
  print(
    'Paket Kecil : '
    '${jumlahKategori['Paket Kecil']} kiriman',
  );

  print(
    'Paket Sedang : '
    '${jumlahKategori['Paket Sedang']} kiriman',
  );

  print(
    'Kargo : '
    '${jumlahKategori['Kargo']} kiriman',
  );
}