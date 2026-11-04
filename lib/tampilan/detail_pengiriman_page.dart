import 'package:flutter/material.dart';

import '../model/pengiriman.dart';

class DetailPengirimanPage extends StatelessWidget {
  const DetailPengirimanPage({required this.pengiriman, super.key});

  final Pengiriman pengiriman;

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

  Future<void> _konfirmasiHapus(BuildContext context) async {
    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus pengiriman?'),
        content: Text(
          'Pengiriman ${pengiriman.resi} akan dihapus dari daftar.',
        ),
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

    if (konfirmasi == true && context.mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final barang = pengiriman.barang;
    final beratSatuan = barang?.beratKg ?? 0;
    final totalBerat = beratSatuan * pengiriman.jumlah;
    final totalNilai = (barang?.hargaSatuan ?? 0) * pengiriman.jumlah;
    final pelanggan = pengiriman.pelanggan;

    return Scaffold(
      appBar: AppBar(title: Text(pengiriman.resi)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Informasi Pengiriman', style: _judulBagian(context)),
            const Divider(height: 20),
            _BarisDetail(label: 'Nomor Resi', nilai: pengiriman.resi),
            _BarisDetail(label: 'Status', nilai: pengiriman.status),
            _BarisDetail(
              label: 'Gudang Asal',
              nilai: pengiriman.asal?.nama ?? 'Gudang pusat',
            ),
            _BarisDetail(label: 'Kota Tujuan', nilai: pengiriman.kotaTujuan),
            _BarisDetail(
              label: 'Penerima',
              nilai: pelanggan?.nama ?? 'Data penerima belum tersedia',
            ),
            if (pelanggan != null)
              _BarisDetail(label: 'Alamat Penerima', nilai: pelanggan.alamat),
            _BarisDetail(
              label: 'Tanggal Kirim',
              nilai: _formatTanggal(pengiriman.tanggal),
            ),
            const SizedBox(height: 20),
            Text('Rincian Barang', style: _judulBagian(context)),
            const Divider(height: 20),
            _BarisDetail(label: 'Kode Barang', nilai: barang?.kode ?? '-'),
            _BarisDetail(
              label: 'Nama Barang',
              nilai: barang?.nama ?? 'Barang logistik',
            ),
            _BarisDetail(
              label: 'Jumlah',
              nilai: '${pengiriman.jumlah} ${barang?.satuan ?? 'pcs'}',
            ),
            _BarisDetail(
              label: 'Berat Barang',
              nilai: '${beratSatuan.toStringAsFixed(1)} kg / satuan',
            ),
            _BarisDetail(
              label: 'Total Berat',
              nilai: '${totalBerat.toStringAsFixed(1)} kg',
            ),
            _BarisDetail(
              label: 'Nilai Barang',
              nilai: 'Rp${totalNilai.toStringAsFixed(0)}',
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => Navigator.pop(context, false),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Kembali ke Daftar'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(44),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _konfirmasiHapus(context),
                icon: const Icon(Icons.delete_outline),
                label: const Text('Hapus Pengiriman'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(44),
                  foregroundColor: Theme.of(context).colorScheme.error,
                  side: BorderSide(color: Theme.of(context).colorScheme.error),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle? _judulBagian(BuildContext context) =>
      Theme.of(context).textTheme.titleMedium
          ?.copyWith(fontWeight: FontWeight.w600);
}

class _BarisDetail extends StatelessWidget {
  const _BarisDetail({required this.label, required this.nilai});

  final String label;
  final String nilai;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: style?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const Text(': '),
          Expanded(child: Text(nilai, style: style)),
        ],
      ),
    );
  }
}
