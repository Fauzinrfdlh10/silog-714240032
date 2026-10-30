import 'package:flutter/material.dart';

import '../data/data_contoh.dart';
import '../model/pengiriman.dart';
import '../widget/kartu_pengiriman.dart';
import 'detail_pengiriman_page.dart';

class DaftarPengirimanPage extends StatefulWidget {
  const DaftarPengirimanPage({super.key});

  @override
  State<DaftarPengirimanPage> createState() => _DaftarPengirimanPageState();
}

class _DaftarPengirimanPageState extends State<DaftarPengirimanPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  static const _labelTab = ['Semua', 'Dalam Perjalanan', 'Diterima'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _labelTab.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Pengiriman> _pengirimanUntukTab(int index) {
    if (index == 0) {
      return dataPengirimanContoh;
    }

    final status = index == 1 ? 'Dalam Perjalanan' : 'Terkirim';
    return dataPengirimanContoh
        .where((pengiriman) => pengiriman.status == status)
        .toList();
  }

  double get _totalNilaiBarang => dataPengirimanContoh.fold(
    0,
    (total, pengiriman) =>
        total + (pengiriman.barang?.hargaSatuan ?? 0) * pengiriman.jumlah,
  );

  String _formatRupiah(double nilai) {
    final angka = nilai.round().toString();
    final berkelompok = angka.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (_) => '.',
    );
    return 'Rp$berkelompok';
  }

  void _bukaDetail(BuildContext context, Pengiriman pengiriman) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => DetailPengirimanPage(pengiriman: pengiriman),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Pengiriman'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: [for (final label in _labelTab) Tab(text: label)],
        ),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Jumlah pengiriman',
                          style: tema.textTheme.bodyMedium?.copyWith(
                            color: tema.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${dataPengirimanContoh.length} pengiriman',
                          style: tema.textTheme.titleLarge,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Total nilai barang',
                          textAlign: TextAlign.end,
                          style: tema.textTheme.bodyMedium?.copyWith(
                            color: tema.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatRupiah(_totalNilaiBarang),
                          textAlign: TextAlign.end,
                          style: tema.textTheme.titleLarge,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                for (var index = 0; index < _labelTab.length; index++)
                  _DaftarTab(
                    pengiriman: _pengirimanUntukTab(index),
                    onTap: (pengiriman) => _bukaDetail(context, pengiriman),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DaftarTab extends StatelessWidget {
  const _DaftarTab({required this.pengiriman, required this.onTap});

  final List<Pengiriman> pengiriman;
  final ValueChanged<Pengiriman> onTap;

  @override
  Widget build(BuildContext context) {
    if (pengiriman.isEmpty) {
      return const Center(
        child: Text('Tidak ada pengiriman pada kategori ini.'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 20),
      itemCount: pengiriman.length,
      itemBuilder: (context, index) {
        final item = pengiriman[index];
        return KartuPengiriman(pengiriman: item, onTap: () => onTap(item));
      },
    );
  }
}
