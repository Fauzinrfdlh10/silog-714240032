class Gudang {
  final String kode;
  final String nama;
  final String kota;
  final int kapasitas;
  int _stok; 
  /// [kapasitas] dan [_stok] diberi nilai awal melalui parameter posisi opsional.
  Gudang({
    required this.kode,
    required this.nama,
    required this.kota,
    required this.kapasitas,
    int stokAwal = 0,
  }) : _stok = stokAwal;

  int get stok => _stok;

  int get sisaKapasitas => kapasitas - _stok;

  bool get isFull => _stok >= kapasitas;

  /// Menerima barang sebanyak [jumlah] unit ke gudang.
  bool terimaBarang(int jumlah) {
    if (jumlah <= 0) {
      print('  ✗ Jumlah terima harus lebih dari 0.');
      return false;
    }
    if (_stok + jumlah > kapasitas) {
      print('  ✗ Gagal terima $jumlah unit: melebihi kapasitas '
          '(stok: $_stok, kapasitas: $kapasitas).');
      return false;
    }
    _stok += jumlah;
    print('  ✓ Berhasil terima $jumlah unit. Stok sekarang: $_stok.');
    return true;
  }

  /// Mengeluarkan barang sebanyak [jumlah] unit dari gudang.
  /// Mengembalikan true jika berhasil, false jika stok tidak cukup.
  bool keluarkanBarang(int jumlah) {
    if (jumlah <= 0) {
      print('  ✗ Jumlah keluar harus lebih dari 0.');
      return false;
    }
    if (jumlah > _stok) {
      print('  ✗ Gagal keluarkan $jumlah unit: stok tidak cukup '
          '(stok: $_stok).');
      return false;
    }
    _stok -= jumlah;
    print('  ✓ Berhasil keluarkan $jumlah unit. Stok sekarang: $_stok.');
    return true;
  }

  @override
  String toString() {
    return 'Gudang(kode: $kode, nama: $nama, kota: $kota, '
        'kapasitas: $kapasitas, stok: $_stok)';
  }
}
