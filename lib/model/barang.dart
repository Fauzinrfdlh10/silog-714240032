class Barang {
  final String kode;
  final String nama;
  final String satuan;
  final double hargaSatuan;

  /// Konstruktor utama menggunakan parameter bernama (named parameters).
  /// [kode] dan [nama] wajib diisi, [satuan] default 'pcs', [hargaSatuan] default 0.
  Barang({
    required this.kode,
    required this.nama,
    this.satuan = 'pcs',
    this.hargaSatuan = 0,
  });

  Barang.dariScan({required this.kode})
      : nama = 'Belum diketahui',
        satuan = 'pcs',
        hargaSatuan = 0;

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
