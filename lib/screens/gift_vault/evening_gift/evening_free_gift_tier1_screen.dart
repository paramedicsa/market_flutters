import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import '../../../data/models/product_model.dart';

class EveningFreeGiftTier1Screen extends StatefulWidget {
  final String matrixType;
  final Function(List<Product>) onConfirmSelection;

  const EveningFreeGiftTier1Screen({
    super.key,
    required this.matrixType,
    required this.onConfirmSelection,
  });

  @override
  State<EveningFreeGiftTier1Screen> createState() => _EveningFreeGiftTier1ScreenState();
}

class _EveningFreeGiftTier1ScreenState extends State<EveningFreeGiftTier1Screen> {
  final List<Product> _selectedProducts = [];
  final int _maxSelection = 2;

  // Sample products for demonstration
  final List<Product> _sampleProducts = [
    Product(
      id: '1',
      name: 'Rainbow Necklace',
      category: 'Evening Gift',
      productType: 'necklace',
      description: 'Beautiful rainbow gradient necklace',
      basePriceZar: 299.0,
      basePriceUsd: 20.0,
      sellingPriceZar: 299.0,
      sellingPriceUsd: 20.0,
      urlSlug: 'rainbow-necklace',
      sku: 'RN001',
      madeBy: 'Artist',
      materials: ['Sterling Silver'],
      images: [],
    ),
    Product(
      id: '2',
      name: 'Sunset Earrings',
      category: 'Evening Gift',
      productType: 'earrings',
      description: 'Elegant evening earrings',
      basePriceZar: 199.0,
      basePriceUsd: 15.0,
      sellingPriceZar: 199.0,
      sellingPriceUsd: 15.0,
      urlSlug: 'sunset-earrings',
      sku: 'SE001',
      madeBy: 'Artist',
      materials: ['Gold Plated'],
      images: [],
    ),
    Product(
      id: '3',
      name: 'Twilight Ring',
      category: 'Evening Gift',
      productType: 'ring',
      description: 'Mystical twilight ring',
      basePriceZar: 349.0,
      basePriceUsd: 25.0,
      sellingPriceZar: 349.0,
      sellingPriceUsd: 25.0,
      urlSlug: 'twilight-ring',
      sku: 'TR001',
      madeBy: 'Artist',
      materials: ['Rose Gold'],
      images: [],
    ),
    Product(
      id: '4',
      name: 'Aurora Bracelet',
      category: 'Evening Gift',
      productType: 'bracelet',
      description: 'Shimmering aurora bracelet',
      basePriceZar: 259.0,
      basePriceUsd: 18.0,
      sellingPriceZar: 259.0,
      sellingPriceUsd: 18.0,
      urlSlug: 'aurora-bracelet',
      sku: 'AB001',
      madeBy: 'Artist',
      materials: ['Silver'],
      images: [],
    ),
  ];

  void _toggleSelection(Product product) {
    setState(() {
      if (_selectedProducts.contains(product)) {
        _selectedProducts.remove(product);
      } else if (_selectedProducts.length < _maxSelection) {
        _selectedProducts.add(product);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header with Rainbow Gradient Text
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Rainbow Gradient applied to "Evening Gift Vault" text
                  ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return ui.Gradient.linear(
                        Offset(0, bounds.height / 2),
                        Offset(bounds.width, bounds.height / 2),
                        [
                          const Color(0xFFFF0080), // Pink
                          const Color(0xFF9D00FF), // Purple
                          const Color(0xFF0080FF), // Blue
                          const Color(0xFF00FF80), // Green
                          const Color(0xFFFFFF00), // Yellow
                        ],
                        [0.0, 0.25, 0.5, 0.75, 1.0],
                      );
                    },
                    child: const Text(
                      'Evening Gift Vault',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // This will be masked by the gradient
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Select ${_maxSelection} items',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${_selectedProducts.length}/$_maxSelection selected',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFFFF0080),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Product Grid
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: _sampleProducts.length,
                itemBuilder: (context, index) {
                  final product = _sampleProducts[index];
                  final isSelected = _selectedProducts.contains(product);
                  final canSelect = _selectedProducts.length < _maxSelection || isSelected;

                  return GestureDetector(
                    onTap: canSelect ? () => _toggleSelection(product) : null,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFFFF0080)
                              : Colors.white.withOpacity(0.2),
                          width: isSelected ? 3 : 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Product Image Placeholder
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[800],
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12),
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  _getIconForProductType(product.productType),
                                  size: 48,
                                  color: isSelected
                                      ? const Color(0xFFFF0080)
                                      : Colors.white.withOpacity(0.5),
                                ),
                              ),
                            ),
                          ),
                          // Product Info
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'R${product.sellingPriceZar.toStringAsFixed(0)}',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: 12,
                                  ),
                                ),
                                if (isSelected) ...[
                                  const SizedBox(height: 4),
                                  const Row(
                                    children: [
                                      Icon(
                                        Icons.check_circle,
                                        color: Color(0xFFFF0080),
                                        size: 16,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        'Selected',
                                        style: TextStyle(
                                          color: Color(0xFFFF0080),
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Confirm Button
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _selectedProducts.length == _maxSelection
                      ? () => widget.onConfirmSelection(_selectedProducts)
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF0080),
                    disabledBackgroundColor: Colors.grey[800],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  child: Text(
                    _selectedProducts.length == _maxSelection
                        ? 'Confirm Selection'
                        : 'Select ${_maxSelection - _selectedProducts.length} more',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForProductType(String type) {
    switch (type.toLowerCase()) {
      case 'necklace':
        return Icons.style;
      case 'earrings':
        return Icons.earbuds;
      case 'ring':
        return Icons.radio_button_unchecked;
      case 'bracelet':
        return Icons.watch;
      default:
        return Icons.diamond;
    }
  }
}
