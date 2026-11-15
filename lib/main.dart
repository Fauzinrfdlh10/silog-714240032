import 'package:flutter/material.dart';

import 'data/preferensi.dart';
import 'tampilan/daftar_pengiriman_page.dart';

void main() {
  runApp(const SiLogApp());
}

class SiLogApp extends StatefulWidget {
  const SiLogApp({super.key});

  @override
  State<SiLogApp> createState() => _SiLogAppState();
}

class _SiLogAppState extends State<SiLogApp> {
  final _preferensi = Preferensi();
  bool _modeGelap = false;

  @override
  void initState() {
    super.initState();
    _muatModeGelap();
  }

  Future<void> _muatModeGelap() async {
    final modeGelap = await _preferensi.ambilModeGelap();
    if (mounted) setState(() => _modeGelap = modeGelap);
  }

  Future<void> _ubahModeGelap() async {
    final modeGelap = !_modeGelap;
    setState(() => _modeGelap = modeGelap);
    await _preferensi.simpanModeGelap(modeGelap);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SiLog',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      themeMode: _modeGelap ? ThemeMode.dark : ThemeMode.light,
      home: DaftarPengirimanPage(
        modeGelap: _modeGelap,
        onUbahModeGelap: _ubahModeGelap,
      ),
    );
  }

  ThemeData _buildTheme(Brightness brightness) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF3E7044),
      brightness: brightness,
    );
    final warnaLatar = brightness == Brightness.light
        ? const Color(0xFFF7FAF2)
        : colorScheme.surface;

    return ThemeData(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: warnaLatar,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: warnaLatar,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      useMaterial3: true,
    );
  }
}
