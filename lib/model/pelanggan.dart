/// Kelas Pelanggan merepresentasikan entitas pelanggan dalam proses logistik.
/// Atribut: kode, nama, telepon, alamat.
/// Perilaku: menyajikan alamat ringkas (maksimal 40 karakter).
///
/// Tugas Praktikum No. 1: Tambahkan kelas Pelanggan.
class Pelanggan {
  final String kode;
  final String nama;
  final String telepon;
  final String alamat;

  /// Konstruktor utama.
  Pelanggan({
    required this.kode,
    required this.nama,
    required this.telepon,
    required this.alamat,
  });

  /// Mengembalikan alamat maksimal 40 karakter.
  /// Jika alamat lebih panjang dari 40 karakter, dipotong dan diberi '...'.
  String alamatRingkas() {
    if (alamat.length <= 40) {
      return alamat;
    }
    return '${alamat.substring(0, 37)}...';
  }

  @override
  String toString() {
    return 'Pelanggan(kode: $kode, nama: $nama, '
        'telepon: $telepon, alamat: ${alamatRingkas()})';
  }
}
