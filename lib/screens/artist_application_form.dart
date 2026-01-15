import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// If flutter_image_compress import fails, comment out the import and compression logic for now.
// import 'package:flutter_image_compress/flutter_image_compress.dart';
import '../utils/validators.dart';
import '../models/artist_application.dart';

class ArtistApplicationForm extends StatefulWidget {
  final void Function(ArtistApplication) onSubmit;
  const ArtistApplicationForm({super.key, required this.onSubmit});

  @override
  State<ArtistApplicationForm> createState() => _ArtistApplicationFormState();
}

class _ArtistApplicationFormState extends State<ArtistApplicationForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _whatsappController = TextEditingController();
  String? _countryCode;
  String? _country;
  final _artistNameController = TextEditingController();
  final List<File> _images = [];
  bool _agreed = false;

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final picked = await picker.pickMultiImage();
    if (picked.length + _images.length <= 5) {
      // Compression is commented out due to import error. Use original files for now.
      // final compressed = await Future.wait(picked.map((x) async {
      //   final result = await FlutterImageCompress.compressAndGetFile(
      //     x.path, x.path + '_compressed.jpg',
      //     quality: 80, minWidth: 800, minHeight: 800,
      //   );
      //   return result ?? File(x.path);
      // }));
      // setState(() => _images.addAll(compressed));
      setState(() => _images.addAll(picked.map((x) => File(x.path))));
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate() || !_agreed) return;
    // TODO: Upload images to Supabase Storage, get URLs
    // For now, use dummy URLs
    final imageUrls = List<String>.generate(_images.length, (i) => 'https://dummy.url/image$i.jpg');
    final app = ArtistApplication(
      id: '',
      name: _nameController.text,
      surname: _surnameController.text,
      email: _emailController.text,
      whatsapp: _whatsappController.text,
      countryCode: _countryCode ?? '',
      country: _country ?? '',
      artistName: _artistNameController.text,
      imageUrls: imageUrls,
      status: 'pending',
      denialReason: null,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      userId: null,
    );
    widget.onSubmit(app);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (v) => Validators.requiredField(v, 'Name'),
            ),
            TextFormField(
              controller: _surnameController,
              decoration: const InputDecoration(labelText: 'Surname'),
              validator: (v) => Validators.requiredField(v, 'Surname'),
            ),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: Validators.email,
            ),
            Row(
              children: [
                DropdownButton<String>(
                  value: _countryCode,
                  hint: const Text('+Code'),
                  items: ['+1', '+27', '+44', '+91', '+81', '+49', '+33', '+61', '+55', '+34']
                      .map((code) => DropdownMenuItem(value: code, child: Text(code)))
                      .toList(),
                  onChanged: (v) => setState(() => _countryCode = v),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _whatsappController,
                    decoration: const InputDecoration(labelText: 'WhatsApp/Cell'),
                    validator: Validators.whatsapp,
                  ),
                ),
              ],
            ),
            DropdownButtonFormField<String>(
              initialValue: _country,
              hint: const Text('Country'),
              items: ['South Africa', 'USA', 'UK', 'Germany', 'France', 'India', 'Japan', 'Brazil', 'Australia', 'Canada']
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (v) => setState(() => _country = v),
              validator: (v) => v == null ? 'Country is required' : null,
            ),
            TextFormField(
              controller: _artistNameController,
              decoration: const InputDecoration(labelText: 'Artist Name'),
              validator: (v) => Validators.requiredField(v, 'Artist Name'),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _images.length < 5 ? _pickImages : null,
                  icon: const Icon(Icons.image),
                  label: const Text('Upload Images (5 required)'),
                ),
                const SizedBox(width: 8),
                Text('${_images.length}/5 selected'),
              ],
            ),
            if (_images.isNotEmpty)
              Wrap(
                spacing: 8,
                children: _images.map((img) => Image.file(img, width: 60, height: 60)).toList(),
              ),
            const SizedBox(height: 12),
            CheckboxListTile(
              value: _agreed,
              onChanged: (v) => setState(() => _agreed = v ?? false),
              title: const Text('I confirm all products are handmade and agree to the rules.'),
              controlAffinity: ListTileControlAffinity.leading,
            ),
            ElevatedButton(
              onPressed: _submit,
              child: const Text('Submit Application'),
            ),
          ],
        ),
      ),
    );
  }
}
