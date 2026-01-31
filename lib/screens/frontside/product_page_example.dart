import 'package:flutter/material.dart';
import 'package:market_flutter/data/models/product_model.dart';
import 'package:market_flutter/screens/frontside/product_page_screen.dart';
import 'package:market_flutter/theme/app_theme.dart';

/// Example demonstrating how to use ProductPageScreen with different product configurations
void main() {
  runApp(const ProductPageExampleApp());
}

class ProductPageExampleApp extends StatelessWidget {
  const ProductPageExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Page Example',
      theme: AppTheme.darkTheme,
      home: const ProductListExample(),
    );
  }
}

class ProductListExample extends StatelessWidget {
  const ProductListExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Examples'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildExampleCard(
            context,
            'Necklace with Chain Options',
            'Demonstrates Map-based chain options and leather option',
            _createNecklaceExample(),
          ),
          const SizedBox(height: 16),
          _buildExampleCard(
            context,
            'Earrings with Material Options',
            'Demonstrates Map-based earring materials',
            _createEarringsExample(),
          ),
          const SizedBox(height: 16),
          _buildExampleCard(
            context,
            'Simple Product (No Options)',
            'Product without any options',
            _createSimpleProductExample(),
          ),
        ],
      ),
    );
  }

  Widget _buildExampleCard(
    BuildContext context,
    String title,
    String description,
    Product product,
  ) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(description),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductPageScreen(product: product),
            ),
          );
        },
      ),
    );
  }

  Product _createNecklaceExample() {
    return Product(
      name: 'Elegant Silver Necklace',
      category: 'Necklaces',
      productType: 'necklace',
      description: 'A beautiful handcrafted silver necklace with intricate design. Perfect for both casual and formal occasions.',
      styling: 'Style Tip: This necklace pairs beautifully with a simple black dress or white blouse. Layer it with shorter chains for a trendy look.',
      basePriceZar: 500.0,
      basePriceUsd: 50.0,
      sellingPriceZar: 750.0,
      sellingPriceUsd: 75.0,
      urlSlug: 'elegant-silver-necklace',
      sku: 'NEC001',
      madeBy: 'Artisan Jewelers',
      materials: ['Sterling Silver', 'Cubic Zirconia'],
      images: [
        'https://via.placeholder.com/400x400/FF0080/FFFFFF?text=Necklace+Front',
        'https://via.placeholder.com/400x400/00FFFF/000000?text=Necklace+Side',
      ],
      // Map format - only true values will be shown
      chainOptions: {
        'Choker (40 cm)': true,
        'Princess (45 cm)': true,
        'Matinee (55 cm)': false, // This won't appear
        'Opera (75 cm)': true,
      },
      leatherOption: true, // Will add "Leather Cord (Princess – 45 cm)"
      stockQuantity: 15,
    );
  }

  Product _createEarringsExample() {
    return Product(
      name: 'Dazzling Drop Earrings',
      category: 'Earrings',
      productType: 'earrings',
      description: 'Stunning drop earrings that catch the light beautifully. Handmade with attention to detail.',
      styling: 'Style Tip: These earrings are perfect for evening events. Pair with an updo hairstyle to showcase their beauty.',
      basePriceZar: 300.0,
      basePriceUsd: 30.0,
      sellingPriceZar: 450.0,
      sellingPriceUsd: 45.0,
      urlSlug: 'dazzling-drop-earrings',
      sku: 'EAR001',
      madeBy: 'Sparkle Creators',
      materials: ['Gold Plated', 'Crystal'],
      images: [
        'https://via.placeholder.com/400x400/9D00FF/FFFFFF?text=Earrings',
      ],
      // Map format - only true values will be shown
      earringMaterials: {
        'Gold Plated': true,
        'Silver Plated': false, // This won't appear
        'Rose Gold Plated': true,
        'White Gold Plated': true,
      },
      stockQuantity: 20,
    );
  }

  Product _createSimpleProductExample() {
    return Product(
      name: 'Classic Ring',
      category: 'Rings',
      productType: 'ring',
      description: 'A timeless classic ring design that never goes out of style.',
      styling: 'Style Tip: Stack with other rings for a modern look, or wear alone for understated elegance.',
      basePriceZar: 200.0,
      basePriceUsd: 20.0,
      sellingPriceZar: 300.0,
      sellingPriceUsd: 30.0,
      urlSlug: 'classic-ring',
      sku: 'RNG001',
      madeBy: 'Traditional Crafts',
      materials: ['Silver'],
      images: [
        'https://via.placeholder.com/400x400/FF0080/FFFFFF?text=Ring',
      ],
      // No options - button will be immediately enabled
      stockQuantity: 10,
    );
  }
}
