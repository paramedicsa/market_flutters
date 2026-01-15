import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../data/models/product_model.dart';

class GeneralTab extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final TextEditingController stylingController;
  final TextEditingController urlSlugController;
  final TextEditingController skuController;
  final TextEditingController madeByController;
  final TextEditingController materialsController;
  final List<String> artists;
  final List<String> materials;
  final List<String> selectedMaterials;
  final List<String> selectedColors;
  final List<String> selectedTags;
  final List<Collection> collections;
  final String selectedCollection;
  final String selectedProductType;
  final String selectedStatus;
  final Function(String) onCollectionChanged;
  final Function(String) onProductTypeChanged;
  final Function(String) onStatusChanged;
  final Function(String) onAddNewArtist;
  final Function(String) onAddNewMaterial;
  final Function(String) onMaterialSelected;
  final Function(String) onMaterialRemoved;
  final Function(String) onColorAdded;
  final Function(String) onColorRemoved;
  final Function(String) onTagAdded;
  final Function(String) onTagRemoved;

  const GeneralTab({
    super.key,
    required this.nameController,
    required this.descriptionController,
    required this.stylingController,
    required this.urlSlugController,
    required this.skuController,
    required this.madeByController,
    required this.materialsController,
    required this.artists,
    required this.materials,
    required this.selectedMaterials,
    required this.selectedColors,
    required this.selectedTags,
    required this.collections,
    required this.selectedCollection,
    required this.selectedProductType,
    required this.selectedStatus,
    required this.onCollectionChanged,
    required this.onProductTypeChanged,
    required this.onStatusChanged,
    required this.onAddNewArtist,
    required this.onAddNewMaterial,
    required this.onMaterialSelected,
    required this.onMaterialRemoved,
    required this.onColorAdded,
    required this.onColorRemoved,
    required this.onTagAdded,
    required this.onTagRemoved,
  });

  @override
  State<GeneralTab> createState() => _GeneralTabState();
}

class _GeneralTabState extends State<GeneralTab> {
  final _colorInputController = TextEditingController();
  final _tagInputController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _colorInputController.dispose();
    _tagInputController.dispose();
    super.dispose();
  }

  void _addColorsFromInput(String input) {
    final colors = input.split(',').map((color) => color.trim()).where((color) => color.isNotEmpty);
    for (final color in colors) {
      if (!widget.selectedColors.contains(color)) {
        widget.onColorAdded(color);
      }
    }
  }

  void _addTagsFromInput(String input) {
    final tags = input.split(',').map((tag) => tag.trim()).where((tag) => tag.isNotEmpty);
    for (final tag in tags) {
      if (!widget.selectedTags.contains(tag)) {
        widget.onTagAdded(tag);
      }
    }
  }

  Future<String?> _showAddNewDialog(String title, String hint) async {
    String? newValue;

    return showDialog<String>(
      context: context,
      builder: (context) {
        String inputValue = '';

        return AlertDialog(
          backgroundColor: AppTheme.cardDark,
          title: Text(title, style: const TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: const TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.white30),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.white30),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppTheme.pink),
                  ),
                ),
                onChanged: (value) {
                  inputValue = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (inputValue.isNotEmpty) {
                  newValue = inputValue;
                }
                Navigator.of(context).pop(newValue);
              },
              child: const Text('Add', style: TextStyle(color: AppTheme.pink)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Product Information',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: widget.nameController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Product Name',
              labelStyle: const TextStyle(color: Colors.white70),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.white30),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.white30),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.pink),
              ),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.05),
            ),
            validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: widget.selectedCollection.isEmpty ? null : widget.selectedCollection,
            dropdownColor: AppTheme.cardDark,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Collection',
              labelStyle: const TextStyle(color: Colors.white70),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.white30),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.white30),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.pink),
              ),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.05),
            ),
            items: widget.collections.map((collection) => DropdownMenuItem(
              value: collection.name,
              child: Text(collection.name),
            )).toList(),
            onChanged: (value) => widget.onCollectionChanged(value!),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: widget.selectedProductType.isEmpty ? null : widget.selectedProductType,
            dropdownColor: AppTheme.cardDark,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Product Type',
              labelStyle: const TextStyle(color: Colors.white70),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.white30),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.white30),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.pink),
              ),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.05),
            ),
            items: const [
              DropdownMenuItem(value: 'ring', child: Text('Ring')),
              DropdownMenuItem(value: 'earrings', child: Text('Earrings')),
              DropdownMenuItem(value: 'necklace', child: Text('Necklace')),
              DropdownMenuItem(value: 'bracelet', child: Text('Bracelet')),
              DropdownMenuItem(value: 'pendant', child: Text('Pendant')),
              DropdownMenuItem(value: 'brooch', child: Text('Brooch')),
              DropdownMenuItem(value: 'cufflinks', child: Text('Cufflinks')),
              DropdownMenuItem(value: 'other', child: Text('Other')),
              DropdownMenuItem(value: 'Pendants and Necklaces', child: Text('Pendants and Necklaces')),
            ],
            onChanged: (value) => widget.onProductTypeChanged(value!),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: widget.selectedStatus,
            dropdownColor: AppTheme.cardDark,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Status',
              labelStyle: const TextStyle(color: Colors.white70),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.white30),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.white30),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.pink),
              ),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.05),
            ),
            items: const [
              DropdownMenuItem(
                value: 'draft',
                child: Row(
                  children: [
                    Icon(Icons.edit_note, color: Colors.orange, size: 20),
                    SizedBox(width: 8),
                    Text('Draft'),
                  ],
                ),
              ),
              DropdownMenuItem(
                value: 'active',
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 20),
                    SizedBox(width: 8),
                    Text('Published'),
                  ],
                ),
              ),
            ],
            onChanged: (value) => widget.onStatusChanged(value!),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: widget.descriptionController,
            maxLines: 4,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Description',
              labelStyle: const TextStyle(color: Colors.white70),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.white30),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.white30),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.pink),
              ),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.05),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: widget.stylingController,
            maxLines: 4,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Styling',
              labelStyle: const TextStyle(color: Colors.white70),
              hintText: 'Enter styling details...',
              hintStyle: const TextStyle(color: Colors.white38),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.white30),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.white30),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.pink),
              ),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.05),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: widget.urlSlugController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'URL Slug',
              labelStyle: const TextStyle(color: Colors.white70),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.white30),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.white30),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.pink),
              ),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.05),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: widget.skuController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'SKU',
              labelStyle: const TextStyle(color: Colors.white70),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.white30),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.white30),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.pink),
              ),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.05),
            ),
          ),
          const SizedBox(height: 16),
          // Made By Dropdown with Add New functionality
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: widget.madeByController.text.isEmpty || !widget.artists.contains(widget.madeByController.text) ? null : widget.madeByController.text,
                dropdownColor: AppTheme.cardDark,
                hint: const Text(
                  'Made By',
                  style: TextStyle(color: Colors.white70),
                ),
                isExpanded: true,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                items: [
                  ...widget.artists.map((artist) => DropdownMenuItem(
                    value: artist,
                    child: Text(artist, style: const TextStyle(color: Colors.white)),
                  )),
                  const DropdownMenuItem(
                    value: '__add_new__',
                    child: Row(
                      children: [
                        Icon(Icons.add, color: AppTheme.cyan, size: 20),
                        SizedBox(width: 8),
                        Text('Add New Artist', style: TextStyle(color: AppTheme.cyan)),
                      ],
                    ),
                  ),
                ],
                onChanged: (value) async {
                  if (value == '__add_new__') {
                    final newArtist = await _showAddNewDialog('Add New Artist', 'Enter artist name:');
                    if (newArtist != null && newArtist.isNotEmpty) {
                      widget.onAddNewArtist(newArtist);
                      setState(() => widget.madeByController.text = newArtist);
                    }
                  } else {
                    setState(() => widget.madeByController.text = value ?? '');
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Materials Multi-Select
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
                  child: const Text(
                    'Materials',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                // Selected Materials Chips
                if (widget.selectedMaterials.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.selectedMaterials.map((material) => Chip(
                        label: Text(
                          material,
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                        backgroundColor: AppTheme.cyan.withValues(alpha: 0.2),
                        deleteIcon: const Icon(Icons.close, size: 16, color: Colors.white),
                        onDeleted: () => widget.onMaterialRemoved(material),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: const BorderSide(color: AppTheme.cyan),
                        ),
                      )).toList(),
                    ),
                  ),
                ],
                // Add Material Dropdown
                DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    dropdownColor: AppTheme.cardDark,
                    hint: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        widget.selectedMaterials.isEmpty ? 'Select materials...' : 'Add another material...',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ),
                    isExpanded: true,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    items: [
                      ...widget.materials.where((material) => !widget.selectedMaterials.contains(material)).map((material) => DropdownMenuItem(
                        value: material,
                        child: Text(material, style: const TextStyle(color: Colors.white)),
                      )),
                      const DropdownMenuItem(
                        value: '__add_new__',
                        child: Row(
                          children: [
                            Icon(Icons.add, color: AppTheme.cyan, size: 20),
                            SizedBox(width: 8),
                            Text('Add New Material', style: TextStyle(color: AppTheme.cyan)),
                          ],
                        ),
                      ),
                    ],
                    onChanged: (value) async {
                      if (value == '__add_new__') {
                        final newMaterial = await _showAddNewDialog('Add New Material', 'Enter material name:');
                        if (newMaterial != null && newMaterial.isNotEmpty && !widget.selectedMaterials.contains(newMaterial)) {
                          widget.onAddNewMaterial(newMaterial);
                        }
                      } else if (value != null && !widget.selectedMaterials.contains(value)) {
                        widget.onMaterialSelected(value);
                      }
                    },
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Colors Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white30),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Colors',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                // Selected Colors Chips
                if (widget.selectedColors.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.selectedColors.map((color) => Chip(
                      label: Text(color),
                      backgroundColor: Colors.red.withValues(alpha: 0.2),
                      labelStyle: const TextStyle(color: Colors.red),
                      deleteIcon: const Icon(Icons.close, size: 18, color: Colors.red),
                      onDeleted: () => widget.onColorRemoved(color),
                    )).toList(),
                  ),
                if (widget.selectedColors.isNotEmpty) const SizedBox(height: 8),
                // Add Color Field
                TextField(
                  controller: _colorInputController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Enter color (e.g., Crimson red, Cloudy white)',
                    hintStyle: const TextStyle(color: Colors.white38),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.white30),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.white30),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppTheme.pink),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.add, color: AppTheme.cyan),
                      onPressed: () {
                        final value = _colorInputController.text.trim();
                        if (value.isNotEmpty) {
                          _addColorsFromInput(value);
                          _colorInputController.clear();
                        }
                      },
                    ),
                  ),
                  onSubmitted: (value) {
                    if (value.trim().isNotEmpty) {
                      _addColorsFromInput(value.trim());
                      _colorInputController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Tags Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white30),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tags',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                // Selected Tags Chips
                if (widget.selectedTags.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.selectedTags.map((tag) => Chip(
                      label: Text(tag),
                      backgroundColor: AppTheme.cyan.withValues(alpha: 0.2),
                      labelStyle: const TextStyle(color: AppTheme.cyan),
                      deleteIcon: const Icon(Icons.close, size: 18, color: AppTheme.cyan),
                      onDeleted: () => widget.onTagRemoved(tag),
                    )).toList(),
                  ),
                if (widget.selectedTags.isNotEmpty) const SizedBox(height: 8),
                // Add Tag Field
                TextField(
                  controller: _tagInputController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Enter tag (e.g., heart necklace, handmade jewelry)',
                    hintStyle: const TextStyle(color: Colors.white38),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.white30),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.white30),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppTheme.pink),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.add, color: AppTheme.cyan),
                      onPressed: () {
                        final value = _tagInputController.text.trim();
                        if (value.isNotEmpty) {
                          _addTagsFromInput(value);
                          _tagInputController.clear();
                        }
                      },
                    ),
                  ),
                  onSubmitted: (value) {
                    if (value.trim().isNotEmpty) {
                      _addTagsFromInput(value.trim());
                      _tagInputController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          ElevatedButton.icon(
            onPressed: () {
              // TODO: Integrate with Gemini AI for description generation
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('AI description generation coming soon!')),
              );
            },
            icon: const Icon(Icons.auto_awesome),
            label: const Text('Generate with AI'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.pink,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
