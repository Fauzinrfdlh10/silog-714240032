String? getCatatan(bool ada) {
  return ada ? "Letakkan di teras" : null;
}

void ujiNullSafety() {
  String pengirim = "Andi";
  
  // Compiler tidak tahu pasti apakah ini null atau tidak
  String? catatanPenerima = getCatatan(false); 

  // Menggunakan ??
  print("Pengirim: $pengirim");
  print("Catatan: ${catatanPenerima ?? 'Tidak ada catatan'}");

  // Menggunakan ?.
  print("Panjang catatan: ${catatanPenerima?.length}");

  // Menggunakan ??=
  catatanPenerima ??= "Tolong titipkan ke satpam";
  print("Catatan (setelah ??=): $catatanPenerima");

  // Menggunakan !
  String? catatanTambahan = getCatatan(true);
  String catatanPasti = catatanTambahan!;
  print("Catatan (dipaksa non-null): $catatanPasti");
}

class ResiTidakDitemukan implements Exception {
  final String resi;
  ResiTidakDitemukan(this.resi);
  @override
  String toString() => 'Resi $resi tidak ditemukan pada basis data.';
}

final Map<String, String> basisResi = {
  'SLG-001': 'Bandung',
  'SLG-002': 'Surabaya',
};

String cariKota(String resi) {
  final kota = basisResi[resi];
  if (kota == null) {
    throw ResiTidakDitemukan(resi);
  }
  return kota;
}

void ujiPenanganan() {
  for (final resi in ['SLG-001', 'SLG-999']) {
    try {
      print('$resi -> ${cariKota(resi)}');
    } on ResiTidakDitemukan catch (e) {
      print('Peringatan: $e');
    } catch (e, s) {
      print('Kesalahan tidak terduga: $e');
      print(s);
    } finally {
      print('Pencarian $resi selesai.');
    }
  }
}

void ujiLateKeyword() {

  late String kurir; 
  
  kurir = "Budi";
  
  print("Kurir yang bertugas: $kurir");
}

void main() {
  print("--- Latihan 1: Null Safety ---");
  ujiNullSafety();
  
  print("\n--- Contoh Penggunaan 'late' ---");
  ujiLateKeyword();
  
  print("\n--- Latihan 2: Penanganan Error ---");
  ujiPenanganan();
}
