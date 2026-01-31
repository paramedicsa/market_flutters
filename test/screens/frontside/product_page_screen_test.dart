import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:market_flutter/data/models/product_model.dart';
import 'package:market_flutter/screens/frontside/product_page_screen.dart';

void main() {
  group('ProductPageScreen', () {
    testWidgets('renders product with chain options as Map', (WidgetTester tester) async {
      // Create a product with chain options as Map
      final product = Product(
        name: 'Test Necklace',
        category: 'Necklaces',
        productType: 'necklace',
        description: 'A beautiful necklace',
        basePriceZar: 100.0,
        basePriceUsd: 10.0,
        sellingPriceZar: 150.0,
        sellingPriceUsd: 15.0,
        urlSlug: 'test-necklace',
        sku: 'TEST001',
        madeBy: 'Test Artist',
        materials: ['Silver'],
        chainOptions: {
          'Princess (45 cm)': true,
          'Choker (40 cm)': true,
          'Opera (75 cm)': false, // This should NOT appear
        },
        leatherOption: true,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: ProductPageScreen(product: product),
        ),
      );

      // Verify product name is displayed
      expect(find.text('Test Necklace'), findsWidgets);

      // Verify price is displayed
      expect(find.textContaining('R 150.00'), findsOneWidget);

      // Verify description is displayed
      expect(find.text('A beautiful necklace'), findsOneWidget);

      // Verify consolidated header appears once
      expect(find.text('CHOOSE YOUR OPTION'), findsOneWidget);

      // Verify chain options are displayed (only true values)
      expect(find.textContaining('Princess (45 cm)'), findsOneWidget);
      expect(find.textContaining('Choker (40 cm)'), findsOneWidget);
      
      // Verify false option is NOT displayed
      expect(find.textContaining('Opera (75 cm)'), findsNothing);

      // Verify leather option is displayed
      expect(find.textContaining('Leather Cord (Princess – 45 cm)'), findsOneWidget);

      // Verify ADD TO CART button is displayed
      expect(find.text('ADD TO CART'), findsOneWidget);
    });

    testWidgets('renders product with earring materials as Map', (WidgetTester tester) async {
      final product = Product(
        name: 'Test Earrings',
        category: 'Earrings',
        productType: 'earrings',
        description: 'Beautiful earrings',
        basePriceZar: 80.0,
        basePriceUsd: 8.0,
        sellingPriceZar: 120.0,
        sellingPriceUsd: 12.0,
        urlSlug: 'test-earrings',
        sku: 'TEST002',
        madeBy: 'Test Artist',
        materials: ['Gold'],
        earringMaterials: {
          'Gold Plated': true,
          'Silver Plated': false,
          'Rose Gold': true,
        },
      );

      await tester.pumpWidget(
        MaterialApp(
          home: ProductPageScreen(product: product),
        ),
      );

      // Verify consolidated header appears
      expect(find.text('CHOOSE YOUR OPTION'), findsOneWidget);

      // Verify earring materials are displayed (only true values)
      expect(find.textContaining('Gold Plated'), findsOneWidget);
      expect(find.textContaining('Rose Gold'), findsOneWidget);
      
      // Verify false option is NOT displayed
      expect(find.textContaining('Silver Plated'), findsNothing);
    });

    testWidgets('ADD TO CART button is disabled when no option selected', (WidgetTester tester) async {
      final product = Product(
        name: 'Test Product',
        category: 'Test',
        productType: 'test',
        description: 'Test description',
        basePriceZar: 100.0,
        basePriceUsd: 10.0,
        sellingPriceZar: 150.0,
        sellingPriceUsd: 15.0,
        urlSlug: 'test-product',
        sku: 'TEST003',
        madeBy: 'Test Artist',
        materials: ['Test'],
        chainOptions: {
          'Option 1': true,
          'Option 2': true,
        },
      );

      await tester.pumpWidget(
        MaterialApp(
          home: ProductPageScreen(product: product),
        ),
      );

      // Find the ADD TO CART button
      final button = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'ADD TO CART'),
      );

      // Button should be disabled (onPressed is null)
      expect(button.onPressed, isNull);
    });

    testWidgets('ADD TO CART button is enabled when option is selected', (WidgetTester tester) async {
      final product = Product(
        name: 'Test Product',
        category: 'Test',
        productType: 'test',
        description: 'Test description',
        basePriceZar: 100.0,
        basePriceUsd: 10.0,
        sellingPriceZar: 150.0,
        sellingPriceUsd: 15.0,
        urlSlug: 'test-product',
        sku: 'TEST004',
        madeBy: 'Test Artist',
        materials: ['Test'],
        chainOptions: {
          'Option 1': true,
          'Option 2': true,
        },
      );

      await tester.pumpWidget(
        MaterialApp(
          home: ProductPageScreen(product: product),
        ),
      );

      // Tap on the first option
      await tester.tap(find.textContaining('Option 1'));
      await tester.pumpAndSettle();

      // Find the ADD TO CART button
      final button = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'ADD TO CART'),
      );

      // Button should now be enabled
      expect(button.onPressed, isNotNull);
    });

    testWidgets('renders product without options', (WidgetTester tester) async {
      final product = Product(
        name: 'Simple Product',
        category: 'Test',
        productType: 'test',
        description: 'Simple product without options',
        basePriceZar: 50.0,
        basePriceUsd: 5.0,
        sellingPriceZar: 75.0,
        sellingPriceUsd: 7.5,
        urlSlug: 'simple-product',
        sku: 'TEST005',
        madeBy: 'Test Artist',
        materials: ['Test'],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: ProductPageScreen(product: product),
        ),
      );

      // Verify product name is displayed
      expect(find.text('Simple Product'), findsWidgets);

      // Verify options section is NOT displayed
      expect(find.text('CHOOSE YOUR OPTION'), findsNothing);

      // Find the ADD TO CART button
      final button = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'ADD TO CART'),
      );

      // Button should be enabled since no options to select
      expect(button.onPressed, isNotNull);
    });

    testWidgets('displays styling tips when available', (WidgetTester tester) async {
      final product = Product(
        name: 'Test Product',
        category: 'Test',
        productType: 'test',
        description: 'Test description',
        styling: 'Pair with casual outfits for a chic look.',
        basePriceZar: 100.0,
        basePriceUsd: 10.0,
        sellingPriceZar: 150.0,
        sellingPriceUsd: 15.0,
        urlSlug: 'test-product',
        sku: 'TEST006',
        madeBy: 'Test Artist',
        materials: ['Test'],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: ProductPageScreen(product: product),
        ),
      );

      // Verify styling tips header is displayed
      expect(find.text('Styling Tips'), findsOneWidget);

      // Verify styling content is displayed
      expect(find.text('Pair with casual outfits for a chic look.'), findsOneWidget);
    });
  });
}
