class Product {
  final String? id;
  final String name;
  final String category; // Collection name
  final String productType; // Product type like "ring", "earrings", etc.
  final String description;
  final String? styling;
  final double basePriceZar;
  final double basePriceUsd;
  final double sellingPriceZar;
  final double sellingPriceUsd;
  final double? memberPriceZar;
  final double? memberPriceUsd;
  final double? promoPriceZar;
  final double? promoPriceUsd;
  final double? costPrice;
  final String costCurrency;
  final double? profitZar; // Profit in USD when sold in ZAR
  final double? profitUsd; // Profit in USD when sold in USD
  final double? memberProfitZar; // Profit in USD for member price when sold in ZAR
  final double? memberProfitUsd; // Profit in USD for member price when sold in USD
  final int stockQuantity;
  final int? itemsSold; // Number of items sold
  final List<String> images;
  final bool isFeatured;
  final bool isNewArrival;
  final bool isBestSeller;
  final bool isVaultItem;
  final bool allowGiftWrap;
  final bool allowGiftMessage;
  final String status;
  final String urlSlug;
  final String sku;
  final String madeBy;
  final List<String> materials;
  final List<String> colors;
  final List<String> tags;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Inventory options
  final Map<String, bool>? earringMaterials;
  final Map<String, int>? ringSizes;
  final Map<String, bool>? chainOptions;
  final bool? leatherOption;
  final bool? enableMaterialCustomization;
  final bool? enableMetalChain;

  // Promotion fields
  final bool? isPromotionActive;
  final DateTime? promotionStart;
  final DateTime? promotionEnd;
  final String? affiliateUrl;

  Product({
    this.id,
    required this.name,
    required this.category,
    required this.productType,
    required this.description,
    this.styling,
    required this.basePriceZar,
    required this.basePriceUsd,
    required this.sellingPriceZar,
    required this.sellingPriceUsd,
    this.memberPriceZar,
    this.memberPriceUsd,
    this.promoPriceZar,
    this.promoPriceUsd,
    this.costPrice,
    this.costCurrency = 'ZAR',
    this.profitZar,
    this.profitUsd,
    this.memberProfitZar,
    this.memberProfitUsd,
    this.stockQuantity = 0,
    this.itemsSold,
    this.images = const [],
    this.isFeatured = false,
    this.isNewArrival = false,
    this.isBestSeller = false,
    this.isVaultItem = false,
    this.allowGiftWrap = false,
    this.allowGiftMessage = false,
    this.status = 'draft',
    required this.urlSlug,
    required this.sku,
    required this.madeBy,
    required this.materials,
    this.colors = const [],
    this.tags = const [],
    this.createdAt,
    this.updatedAt,
    this.earringMaterials,
    this.ringSizes,
    this.chainOptions,
    this.leatherOption,
    this.enableMaterialCustomization,
    this.enableMetalChain,
    this.isPromotionActive,
    this.promotionStart,
    this.promotionEnd,
    this.affiliateUrl,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category,
        'product_type': productType,
        'description': description,
        'styling': styling,
        'base_price_zar': basePriceZar,
        'base_price_usd': basePriceUsd,
        'selling_price_zar': sellingPriceZar,
        'selling_price_usd': sellingPriceUsd,
        'member_price_zar': memberPriceZar,
        'member_price_usd': memberPriceUsd,
        'promo_price_zar': promoPriceZar,
        'promo_price_usd': promoPriceUsd,
        'cost_price': costPrice,
        'cost_currency': costCurrency,
        'profit_zar': profitZar,
        'profit_usd': profitUsd,
        'member_profit_zar': memberProfitZar,
        'member_profit_usd': memberProfitUsd,
        'stock_quantity': stockQuantity,
        'items_sold': itemsSold,
        'images': images,
        'is_featured': isFeatured,
        'is_new_arrival': isNewArrival,
        'is_best_seller': isBestSeller,
        'is_vault_item': isVaultItem,
        'allow_gift_wrap': allowGiftWrap,
        'allow_gift_message': allowGiftMessage,
        'status': status,
        'url_slug': urlSlug,
        'sku': sku,
        'made_by': madeBy,
        'materials': materials,
        'colors': colors,
        'tags': tags,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
        'earring_materials': earringMaterials,
        'ring_sizes': ringSizes,
        'chain_options': chainOptions,
        'leather_option': leatherOption,
        'enable_material_customization': enableMaterialCustomization,
        'enable_metal_chain': enableMetalChain,
        'is_promotion_active': isPromotionActive,
        'promotion_start': promotionStart?.toIso8601String(),
        'promotion_end': promotionEnd?.toIso8601String(),
        'affiliate_url': affiliateUrl,
      };

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'],
        name: json['name'],
        category: json['category'],
        productType: json['product_type'],
        description: json['description'] ?? '',
        styling: json['styling'],
        basePriceZar: (json['base_price_zar'] ?? 0).toDouble(),
        basePriceUsd: (json['base_price_usd'] ?? 0).toDouble(),
        sellingPriceZar: (json['selling_price_zar'] ?? 0).toDouble(),
        sellingPriceUsd: (json['selling_price_usd'] ?? 0).toDouble(),
        memberPriceZar: json['member_price_zar']?.toDouble(),
        memberPriceUsd: json['member_price_usd']?.toDouble(),
        promoPriceZar: json['promo_price_zar']?.toDouble(),
        promoPriceUsd: json['promo_price_usd']?.toDouble(),
        costPrice: json['cost_price']?.toDouble(),
        costCurrency: json['cost_currency'] ?? 'ZAR',
        profitZar: json['profit_zar']?.toDouble(),
        profitUsd: json['profit_usd']?.toDouble(),
        memberProfitZar: json['member_profit_zar']?.toDouble(),
        memberProfitUsd: json['member_profit_usd']?.toDouble(),
        stockQuantity: json['stock_quantity'] ?? 0,
        itemsSold: json['items_sold'],
        images: List<String>.from(json['images'] ?? []),
        isFeatured: json['is_featured'] ?? false,
        isNewArrival: json['is_new_arrival'] ?? false,
        isBestSeller: json['is_best_seller'] ?? false,
        isVaultItem: json['is_vault_item'] ?? false,
        allowGiftWrap: json['allow_gift_wrap'] ?? false,
        allowGiftMessage: json['allow_gift_message'] ?? false,
        status: json['status'] ?? 'draft',
        urlSlug: json['url_slug'] ?? '',
        sku: json['sku'] ?? '',
        madeBy: json['made_by'] ?? '',
        materials: List<String>.from(json['materials'] ?? []),
        colors: List<String>.from(json['colors'] ?? []),
        tags: List<String>.from(json['tags'] ?? []),
        createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
        updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
        earringMaterials: json['earring_materials'] != null ? Map<String, bool>.from(json['earring_materials']) : null,
        ringSizes: json['ring_sizes'] != null ? Map<String, int>.from(json['ring_sizes']) : null,
        chainOptions: json['chain_options'] != null ? Map<String, bool>.from(json['chain_options']) : null,
        leatherOption: json['leather_option'],
        enableMaterialCustomization: json['enable_material_customization'],
        enableMetalChain: json['enable_metal_chain'],
        isPromotionActive: json['is_promotion_active'],
        promotionStart: json['promotion_start'] != null ? DateTime.parse(json['promotion_start']) : null,
        promotionEnd: json['promotion_end'] != null ? DateTime.parse(json['promotion_end']) : null,
        affiliateUrl: json['affiliate_url'],
      );

  Product copyWith({
    String? id,
    String? name,
    String? category,
    String? productType,
    String? description,
    double? basePriceZar,
    double? basePriceUsd,
    double? sellingPriceZar,
    double? sellingPriceUsd,
    double? memberPriceZar,
    double? memberPriceUsd,
    double? promoPriceZar,
    double? promoPriceUsd,
    double? costPrice,
    String? costCurrency,
    int? stockQuantity,
    int? itemsSold,
    List<String>? images,
    bool? isFeatured,
    bool? isNewArrival,
    bool? isBestSeller,
    bool? isVaultItem,
    bool? allowGiftWrap,
    bool? allowGiftMessage,
    String? status,
    String? urlSlug,
    String? sku,
    String? madeBy,
    List<String>? materials,
    Map<String, bool>? earringMaterials,
    Map<String, int>? ringSizes,
    Map<String, bool>? chainOptions,
    bool? leatherOption,
    bool? enableMaterialCustomization,
    bool? enableMetalChain,
    bool? isPromotionActive,
    DateTime? promotionStart,
    DateTime? promotionEnd,
    String? affiliateUrl,
  }) =>
      Product(
        id: id ?? this.id,
        name: name ?? this.name,
        category: category ?? this.category,
        productType: productType ?? this.productType,
        description: description ?? this.description,
        basePriceZar: basePriceZar ?? this.basePriceZar,
        basePriceUsd: basePriceUsd ?? this.basePriceUsd,
        sellingPriceZar: sellingPriceZar ?? this.sellingPriceZar,
        sellingPriceUsd: sellingPriceUsd ?? this.sellingPriceUsd,
        memberPriceZar: memberPriceZar ?? this.memberPriceZar,
        memberPriceUsd: memberPriceUsd ?? this.memberPriceUsd,
        promoPriceZar: promoPriceZar ?? this.promoPriceZar,
        promoPriceUsd: promoPriceUsd ?? this.promoPriceUsd,
        costPrice: costPrice ?? this.costPrice,
        costCurrency: costCurrency ?? this.costCurrency,
        stockQuantity: stockQuantity ?? this.stockQuantity,
        itemsSold: itemsSold ?? this.itemsSold,
        images: images ?? this.images,
        isFeatured: isFeatured ?? this.isFeatured,
        isNewArrival: isNewArrival ?? this.isNewArrival,
        isBestSeller: isBestSeller ?? this.isBestSeller,
        isVaultItem: isVaultItem ?? this.isVaultItem,
        allowGiftWrap: allowGiftWrap ?? this.allowGiftWrap,
        allowGiftMessage: allowGiftMessage ?? this.allowGiftMessage,
        status: status ?? this.status,
        urlSlug: urlSlug ?? this.urlSlug,
        sku: sku ?? this.sku,
        madeBy: madeBy ?? this.madeBy,
        materials: materials ?? this.materials,
        earringMaterials: earringMaterials ?? this.earringMaterials,
        ringSizes: ringSizes ?? this.ringSizes,
        chainOptions: chainOptions ?? this.chainOptions,
        leatherOption: leatherOption ?? this.leatherOption,
        enableMaterialCustomization: enableMaterialCustomization ?? this.enableMaterialCustomization,
        enableMetalChain: enableMetalChain ?? this.enableMetalChain,
        isPromotionActive: isPromotionActive ?? this.isPromotionActive,
        promotionStart: promotionStart ?? this.promotionStart,
        promotionEnd: promotionEnd ?? this.promotionEnd,
        affiliateUrl: affiliateUrl ?? this.affiliateUrl,
        createdAt: createdAt,
        updatedAt: DateTime.now(),
      );
}

class Collection {
  final String? id;
  final String name;
  final String? imageUrl;
  final String description;
  final String? readMoreText;
  final String? explanationText;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Collection({
    this.id,
    required this.name,
    this.imageUrl,
    this.description = '',
    this.readMoreText,
    this.explanationText,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  factory Collection.fromJson(Map<String, dynamic> json) {
    return Collection(
      id: json['id'] as String?,
      name: json['name'] as String,
      imageUrl: json['image_url'] as String?,
      description: json['description'] as String? ?? '',
      readMoreText: json['read_more_text'] as String?,
      explanationText: json['explanation_text'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'image_url': imageUrl,
      'description': description,
      'read_more_text': readMoreText,
      'explanation_text': explanationText,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  Collection copyWith({
    String? id,
    String? name,
    String? imageUrl,
    String? description,
    String? readMoreText,
    String? explanationText,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Collection(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      readMoreText: readMoreText ?? this.readMoreText,
      explanationText: explanationText ?? this.explanationText,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
