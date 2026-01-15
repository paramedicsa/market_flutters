import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../data/models/product_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';

class CollectionsManagementScreen extends StatefulWidget {
  const CollectionsManagementScreen({super.key});

  @override
  State<CollectionsManagementScreen> createState() => _CollectionsManagementScreenState();
}

class _CollectionsManagementScreenState extends State<CollectionsManagementScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _readMoreController = TextEditingController();
  final TextEditingController _explanationController = TextEditingController();
  XFile? _selectedImage;
  List<Collection> _collections = [];
  bool _isLoading = true;

  Collection? _editingCollection; // Track if we're editing a collection

  @override
  void initState() {
    super.initState();
    _loadCollections();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _readMoreController.dispose();
    _explanationController.dispose();
    super.dispose();
  }

  Future<void> _loadCollections() async {
    try {
      final response = await Supabase.instance.client
          .from('collections')
          .select()
          .eq('is_active', true)
          .order('created_at', ascending: false);

      if (mounted) {
        setState(() {
          _collections = response.map((json) => Collection.fromJson(json)).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading collections: $e')),
        );
      }
    }
  }

  Future<void> _pickImage() async {
    try {
      final image = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() => _selectedImage = image);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error selecting image: $e')),
        );
      }
    }
  }

  Future<String?> _uploadImage(XFile image) async {
    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${image.name}';
      final bytes = await image.readAsBytes();
      String bucketName = 'collections';

      try {
        await Supabase.instance.client.storage
            .from(bucketName)
            .uploadBinary(fileName, bytes);
      } catch (bucketError) {
        final alternativeBuckets = ['images', 'uploads', 'media'];
        bool uploadSuccess = false;

        for (final altBucket in alternativeBuckets) {
          try {
            await Supabase.instance.client.storage
                .from(altBucket)
                .uploadBinary(fileName, bytes);
            bucketName = altBucket;
            uploadSuccess = true;
            break;
          } catch (_) {}
        }

        if (!uploadSuccess) throw Exception('Storage bucket not found.');
      }

      return Supabase.instance.client.storage.from(bucketName).getPublicUrl(fileName);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload failed: $e'), backgroundColor: Colors.red),
        );
      }
      return null;
    }
  }

  Future<void> _saveCollection() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Collection name is required')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      String? imageUrl = _editingCollection?.imageUrl; // Keep existing image if editing
      if (_selectedImage != null) {
        imageUrl = await _uploadImage(_selectedImage!);
      }

      if (_editingCollection != null) {
        // Update existing collection
        final updated = Collection(
          id: _editingCollection!.id,
          name: _nameController.text,
          imageUrl: imageUrl,
          description: _descriptionController.text,
          readMoreText: _readMoreController.text,
          explanationText: _explanationController.text,
          createdAt: _editingCollection!.createdAt,
          updatedAt: DateTime.now(),
        );

        await Supabase.instance.client
            .from('collections')
            .update(updated.toJson())
            .eq('id', _editingCollection!.id!);

        setState(() => _editingCollection = null);
      } else {
        // Create new collection
        final collection = Collection(
          name: _nameController.text,
          imageUrl: imageUrl,
          description: _descriptionController.text,
          readMoreText: _readMoreController.text,
          explanationText: _explanationController.text,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await Supabase.instance.client.from('collections').insert(collection.toJson());
      }

      _nameController.clear();
      _descriptionController.clear();
      setState(() {
        _selectedImage = null;
        _readMoreController.text = 'Read more';
        _explanationController.text = '';
      });

      await _loadCollections();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_editingCollection != null ? 'Collection updated successfully!' : 'Collection saved successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _deleteCollection(Collection collection) async {
    if (collection.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cannot delete collection: invalid ID')),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardDark,
        title: const Text('Delete Collection', style: TextStyle(color: Colors.white)),
        content: Text('Delete "${collection.name}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await Supabase.instance.client.from('collections').delete().eq('id', collection.id!);
        await _loadCollections();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Collection deleted successfully!')),
          );
        }
      } catch (e) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> _editCollection(Collection collection) async {
    setState(() {
      _editingCollection = collection;
      _nameController.text = collection.name;
      _descriptionController.text = collection.description;
      _readMoreController.text = collection.readMoreText ?? 'Read more';
      _explanationController.text = collection.explanationText ?? '';
      _selectedImage = null; // Reset selected image
    });
  }

  void _cancelEdit() {
    setState(() {
      _editingCollection = null;
      _nameController.clear();
      _descriptionController.clear();
      _readMoreController.text = 'Read more';
      _explanationController.text = '';
      _selectedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.black,
      appBar: AppBar(
        backgroundColor: AppTheme.black,
        title: const Text('Collections Management', style: TextStyle(color: Colors.white)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.cyan))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _editingCollection != null ? 'Edit Collection' : 'Create New Collection',
              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.cardDark,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.cyan.withValues(alpha: 0.3)),
              ),
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(labelText: 'Collection Name'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(labelText: 'Description'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _readMoreController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(labelText: 'Read More Text'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _explanationController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(labelText: 'Explanation'),
                  ),
                  const SizedBox(height: 16),
                  if (_editingCollection != null && _editingCollection!.imageUrl != null) ...[
                    const Text(
                      'Current Image',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        _editingCollection!.imageUrl!,
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: Text(_selectedImage == null ? (_editingCollection != null ? 'Change Image' : 'Select Image') : 'Image Selected'),
                  ),
                  if (_selectedImage != null) ...[
                    const SizedBox(height: 16),
                    const Text(
                      'New Image Preview',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(_selectedImage!.path),
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      if (_editingCollection != null) ...[
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _cancelEdit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(width: 16),
                      ],
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _saveCollection,
                          style: ElevatedButton.styleFrom(backgroundColor: AppTheme.cyan),
                          child: Text(_editingCollection != null ? 'Save Collection' : 'Create Collection'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text('Existing Collections', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _collections.length,
              itemBuilder: (context, index) {
                final collection = _collections[index];
                return ListTile(
                  leading: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white.withValues(alpha: 0.05),
                      image: collection.imageUrl != null
                          ? DecorationImage(
                              image: NetworkImage(collection.imageUrl!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: collection.imageUrl == null
                        ? const Icon(
                            Icons.image,
                            color: Colors.white30,
                            size: 24,
                          )
                        : null,
                  ),
                  title: Text(collection.name, style: const TextStyle(color: Colors.white)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(icon: const Icon(Icons.edit, color: Colors.orange), onPressed: () => _editCollection(collection)),
                      IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _deleteCollection(collection)),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

