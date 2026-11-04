import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../model/barang.dart';
import '../model/gudang.dart';
import '../model/pengiriman.dart';

class FormPengirimanPage extends StatefulWidget {
  const FormPengirimanPage({this.resiTerdaftar = const [], super.key});

  final List<String> resiTerdaftar;

  @override
  State<FormPengirimanPage> createState() => _FormPengirimanPageState();
}

class _FormPengirimanPageState extends State<FormPengirimanPage> {
  final _formKey = GlobalKey<FormState>();
  final _resiC = TextEditingController();
  final _namaBarangC = TextEditingController();
  final _hargaC = TextEditingController();
  final _jumlahC = TextEditingController();
  final _beratC = TextEditingController();

  String _kotaTujuan = 'Surabaya';
  DateTime _tanggalKirim = DateTime.now();

  @override
  void dispose() {
    _resiC.dispose();
    _namaBarangC.dispose();
    _hargaC.dispose();
    _jumlahC.dispose();
    _beratC.dispose();
    super.dispose();
  }

  String? _wajib(String? v, String label) {
    if (v == null || v.trim().isEmpty) return '$label wajib diisi';
    return null;
  }

  String? _validasiResi(String? v) {
    final dasar = _wajib(v, 'Nomor resi');
    if (dasar != null) return dasar;
    final pola = RegExp(r'^SLG-\d{4}-\d{3,4}$');
    final resi = v!.trim().toUpperCase();
    if (!pola.hasMatch(resi)) {
      return 'Format resi harus SLG-TAHUN-NOMOR, contoh SLG-2026-0010';
    }
    if (widget.resiTerdaftar.any(
      (terdaftar) => terdaftar.toUpperCase() == resi,
    )) {
      return 'Nomor resi sudah terdaftar';
    }
    return null;
  }

  String? _validasiAngka(String? v, String label, {double min = 1}) {
    final dasar = _wajib(v, label);
    if (dasar != null) return dasar;
    final angka = double.tryParse(v!.trim());
    if (angka == null) return '$label harus berupa angka';
    if (angka < min) return '$label minimal $min';
    return null;
  }

  String? _validasiBerat(String? v) {
    final dasar = _wajib(v, 'Berat barang');
    if (dasar != null) return dasar;
    final angka = double.tryParse(v!.trim().replaceAll(',', '.'));
    if (angka == null) return 'Berat barang harus berupa angka';
    if (angka < 0.1 || angka > 5000) {
      return 'Berat barang harus antara 0,1 dan 5000 kg';
    }
    return null;
  }

  String? _validasiTanggal() {
    final batas = DateTime.now().subtract(const Duration(days: 1));
    if (_tanggalKirim.isBefore(batas)) {
      return 'Tanggal kirim tidak boleh sebelum hari ini';
    }
    return null;
  }

  Future<void> _pilihTanggal() async {
    final hasil = await showDatePicker(
      context: context,
      initialDate: _tanggalKirim,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (hasil != null) setState(() => _tanggalKirim = hasil);
  }

  void _simpan() {
    final pesanTanggal = _validasiTanggal();
    if (!_formKey.currentState!.validate() || pesanTanggal != null) {
      if (pesanTanggal != null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(pesanTanggal)));
      }
      return;
    }

    final pengiriman = Pengiriman(
      resi: _resiC.text.trim().toUpperCase(),
      kotaTujuan: _kotaTujuan,
      jumlah: int.parse(_jumlahC.text.trim()),
      tanggal: _tanggalKirim,
      asal: Gudang(
        kode: 'GDG-BDG',
        nama: 'Gudang Bandung',
        kota: 'Bandung',
        kapasitas: 1000,
      ),
      barang: Barang(
        kode: 'B-${DateTime.now().millisecondsSinceEpoch % 10000}',
        nama: _namaBarangC.text.trim(),
        hargaSatuan: double.parse(_hargaC.text.trim()),
        beratKg: double.parse(_beratC.text.trim().replaceAll(',', '.')),
      ),
    );

    Navigator.pop(context, pengiriman);
  }

  @override
  Widget build(BuildContext context) {
    const kota = ['Surabaya', 'Makassar', 'Medan', 'Denpasar', 'Jayapura'];

    return Scaffold(
      appBar: AppBar(title: const Text('Pengiriman Baru')),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _resiC,
              decoration: const InputDecoration(
                labelText: 'Nomor Resi',
                hintText: 'SLG-2026-0010',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.characters,
              validator: _validasiResi,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _namaBarangC,
              decoration: const InputDecoration(
                labelText: 'Nama Barang',
                border: OutlineInputBorder(),
              ),
              validator: (v) => _wajib(v, 'Nama barang'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _hargaC,
              decoration: const InputDecoration(
                labelText: 'Harga Satuan (Rp)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (v) => _validasiAngka(v, 'Harga satuan', min: 1000),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _beratC,
              decoration: const InputDecoration(
                labelText: 'Berat Barang (kg)',
                hintText: 'Contoh: 2,5',
                helperText: 'Berat per satuan barang',
                border: OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
              ],
              validator: _validasiBerat,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _jumlahC,
              decoration: const InputDecoration(
                labelText: 'Jumlah',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (v) => _validasiAngka(v, 'Jumlah'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _kotaTujuan,
              decoration: const InputDecoration(
                labelText: 'Kota Tujuan',
                border: OutlineInputBorder(),
              ),
              items: kota
                  .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                  .toList(),
              onChanged: (v) => setState(() => _kotaTujuan = v!),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _pilihTanggal,
              icon: const Icon(Icons.calendar_today),
              label: Text(
                'Tanggal Kirim: '
                '${_tanggalKirim.day}/${_tanggalKirim.month}/${_tanggalKirim.year}',
              ),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(44),
                foregroundColor: Theme.of(context).colorScheme.primary,
                side: BorderSide(color: Theme.of(context).colorScheme.outline),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _simpan,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(44),
                backgroundColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              child: const Text('Simpan Pengiriman'),
            ),
          ],
        ),
      ),
    );
  }
}
