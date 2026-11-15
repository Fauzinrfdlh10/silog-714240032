import 'package:flutter/material.dart';

import '../model/stok.dart';

class FormStokPage extends StatefulWidget {
  const FormStokPage({required this.kodeGudang, super.key});

  final String kodeGudang;

  @override
  State<FormStokPage> createState() => _FormStokPageState();
}

class _FormStokPageState extends State<FormStokPage> {
  final _formKey = GlobalKey<FormState>();
  final _kodeBarangC = TextEditingController();
  final _namaBarangC = TextEditingController();
  final _jumlahC = TextEditingController();

  @override
  void dispose() {
    _kodeBarangC.dispose();
    _namaBarangC.dispose();
    _jumlahC.dispose();
    super.dispose();
  }

  String? _wajib(String? nilai, String label) {
    if (nilai == null || nilai.trim().isEmpty) return '$label wajib diisi';
    return null;
  }

  String? _validasiJumlah(String? nilai) {
    final pesanWajib = _wajib(nilai, 'Jumlah');
    if (pesanWajib != null) return pesanWajib;
    final jumlah = int.tryParse(nilai!.trim());
    if (jumlah == null) {
      return 'Jumlah harus berupa bilangan bulat';
    }
    if (jumlah < 0) {
      return 'Jumlah tidak boleh kurang dari 0';
    }
    return null;
  }

  void _simpan() {
    if (!_formKey.currentState!.validate()) return;

    Navigator.pop(
      context,
      Stok(
        kodeBarang: _kodeBarangC.text.trim().toUpperCase(),
        namaBarang: _namaBarangC.text.trim(),
        kodeGudang: widget.kodeGudang,
        jumlah: int.parse(_jumlahC.text.trim()),
        diperbaruiPada: DateTime.now(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Stok')),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _kodeBarangC,
              decoration: const InputDecoration(
                labelText: 'Kode Barang',
                hintText: 'BRG-001',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.characters,
              validator: (nilai) => _wajib(nilai, 'Kode barang'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _namaBarangC,
              decoration: const InputDecoration(
                labelText: 'Nama Barang',
                border: OutlineInputBorder(),
              ),
              validator: (nilai) => _wajib(nilai, 'Nama barang'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _jumlahC,
              decoration: const InputDecoration(
                labelText: 'Jumlah',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: _validasiJumlah,
            ),
            const SizedBox(height: 24),
            FilledButton(onPressed: _simpan, child: const Text('Simpan Stok')),
          ],
        ),
      ),
    );
  }
}
