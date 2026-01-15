import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/product_repository.dart';
import 'product_creation_screen.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final _repository = ProductRepository();
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() => _isLoading = true);
    try {
      final products = await _repository.getAllProducts();
      debugPrint('📦 Loaded ${products.length} products');
      for (var product in products) {
        debugPrint('   - ${product.name}: ${product.images.length} images');
        if (product.images.isNotEmpty) {
          debugPrint('     First image: ${product.images.first}');
        }
      }
      setState(() {
        _products = products;
        _filteredProducts = products;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('❌ Error loading products: $e');
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading products: $e')),
        );
      }
    }
  }

  void _filterProducts() {
    setState(() {
      _filteredProducts = _products.where((product) {
        final matchesSearch = product.name.toLowerCase().contains(_searchQuery.toLowerCase());
        final matchesCategory = _selectedCategory == 'All' || product.category == _selectedCategory;
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        _buildSearchAndFilters(),
        Expanded(
          child: _isLoading ? _buildLoading() : _buildProductGrid(),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.pink.withValues(alpha: 0.3), AppTheme.purple.withValues(alpha: 0.3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Products Management',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          ElevatedButton.icon(
            onPressed: () => _showProductDialog(),
            icon: const Icon(Icons.add),
            label: const Text('Add Product'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.pink,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: (value) {
                setState(() => _searchQuery = value);
                _filterProducts();
              },
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.1),
              ),
            ),
          ),
          const SizedBox(width: 16),
          DropdownButton<String>(
            value: _selectedCategory,
            dropdownColor: AppTheme.cardDark,
            items: ['All', 'Rings', 'Earrings', 'Chains', 'Other']
                .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                .toList(),
            onChanged: (value) {
              setState(() => _selectedCategory = value!);
              _filterProducts();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return Center(child: CircularProgressIndicator(color: AppTheme.pink));
  }

  Widget _buildProductGrid() {
    if (_filteredProducts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, size: 64, color: Colors.white.withValues(alpha: 0.3)),
            const SizedBox(height: 16),
            Text('No products found', style: TextStyle(color: Colors.white.withValues(alpha: 0.6))),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Card(
        color: AppTheme.cardDark,
        elevation: 8,
        shadowColor: AppTheme.pink.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(
                AppTheme.pink.withValues(alpha: 0.1),
              ),
              dataRowColor: WidgetStateProperty.resolveWith<Color?>(
                (Set<WidgetState> states) {
                  if (states.contains(WidgetState.selected)) {
                    return AppTheme.cyan.withValues(alpha: 0.1);
                  }
                  return null;
                },
              ),
              border: TableBorder(
                horizontalInside: BorderSide(
                  color: Colors.white.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              columns: const [
                DataColumn(
                  label: Text(
                    'Image',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Product Name',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Product Type',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'RAND Price',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'USD Price',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Status',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Actions',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Collection',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
              rows: _filteredProducts.map((product) => DataRow(
                cells: [
                  DataCell(
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white.withValues(alpha: 0.05),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.1),
                          width: 1,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: product.images.isNotEmpty
                            ? Image.network(
                                product.images.first,
                                fit: BoxFit.cover,
                                width: 60,
                                height: 60,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        value: loadingProgress.expectedTotalBytes != null
                                            ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                            : null,
                                        strokeWidth: 2,
                                        color: AppTheme.cyan,
                                      ),
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  debugPrint('❌ Image load error for ${product.name}: $error');
                                  return Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.broken_image, size: 24, color: Colors.red.withValues(alpha: 0.5)),
                                        const SizedBox(height: 2),
                                        Text('Error', style: TextStyle(fontSize: 8, color: Colors.red.withValues(alpha: 0.5))),
                                      ],
                                    ),
                                  );
                                },
                              )
                            : Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add_photo_alternate, size: 24, color: Colors.white.withValues(alpha: 0.3)),
                                    const SizedBox(height: 2),
                                    Text('No Image', style: TextStyle(fontSize: 8, color: Colors.white.withValues(alpha: 0.3))),
                                  ],
                                ),
                              ),
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      product.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getProductTypeColor(product.productType).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _getProductTypeColor(product.productType),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        product.productType,
                        style: TextStyle(
                          color: _getProductTypeColor(product.productType),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      'R${product.basePriceZar.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: AppTheme.cyan,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      '\$${product.basePriceUsd.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 14,
                      ),
                    ),
                  ),
                  DataCell(
                    Tooltip(
                      message: product.status == 'active' ? 'Published' : 'Draft',
                      child: Icon(
                        product.status == 'active'
                            ? Icons.check_circle
                            : Icons.edit_note,
                        color: product.status == 'active'
                            ? Colors.green
                            : Colors.orange,
                        size: 20,
                      ),
                    ),
                  ),
                  DataCell(
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, size: 18),
                          onPressed: () => _showProductDialog(product: product),
                          color: AppTheme.cyan,
                          tooltip: 'Edit Product',
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.delete, size: 18),
                          onPressed: () => _deleteProduct(product),
                          color: Colors.red,
                          tooltip: 'Delete Product',
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ),
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getCategoryColor(product.category).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _getCategoryColor(product.category),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        product.category,
                        style: TextStyle(
                          color: _getCategoryColor(product.category),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              )).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'rings':
        return AppTheme.pink;
      case 'earrings':
        return AppTheme.cyan;
      case 'chains':
        return AppTheme.purple;
      default:
        return Colors.orange;
    }
  }

  Color _getProductTypeColor(String productType) {
    switch (productType.toLowerCase()) {
      case 'ring':
        return AppTheme.pink;
      case 'earrings':
        return AppTheme.cyan;
      case 'necklace':
        return AppTheme.purple;
      case 'bracelet':
        return Colors.orange;
      case 'pendant':
        return Colors.teal;
      case 'brooch':
        return Colors.indigo;
      case 'cufflinks':
        return Colors.brown;
      default:
        return Colors.grey;
    }
  }

  void _showProductDialog({Product? product}) async {
    if (product != null) {
      debugPrint('📝 Opening edit screen for: ${product.name}');
      debugPrint('   ID: ${product.id}');
      debugPrint('   Category: ${product.category}');
      debugPrint('   Product Type: ${product.productType}');
      debugPrint('   Status: ${product.status}');
      debugPrint('   Base Price ZAR: ${product.basePriceZar}');
      debugPrint('   Stock: ${product.stockQuantity}');
      debugPrint('   Materials: ${product.materials.length}');
      debugPrint('   Colors: ${product.colors.length}');
      debugPrint('   Tags: ${product.tags.length}');
      debugPrint('   Images: ${product.images.length}');
    } else {
      debugPrint('➕ Opening create new product screen');
    }

    // Navigate to ProductCreationScreen for both create and edit
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductCreationScreen(product: product),
      ),
    );

    if (result != null && result is Product) {
      try {
        if (product == null) {
          // Create new product
          await _repository.createProduct(result);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Product created successfully!')),
            );
          }
        } else {
          // Update existing product
          await _repository.updateProduct(product.id!, result);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Product updated successfully!')),
            );
          }
        }
        _loadProducts();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }

  Future<void> _deleteProduct(Product product) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: Text('Are you sure you want to delete ${product.name}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _repository.deleteProduct(product.id!);
        _loadProducts();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting product: $e')),
          );
        }
      }
    }
  }
}

class ProductFormDialog extends StatefulWidget {
  final Product? product;
  final Function(Product) onSave;

  const ProductFormDialog({super.key, this.product, required this.onSave});

  @override
  State<ProductFormDialog> createState() => _ProductFormDialogState();
}

class _ProductFormDialogState extends State<ProductFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _stockController;
  String _category = 'Rings';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product?.name ?? '');
    _descriptionController = TextEditingController(text: widget.product?.description ?? '');
    _priceController = TextEditingController(text: widget.product?.basePriceZar.toString() ?? '');
    _stockController = TextEditingController(text: widget.product?.stockQuantity.toString() ?? '0');
    _category = widget.product?.category ?? 'Rings';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppTheme.cardDark,
      title: Text(widget.product == null ? 'Add Product' : 'Edit Product', style: const TextStyle(color: Colors.white)),
      content: SizedBox(
        width: 500,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Product Name'),
                  validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _category,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: ['Rings', 'Earrings', 'Chains', 'Other']
                      .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                      .toList(),
                  onChanged: (value) => setState(() => _category = value!),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(labelText: 'Price (ZAR)'),
                  keyboardType: TextInputType.number,
                  validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _stockController,
                  decoration: const InputDecoration(labelText: 'Stock Quantity'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: _save,
          style: ElevatedButton.styleFrom(backgroundColor: AppTheme.pink),
          child: const Text('Save'),
        ),
      ],
    );
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final price = double.parse(_priceController.text);
      final product = Product(
        id: widget.product?.id,
        name: _nameController.text,
        category: _category,
        productType: widget.product?.productType ?? 'other', // Default to 'other' if not set
        description: _descriptionController.text,
        basePriceZar: price,
        basePriceUsd: price / 18,
        sellingPriceZar: price,
        sellingPriceUsd: price / 18,
        stockQuantity: int.parse(_stockController.text),
        status: 'active',
        urlSlug: widget.product?.urlSlug ?? _nameController.text.toLowerCase().replaceAll(' ', '-'),
        sku: widget.product?.sku ?? 'SMV-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
        madeBy: widget.product?.madeBy ?? '',
        materials: widget.product?.materials ?? [],
      );
      widget.onSave(product);
    }
  }
}
