import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// Example screen demonstrating correct dropdown syntax for funnel_tier selection
class GiftVaultScreen extends StatefulWidget {
  const GiftVaultScreen({super.key});

  @override
  State<GiftVaultScreen> createState() => _GiftVaultScreenState();
}

class _GiftVaultScreenState extends State<GiftVaultScreen> {
  // Example product data
  final List<Map<String, dynamic>> products = [
    {'name': 'Product 1', 'funnel_tier': 'none'},
    {'name': 'Product 2', 'funnel_tier': 'starter'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.black,
      appBar: AppBar(
        title: const Text('Gift Vault Management'),
        backgroundColor: AppTheme.cardDark,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Card(
            color: AppTheme.cardDark,
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name'] ?? 'Unknown',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: product['funnel_tier'] ?? 'none',
                    dropdownColor: AppTheme.cardDark,
                    style: const TextStyle(color: Colors.white, fontFamily: 'IndieFlower'),
                    decoration: InputDecoration(
                      labelText: 'Funnel Tier',
                      labelStyle: const TextStyle(color: Colors.white70),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.white30),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.white30),
                      ),
                    ),
                    items: [
                      const DropdownMenuItem(value: 'none', child: Text('None')),
                      const DropdownMenuItem(value: 'starter', child: Text('Starter (R100/\$20)')),
                      const DropdownMenuItem(value: 'premium', child: Text('Premium (R350+)')),
                      const DropdownMenuItem(value: 'bonus', child: Text('Bonus (Referral)')),
                    ], // <-- This closing bracket was missing in the original code
                    onChanged: (value) {
                      setState(() {
                        products[index] = {...product, 'funnel_tier': value};
                      });
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
