import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:silog_app/main.dart';

void main() {
  testWidgets('form validates input and adds a shipment with its weight', (
    tester,
  ) async {
    await _pumpApp(tester);

    await tester.tap(find.text('Pengiriman Baru'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Simpan Pengiriman'));
    await tester.pumpAndSettle();

    expect(find.text('Nomor resi wajib diisi'), findsOneWidget);
    expect(find.text('Nama barang wajib diisi'), findsOneWidget);
    expect(find.text('Harga satuan wajib diisi'), findsOneWidget);
    expect(find.text('Jumlah wajib diisi'), findsOneWidget);
    expect(find.text('Berat barang wajib diisi'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(0), 'SLG-2026-001');
    await tester.pump();
    expect(find.text('Nomor resi sudah terdaftar'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(0), 'ABC-1');
    await tester.pump();
    expect(
      find.text('Format resi harus SLG-TAHUN-NOMOR, contoh SLG-2026-0010'),
      findsOneWidget,
    );

    await tester.enterText(find.byType(TextFormField).at(0), 'SLG-2026-1000');
    await tester.enterText(find.byType(TextFormField).at(1), 'Buku');
    await tester.enterText(find.byType(TextFormField).at(2), '25000');
    await tester.enterText(find.byType(TextFormField).at(4), '2');
    await tester.enterText(find.byType(TextFormField).at(3), '0,09');
    await tester.tap(find.text('Simpan Pengiriman'));
    await tester.pumpAndSettle();
    expect(
      find.text('Berat barang harus antara 0,1 dan 5000 kg'),
      findsOneWidget,
    );

    await tester.enterText(find.byType(TextFormField).at(3), '5000,1');
    await tester.tap(find.text('Simpan Pengiriman'));
    await tester.pumpAndSettle();
    expect(
      find.text('Berat barang harus antara 0,1 dan 5000 kg'),
      findsOneWidget,
    );

    await tester.enterText(find.byType(TextFormField).at(3), '5000');
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(3), '0,1');
    await tester.tap(find.text('Simpan Pengiriman'));
    await tester.pumpAndSettle();

    expect(find.text('SLG-2026-1000'), findsOneWidget);
    expect(
      find.text('Pengiriman SLG-2026-1000 berhasil ditambahkan'),
      findsOneWidget,
    );

    await tester.tap(find.text('SLG-2026-1000'));
    await tester.pumpAndSettle();
    expect(find.text('Berat Barang'), findsOneWidget);
    expect(find.text('0.1 kg / satuan'), findsOneWidget);
  });

  testWidgets('status filter follows model statuses', (tester) async {
    await _pumpApp(tester);

    final filterPerjalanan = find.widgetWithText(
      ChoiceChip,
      'Dalam Perjalanan',
    );
    await tester.ensureVisible(filterPerjalanan);
    await tester.tap(filterPerjalanan);
    await tester.pumpAndSettle();
    expect(find.text('SLG-2026-002'), findsOneWidget);
    expect(find.text('SLG-2026-001'), findsNothing);

    await tester.ensureVisible(find.text('Diterima'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ChoiceChip, 'Diterima'));
    await tester.pumpAndSettle();
    expect(find.text('SLG-2026-003'), findsOneWidget);
    expect(find.text('SLG-2026-002'), findsNothing);
  });

  testWidgets('deleting a shipment requires confirmation', (tester) async {
    await _pumpApp(tester);

    await tester.tap(find.text('SLG-2026-001'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Hapus Pengiriman'));
    await tester.tap(find.text('Hapus Pengiriman'));
    await tester.pumpAndSettle();
    expect(find.text('Hapus pengiriman?'), findsOneWidget);

    await tester.tap(find.text('Batal'));
    await tester.pumpAndSettle();
    expect(find.text('SLG-2026-001'), findsNWidgets(2));

    await tester.ensureVisible(find.text('Hapus Pengiriman'));
    await tester.tap(find.text('Hapus Pengiriman'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Hapus'));
    await tester.pumpAndSettle();

    expect(find.text('Daftar Pengiriman'), findsOneWidget);
    expect(find.text('SLG-2026-001'), findsNothing);
    expect(find.text('Menampilkan 3 dari 3 data'), findsOneWidget);
  });
}

Future<void> _pumpApp(WidgetTester tester) async {
  tester.view.physicalSize = const Size(400, 900);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(const SiLogApp());
}
