import 'package:shared_preferences/shared_preferences.dart';

class Preferensi {
  static const _kunciGudangTerakhir = 'gudang_terakhir';
  static const _kunciModeGelap = 'mode_gelap';

  Future<String?> ambilGudangTerakhir() async {
    final preferensi = await SharedPreferences.getInstance();
    return preferensi.getString(_kunciGudangTerakhir);
  }

  Future<void> simpanGudangTerakhir(String kodeGudang) async {
    final preferensi = await SharedPreferences.getInstance();
    await preferensi.setString(_kunciGudangTerakhir, kodeGudang);
  }

  Future<bool> ambilModeGelap() async {
    final preferensi = await SharedPreferences.getInstance();
    return preferensi.getBool(_kunciModeGelap) ?? false;
  }

  Future<void> simpanModeGelap(bool modeGelap) async {
    final preferensi = await SharedPreferences.getInstance();
    await preferensi.setBool(_kunciModeGelap, modeGelap);
  }
}
