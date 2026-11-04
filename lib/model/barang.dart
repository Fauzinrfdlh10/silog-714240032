class Barang {
  final String kode;
  final String nama;
  final String satuan;
  final double hargaSatuan;
  final double beratKg;

  /// Konstruktor utama menggunakan parameter bernama (named parameters).
  /// [kode] dan [nama] wajib diisi, sedangkan nilai lainnya memiliki default.
  Barang({
    required this.kode,
    required this.nama,
    this.satuan = 'pcs',
    this.hargaSatuan = 0,
    this.beratKg = 0,
  });

  Barang.dariScan({required this.kode})
    : nama = 'Belum diketahui',
      satuan = 'pcs',
      hargaSatuan = 0,
      beratKg = 0;

  /// Menghitung nilai total untuk sejumlah [jumlah] unit barang.
  double hitungTotal(int jumlah) {
    return hargaSatuan * jumlah;
  }

  @override
  String toString() {
    return 'Barang(kode: $kode, nama: $nama, satuan: $satuan, '
        'harga: Rp${hargaSatuan.toStringAsFixed(0)})';
  }
}
