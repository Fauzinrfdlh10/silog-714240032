import 'package:flutter_test/flutter_test.dart';
import 'package:sembast/sembast_memory.dart';
import 'package:silog_app/data/stok_repository.dart';
import 'package:silog_app/model/stok.dart';

void main() {
  test(
    'search matches names case-insensitively within the selected warehouse',
    () async {
      final repository = StokRepository.forTesting(newDatabaseFactoryMemory());
      await repository.simpan(_stok('BRG-001', 'Beras Premium', 'GDG-BDG'));
      await repository.simpan(_stok('BRG-002', 'Minyak Goreng', 'GDG-BDG'));
      await repository.simpan(_stok('BRG-003', 'Beras Organik', 'GDG-JKT'));

      final hasil = await repository.ambilSemua(
        kodeGudang: 'GDG-BDG',
        namaBarang: 'bErAs',
      );

      expect(hasil.map((stok) => stok.namaBarang), ['Beras Premium']);
    },
  );
}

Stok _stok(String kode, String nama, String gudang) => Stok(
  kodeBarang: kode,
  namaBarang: nama,
  kodeGudang: gudang,
  jumlah: 10,
  diperbaruiPada: DateTime.utc(2026, 11, 15),
);
