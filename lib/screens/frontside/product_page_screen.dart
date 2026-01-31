import 'package:flutter/material.dart';
import '../../data/models/product_model.dart';
import '../../theme/app_theme.dart';

class ProductPageScreen extends StatefulWidget {
  final Product product;

  const ProductPageScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductPageScreen> createState() => _ProductPageScreenState();
}

class _ProductPageScreenState extends State<ProductPageScreen> {
  String? _selectedOption;
  int _currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image Gallery
            _buildImageGallery(),
            
            const SizedBox(height: 16),
            
            // Product Name
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                widget.product.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Price
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'R ${widget.product.sellingPriceZar.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.shockingPink,
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                widget.product.description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Styling Tips Card (if available)
            if (widget.product.styling != null && widget.product.styling!.isNotEmpty)
              _buildStylingTipsCard(),
            
            // Consolidated Options Section - UNDER the Styling Tips card
            if (_hasOptions())
              _buildOptionsSection(),
            
            const SizedBox(height: 24),
            
            // Add to Cart Button
            _buildAddToCartButton(),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildImageGallery() {
    if (widget.product.images.isEmpty) {
      return Container(
        height: 300,
        color: AppTheme.cardDark,
        child: const Center(
          child: Icon(Icons.image, size: 64, color: Colors.white30),
        ),
      );
    }

    return Column(
      children: [
        SizedBox(
          height: 300,
          child: PageView.builder(
            itemCount: widget.product.images.length,
            onPageChanged: (index) {
              setState(() {
                _currentImageIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Image.network(
                widget.product.images[index],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppTheme.cardDark,
                    child: const Icon(Icons.broken_image, size: 64, color: Colors.white30),
                  );
                },
              );
            },
          ),
        ),
        if (widget.product.images.length > 1)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.product.images.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentImageIndex == index
                        ? AppTheme.shockingPink
                        : Colors.white30,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildStylingTipsCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        color: AppTheme.cardDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(
            color: AppTheme.cardBorder,
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Styling Tips',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.shockingPink,
                  fontFamily: 'CherryCreamSoda',
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.product.styling!,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _hasOptions() {
    final activeOptions = _getActiveOptions();
    return activeOptions.isNotEmpty;
  }

  List<String> _getActiveOptions() {
    List<String> activeOptions = [];

    // Extract chain options from Map format
    if (widget.product.chainOptions != null) {
      if (widget.product.chainOptions is Map) {
        // Extract only keys that are TRUE in the database
        activeOptions.addAll(
          (widget.product.chainOptions as Map).entries
              .where((e) => e.value == true)
              .map((e) => e.key.toString()),
        );
      } else if (widget.product.chainOptions is List) {
        activeOptions.addAll(
          List<String>.from(widget.product.chainOptions as List),
        );
      }
    }

    // Add leather option if enabled
    if (widget.product.leatherOption == true) {
      activeOptions.add('Leather Cord (Princess – 45 cm)');
    }

    // Extract earring materials from Map format
    if (widget.product.earringMaterials != null) {
      if (widget.product.earringMaterials is Map) {
        // Extract only keys that are TRUE in the database
        activeOptions.addAll(
          (widget.product.earringMaterials as Map).entries
              .where((e) => e.value == true)
              .map((e) => e.key.toString()),
        );
      } else if (widget.product.earringMaterials is List) {
        activeOptions.addAll(
          List<String>.from(widget.product.earringMaterials as List),
        );
      }
    }

    return activeOptions;
  }

  Widget _buildOptionsSection() {
    final activeOptions = _getActiveOptions();

    if (activeOptions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Single consolidated header
          Text(
            'CHOOSE YOUR OPTION',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.shockingPink,
              fontFamily: 'CherryCreamSoda',
            ),
          ),
          const SizedBox(height: 16),
          // Radio button style options
          ...activeOptions.map((option) => _buildOptionItem(option)),
        ],
      ),
    );
  }

  Widget _buildOptionItem(String option) {
    final isSelected = _selectedOption == option;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedOption = option;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.cardDark,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppTheme.shockingPink : AppTheme.cardBorder,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: isSelected ? AppTheme.shockingPink : Colors.white30,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                option,
                style: TextStyle(
                  fontSize: 14,
                  color: isSelected ? Colors.white : Colors.white70,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddToCartButton() {
    final hasOptions = _hasOptions();
    final isEnabled = !hasOptions || _selectedOption != null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: isEnabled ? _onAddToCart : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: isEnabled ? AppTheme.shockingPink : Colors.grey,
            foregroundColor: Colors.white,
            elevation: isEnabled ? 8 : 0,
            shadowColor: isEnabled ? AppTheme.shockingPink.withValues(alpha: 0.5) : null,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            disabledBackgroundColor: Colors.grey,
          ),
          child: const Text(
            'ADD TO CART',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  void _onAddToCart() {
    if (_hasOptions() && _selectedOption == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an option'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // TODO: Implement add to cart functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _selectedOption != null
              ? 'Added to cart: ${widget.product.name} - $_selectedOption'
              : 'Added to cart: ${widget.product.name}',
        ),
        backgroundColor: AppTheme.shockingPink,
      ),
    );
  }
}
