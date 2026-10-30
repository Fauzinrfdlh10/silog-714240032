import 'barang.dart';
import 'gudang.dart';
import 'pelanggan.dart';

class Pengiriman {
  final String resi;
  final String kotaTujuan;
  final int jumlah;
  final DateTime tanggal;
  final Barang? barang;
  final Gudang? asal;
  String _status;
  Pelanggan? pelanggan;

  static const List<String> _urutanStatus = [
    'Menunggu',
    'Diproses',
    'Dikirim',
    'Dalam Perjalanan',
    'Terkirim',
  ];

  Pengiriman({
    required this.resi,
    required this.kotaTujuan,
    required this.jumlah,
    required this.tanggal,
    this.barang,
    this.asal,
    this.pelanggan,
  }) : _status = 'Menunggu';

  Pengiriman.sudahDiproses({
    required this.resi,
    required this.kotaTujuan,
    required this.jumlah,
    required this.tanggal,
    this.barang,
    this.asal,
    this.pelanggan,
  }) : _status = 'Diproses';

  /// Getter untuk membaca status dari luar kelas.
  String get status => _status;

  bool majukanStatus() {
    int indexSekarang = _urutanStatus.indexOf(_status);
    if (indexSekarang == -1 || indexSekarang >= _urutanStatus.length - 1) {
      print('  ✗ Status "$_status" sudah di tahap akhir atau tidak valid.');
      return false;
    }
    String statusLama = _status;
    _status = _urutanStatus[indexSekarang + 1];
    print('  ✓ Status berubah: "$statusLama" → "$_status".');
    return true;
  }

  bool ubahStatus(String statusBaru) {
    int indexSekarang = _urutanStatus.indexOf(_status);
    int indexBaru = _urutanStatus.indexOf(statusBaru);

    if (indexBaru == -1) {
      print('  ✗ Status "$statusBaru" tidak valid.');
      return false;
    }
    if (indexBaru <= indexSekarang) {
      print(
        '  ✗ Tidak dapat mengubah status dari "$_status" ke "$statusBaru" '
        '(harus maju, tidak boleh mundur).',
      );
      return false;
    }

    String statusLama = _status;
    _status = statusBaru;
    print('  ✓ Status berubah: "$statusLama" → "$_status".');
    return true;
  }

  @override
  String toString() {
    String pelangganInfo = pelanggan != null
        ? ', pelanggan: ${pelanggan!.nama}'
        : '';
    String barangInfo = barang != null ? ', barang: ${barang!.nama}' : '';
    return 'Pengiriman(resi: $resi, tujuan: $kotaTujuan, '
        'jumlah: $jumlah, tanggal: ${tanggal.toIso8601String().split('T')[0]}, '
        'status: $_status$pelangganInfo$barangInfo)';
  }
}
