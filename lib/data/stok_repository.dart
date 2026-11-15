import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_web/sembast_web.dart';

import '../model/stok.dart';

class StokRepository {
  StokRepository._() : _factoryForTesting = null;

  StokRepository.forTesting(DatabaseFactory factory)
    : _factoryForTesting = factory;

  static final StokRepository instance = StokRepository._();

  final DatabaseFactory? _factoryForTesting;
  Database? _db;
  final _store = intMapStoreFactory.store('stok');

  Future<Database> get _database async {
    if (_db != null) return _db!;

    final factoryForTesting = _factoryForTesting;
    if (factoryForTesting != null) {
      _db = await factoryForTesting.openDatabase('silog_test.db');
    } else if (kIsWeb) {
      _db = await databaseFactoryWeb.openDatabase('silog.db');
    } else {
      final dir = await getApplicationDocumentsDirectory();
      _db = await databaseFactoryIo.openDatabase('${dir.path}/silog.db');
    }

    return _db!;
  }

  Future<int> simpan(Stok stok) async {
    final db = await _database;
    return _store.add(db, stok.toMap());
  }

  Future<List<Stok>> ambilSemua({
    String? kodeGudang,
    String? namaBarang,
  }) async {
    final db = await _database;
    final filters = <Filter>[];
    if (kodeGudang != null) {
      filters.add(Filter.equals('kodeGudang', kodeGudang));
    }
    final namaDicari = namaBarang?.trim();
    if (namaDicari != null && namaDicari.isNotEmpty) {
      filters.add(
        Filter.matchesRegExp(
          'namaBarang',
          RegExp('.*${RegExp.escape(namaDicari)}.*', caseSensitive: false),
        ),
      );
    }
    final finder = Finder(
      filter: filters.isEmpty
          ? null
          : filters.length == 1
          ? filters.single
          : Filter.and(filters),
      sortOrders: [SortOrder('namaBarang')],
    );
    final rekaman = await _store.find(db, finder: finder);
    return rekaman.map((r) => Stok.fromMap(r.key, r.value)).toList();
  }

  Future<Stok?> ambilSatu(int id) async {
    final db = await _database;
    final nilai = await _store.record(id).get(db);
    return nilai == null ? null : Stok.fromMap(id, nilai);
  }

  Future<void> perbarui(Stok stok) async {
    final id = stok.id;
    if (id == null) {
      throw ArgumentError('Data tanpa id tidak dapat diperbarui');
    }

    final db = await _database;
    await _store.record(id).update(db, stok.toMap());
  }

  Future<void> hapus(int id) async {
    final db = await _database;
    await _store.record(id).delete(db);
  }
}
