class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String? imageUrl;
  final String? funnelTier; // 'starter', 'premium', 'bonus'
  final String currency; // 'ZAR' or 'USD'
  final bool isAvailable;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.imageUrl,
    this.funnelTier,
    this.currency = 'ZAR',
    this.isAvailable = true,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['image_url'] as String?,
      funnelTier: json['funnel_tier'] as String?,
      currency: json['currency'] as String? ?? 'ZAR',
      isAvailable: json['is_available'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'image_url': imageUrl,
      'funnel_tier': funnelTier,
      'currency': currency,
      'is_available': isAvailable,
    };
  }
}
