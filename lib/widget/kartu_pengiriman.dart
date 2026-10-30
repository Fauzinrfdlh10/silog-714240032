import 'package:flutter/material.dart';

import '../model/pengiriman.dart';

class KartuPengiriman extends StatelessWidget {
  const KartuPengiriman({
    required this.pengiriman,
    required this.onTap,
    super.key,
  });

  final Pengiriman pengiriman;
  final VoidCallback onTap;

  Color _warnaStatus(BuildContext context) {
    switch (pengiriman.status) {
      case 'Terkirim':
        return Colors.green;
      case 'Dalam Perjalanan':
        return Colors.orange;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final warnaStatus = _warnaStatus(context);
    final teks = Theme.of(context).textTheme;
    final namaBarang = pengiriman.barang?.nama ?? 'Barang logistik';
    final kotaAsal = pengiriman.asal?.kota ?? 'Gudang pusat';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: warnaStatus.withAlpha(30),
                child: Icon(Icons.inventory_2_outlined, color: warnaStatus),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pengiriman.resi,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: teks.titleMedium,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '$namaBarang x ${pengiriman.jumlah}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: teks.bodyMedium,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '$kotaAsal  →  ${pengiriman.kotaTujuan}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: teks.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: warnaStatus.withAlpha(24),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    pengiriman.status,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: teks.labelSmall?.copyWith(color: warnaStatus),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
