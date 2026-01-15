import 'dart:typed_data';
import '../models/product_model.dart';
import '../supabase/supabase_config.dart';

class ProductRepository {
  final _client = SupabaseConfig.client;
  final String _tableName = 'products';

  // Get all products
  Future<List<Product>> getAllProducts() async {
    try {
      final response = await _client.from(_tableName).select().order('created_at', ascending: false);
      return (response as List).map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch products: $e');
    }
  }

  // Get products by category
  Future<List<Product>> getProductsByCategory(String category) async {
    try {
      final response = await _client.from(_tableName).select().eq('category', category);
      return (response as List).map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch products by category: $e');
    }
  }

  // Get single product
  Future<Product?> getProductById(String id) async {
    try {
      final response = await _client.from(_tableName).select().eq('id', id).single();
      return Product.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  // Create product
  Future<Product> createProduct(Product product) async {
    try {
      final data = product.toJson();
      data.remove('id');
      data['created_at'] = DateTime.now().toIso8601String();
      data['updated_at'] = DateTime.now().toIso8601String();

      final response = await _client.from(_tableName).insert(data).select().single();
      return Product.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create product: $e');
    }
  }

  // Update product
  Future<Product> updateProduct(String id, Product product) async {
    try {
      final data = product.toJson();
      data['updated_at'] = DateTime.now().toIso8601String();

      final response = await _client.from(_tableName).update(data).eq('id', id).select().single();
      return Product.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }

  // Delete product
  Future<void> deleteProduct(String id) async {
    try {
      await _client.from(_tableName).delete().eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }

  // Search products
  Future<List<Product>> searchProducts(String query) async {
    try {
      final response = await _client.from(_tableName).select().ilike('name', '%$query%');
      return (response as List).map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to search products: $e');
    }
  }

  // Upload image to storage
  Future<String> uploadProductImage(String fileName, List<int> fileBytes) async {
    try {
      final path = 'products/$fileName';
      final uint8List = Uint8List.fromList(fileBytes);
      await _client.storage.from('product-images').uploadBinary(path, uint8List);
      return _client.storage.from('product-images').getPublicUrl(path);
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }
}

