// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:silog_app/main.dart';

void main() {
  testWidgets('filter tab, ringkasan, detail, dan navigasi kembali berfungsi', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const SiLogApp());

    expect(find.text('Daftar Pengiriman'), findsOneWidget);
    expect(_tab('Semua'), findsOneWidget);
    expect(_tab('Dalam Perjalanan'), findsOneWidget);
    expect(_tab('Diterima'), findsOneWidget);
    expect(find.text('4 pengiriman'), findsOneWidget);
    expect(find.text('Rp4.970.000'), findsOneWidget);
    expect(find.text('SLG-2026-001'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(_tab('Dalam Perjalanan'));
    await tester.pumpAndSettle();
    expect(find.text('SLG-2026-002'), findsOneWidget);
    expect(find.text('SLG-2026-001'), findsNothing);
    expect(tester.takeException(), isNull);

    await tester.ensureVisible(_tab('Diterima'));
    await tester.pumpAndSettle();
    await tester.tap(_tab('Diterima'));
    await tester.pumpAndSettle();
    expect(find.text('SLG-2026-003'), findsOneWidget);
    expect(find.text('SLG-2026-002'), findsNothing);
    expect(tester.takeException(), isNull);

    await tester.ensureVisible(_tab('Semua'));
    await tester.pumpAndSettle();
    await tester.tap(_tab('Semua'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('SLG-2026-001'));
    await tester.pumpAndSettle();

    expect(find.text('Detail Pengiriman'), findsOneWidget);
    expect(find.text('Nadia Putri'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(find.text('Daftar Pengiriman'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

Finder _tab(String label) =>
    find.descendant(of: find.byType(TabBar), matching: find.text(label));
