import 'package:flutter/material.dart';

import '../data/data_contoh.dart';
import '../model/pengiriman.dart';
import '../widget/kartu_pengiriman.dart';
import 'detail_pengiriman_page.dart';
import 'form_pengiriman_page.dart';
import 'stok_page.dart';

class DaftarPengirimanPage extends StatefulWidget {
  const DaftarPengirimanPage({
    this.modeGelap = false,
    this.onUbahModeGelap,
    super.key,
  });

  final bool modeGelap;
  final VoidCallback? onUbahModeGelap;

  @override
  State<DaftarPengirimanPage> createState() => _DaftarPengirimanPageState();
}

class _DaftarPengirimanPageState extends State<DaftarPengirimanPage> {
  late List<Pengiriman> _daftar;
  String _filterStatus = 'Semua';

  @override
  void initState() {
    super.initState();
    _daftar = List<Pengiriman>.from(dataPengirimanContoh);
  }

  List<Pengiriman> get _hasilSaring => _filterStatus == 'Semua'
      ? _daftar
      : _daftar.where((p) => p.status == _statusModel).toList();

  String get _statusModel => switch (_filterStatus) {
    'Menunggu Pickup' => 'Menunggu',
    'Diterima' => 'Terkirim',
    _ => _filterStatus,
  };

  Future<void> _bukaFormulir() async {
    final hasil = await Navigator.push<Pengiriman>(
      context,
      MaterialPageRoute(
        builder: (_) => FormPengirimanPage(
          resiTerdaftar: _daftar.map((pengiriman) => pengiriman.resi).toList(),
        ),
      ),
    );

    if (hasil != null) {
      setState(() => _daftar.insert(0, hasil));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pengiriman ${hasil.resi} berhasil ditambahkan'),
        ),
      );
    }
  }

  Future<void> _bukaDetail(Pengiriman pengiriman) async {
    final dihapus = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => DetailPengirimanPage(pengiriman: pengiriman),
      ),
    );

    if (dihapus == true && mounted) {
      setState(() => _daftar.remove(pengiriman));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pengiriman ${pengiriman.resi} dihapus')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const opsi = ['Semua', 'Menunggu Pickup', 'Dalam Perjalanan', 'Diterima'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Pengiriman'),
        actions: [
          IconButton(
            tooltip: widget.modeGelap ? 'Mode terang' : 'Mode gelap',
            icon: Icon(widget.modeGelap ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.onUbahModeGelap,
          ),
          IconButton(
            tooltip: 'Stok Gudang',
            icon: const Icon(Icons.inventory_2_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const StokPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: opsi.map((o) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(o),
                      selected: _filterStatus == o,
                      onSelected: (_) => setState(() => _filterStatus = o),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Text(
            'Menampilkan ${_hasilSaring.length} dari ${_daftar.length} data',
          ),
          Expanded(
            child: _hasilSaring.isEmpty
                ? const Center(child: Text('Tidak ada data pengiriman'))
                : ListView.builder(
                    itemCount: _hasilSaring.length,
                    itemBuilder: (context, i) {
                      final item = _hasilSaring[i];
                      return KartuPengiriman(
                        pengiriman: item,
                        onTap: () => _bukaDetail(item),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _bukaFormulir,
        icon: const Icon(Icons.add),
        label: const Text('Pengiriman Baru'),
      ),
    );
  }
}
