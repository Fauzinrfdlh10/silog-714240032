import 'package:flutter/material.dart';

import '../model/pengiriman.dart';

class DetailPengirimanPage extends StatelessWidget {
  const DetailPengirimanPage({required this.pengiriman, super.key});

  final Pengiriman pengiriman;

  static const _urutanStatus = [
    'Menunggu',
    'Diproses',
    'Dikirim',
    'Dalam Perjalanan',
    'Terkirim',
  ];
  
  String _formatTanggal(DateTime tanggal) {
    const namaBulan = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return '${tanggal.day} ${namaBulan[tanggal.month - 1]} ${tanggal.year}';
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final statusAktif = _urutanStatus.indexOf(pengiriman.status);
    final barang = pengiriman.barang;
    final asal = pengiriman.asal;
    final pelanggan = pengiriman.pelanggan;

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Pengiriman')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nomor resi',
                      style: tema.textTheme.bodyMedium?.copyWith(
                        color: tema.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(pengiriman.resi, style: tema.textTheme.headlineSmall),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _InfoTujuan(
                            label: 'Dari',
                            nilai: asal?.kota ?? 'Gudang pusat',
                            icon: Icons.warehouse_outlined,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Icon(Icons.arrow_forward),
                        ),
                        Expanded(
                          child: _InfoTujuan(
                            label: 'Tujuan',
                            nilai: pengiriman.kotaTujuan,
                            icon: Icons.location_on_outlined,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text('Informasi barang', style: tema.textTheme.titleLarge),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.inventory_2_outlined),
                    title: Text(barang?.nama ?? 'Barang logistik'),
                    subtitle: Text('Jumlah: ${pengiriman.jumlah}'),
                  ),
                  if (barang != null)
                    ListTile(
                      leading: const Icon(Icons.sell_outlined),
                      title: Text('Kode ${barang.kode}'),
                      subtitle: Text(
                        'Harga satuan: Rp${barang.hargaSatuan.toStringAsFixed(0)}',
                      ),
                    ),
                  ListTile(
                    leading: const Icon(Icons.calendar_today_outlined),
                    title: const Text('Tanggal pengiriman'),
                    subtitle: Text(_formatTanggal(pengiriman.tanggal)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text('Penerima', style: tema.textTheme.titleLarge),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person_outline)),
                title: Text(pelanggan?.nama ?? 'Data penerima belum tersedia'),
                subtitle: Text(
                  [
                    if (pelanggan != null) pelanggan.alamat,
                    if (pelanggan != null) pelanggan.telepon,
                  ].join('\n'),
                ),
                isThreeLine: pelanggan != null,
              ),
            ),
            const SizedBox(height: 20),
            Text('Status pengiriman', style: tema.textTheme.titleLarge),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    for (var index = 0; index < _urutanStatus.length; index++)
                      _StatusItem(
                        label: _urutanStatus[index],
                        aktif: statusAktif >= index,
                        terakhir: index == _urutanStatus.length - 1,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoTujuan extends StatelessWidget {
  const _InfoTujuan({
    required this.label,
    required this.nilai,
    required this.icon,
  });

  final String label;
  final String nilai;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 6),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        Text(
          nilai,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }
}

class _StatusItem extends StatelessWidget {
  const _StatusItem({
    required this.label,
    required this.aktif,
    required this.terakhir,
  });

  final String label;
  final bool aktif;
  final bool terakhir;

  @override
  Widget build(BuildContext context) {
    final warna = aktif
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.outlineVariant;

    return IntrinsicHeight(
      child: Row(
        children: [
          SizedBox(
            width: 24,
            child: Column(
              children: [
                Icon(
                  aktif ? Icons.check_circle : Icons.radio_button_unchecked,
                  size: 20,
                  color: warna,
                ),
                if (!terakhir)
                  Expanded(child: Container(width: 2, color: warna)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: aktif
                    ? Theme.of(context).colorScheme.onSurface
                    : Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: aktif ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
