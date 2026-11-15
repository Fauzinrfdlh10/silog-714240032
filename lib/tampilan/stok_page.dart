import 'package:flutter/material.dart';

import '../data/preferensi.dart';
import '../data/stok_repository.dart';
import '../model/stok.dart';
import 'form_stok_page.dart';

class StokPage extends StatefulWidget {
  const StokPage({super.key});

  @override
  State<StokPage> createState() => _StokPageState();
}

class _StokPageState extends State<StokPage> {
  static const _gudangTersedia = {
    'GDG-BDG': 'Gudang Bandung',
    'GDG-JKT': 'Gudang Jakarta',
    'GDG-SMG': 'Gudang Semarang',
    'GDG-SBY': 'Gudang Surabaya',
  };

  final _repo = StokRepository.instance;
  final _preferensi = Preferensi();
  final _pencarianC = TextEditingController();
  List<Stok> _daftar = [];
  String _gudang = 'GDG-BDG';
  bool _memuat = true;

  @override
  void initState() {
    super.initState();
    _inisialisasi();
  }

  @override
  void dispose() {
    _pencarianC.dispose();
    super.dispose();
  }

  Future<void> _inisialisasi() async {
    final gudangTersimpan = await _preferensi.ambilGudangTerakhir();
    if (!mounted) return;
    if (gudangTersimpan != null &&
        _gudangTersedia.containsKey(gudangTersimpan)) {
      _gudang = gudangTersimpan;
    }
    await _muat();
  }

  Future<void> _muat() async {
    final pencarian = _pencarianC.text.trim();
    final gudang = _gudang;
    final daftar = await _repo.ambilSemua(
      kodeGudang: gudang,
      namaBarang: pencarian,
    );
    if (!mounted || pencarian != _pencarianC.text.trim() || gudang != _gudang) {
      return;
    }
    setState(() {
      _daftar = daftar;
      _memuat = false;
    });
  }

  Future<void> _pilihGudang(String? kodeGudang) async {
    if (kodeGudang == null) return;
    setState(() {
      _gudang = kodeGudang;
      _memuat = true;
    });
    await _preferensi.simpanGudangTerakhir(kodeGudang);
    await _muat();
  }

  Future<void> _tambahStok() async {
    final stok = await Navigator.push<Stok>(
      context,
      MaterialPageRoute(builder: (_) => FormStokPage(kodeGudang: _gudang)),
    );
    if (stok == null) return;
    await _repo.simpan(stok);
    await _muat();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Stok ${stok.namaBarang} berhasil ditambahkan')),
    );
  }

  Future<void> _ubahJumlah(Stok stok, int delta) async {
    final baru = stok.jumlah + delta;
    if (baru < 0) return;
    await _repo.perbarui(stok.salinDengan(jumlah: baru));
    await _muat();
  }

  Future<void> _hapus(Stok stok) async {
    final ya = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus data stok'),
        content: Text('Hapus ${stok.namaBarang} dari gudang $_gudang?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (ya == true && stok.id != null) {
      await _repo.hapus(stok.id!);
      await _muat();
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = _daftar.fold<int>(0, (a, s) => a + s.jumlah);

    return Scaffold(
      appBar: AppBar(
        title: Text('Stok Gudang $_gudang'),
        actions: [
          DropdownButton<String>(
            value: _gudang,
            underline: const SizedBox.shrink(),
            onChanged: _pilihGudang,
            items: _gudangTersedia.entries
                .map(
                  (entry) => DropdownMenuItem(
                    value: entry.key,
                    child: Text(entry.key),
                  ),
                )
                .toList(),
          ),
          IconButton(
            tooltip: 'Tambah Stok',
            icon: const Icon(Icons.add_box_outlined),
            onPressed: _tambahStok,
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: TextField(
              controller: _pencarianC,
              decoration: InputDecoration(
                labelText: 'Cari nama barang',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _pencarianC.text.isEmpty
                    ? null
                    : IconButton(
                        tooltip: 'Hapus pencarian',
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _pencarianC.clear();
                          setState(() => _memuat = true);
                          _muat();
                        },
                      ),
                border: const OutlineInputBorder(),
              ),
              onChanged: (_) {
                setState(() => _memuat = true);
                _muat();
              },
            ),
          ),
          if (!_memuat)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                'Total stok: $total unit dari ${_daftar.length} jenis barang',
              ),
            ),
          Expanded(
            child: _memuat
                ? const Center(child: CircularProgressIndicator())
                : _daftar.isEmpty
                ? const Center(child: Text('Belum ada data stok'))
                : ListView.builder(
                    itemCount: _daftar.length,
                    itemBuilder: (context, i) {
                      final stok = _daftar[i];
                      return ListTile(
                        title: Text(stok.namaBarang),
                        subtitle: Text(
                          '${stok.kodeBarang} - ${stok.jumlah} unit',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: () => _ubahJumlah(stok, -1),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              onPressed: () => _ubahJumlah(stok, 1),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () => _hapus(stok),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _tambahStok,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Stok'),
      ),
    );
  }
}
