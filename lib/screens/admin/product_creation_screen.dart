import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../theme/app_theme.dart';
import '../../data/models/product_model.dart';
import '../../data/models/parsed_review_model.dart';
import 'tabs/general_tab.dart';
import 'tabs/pricing_tab.dart';
import 'tabs/inventory_tab.dart';
import 'tabs/media_tab.dart';
import 'tabs/marketing_tab.dart';
import 'tabs/reviews_tab.dart';
import 'tabs/promotions_tab.dart';
import 'tabs/gifts_tab.dart';

class ProductCreationScreen extends StatefulWidget {
  final Product? product; // For editing existing products

  const ProductCreationScreen({super.key, this.product});

  @override
  State<ProductCreationScreen> createState() => _ProductCreationScreenState();
}

class _ProductCreationScreenState extends State<ProductCreationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Controllers for form fields
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _stylingController = TextEditingController();
  final _urlSlugController = TextEditingController();
  final _skuController = TextEditingController();
  final _madeByController = TextEditingController();
  final _materialsController = TextEditingController();
  final _basePriceController = TextEditingController();
  final _basePriceUsdController = TextEditingController();
  final _sellingPriceController = TextEditingController();
  final _sellingPriceUsdController = TextEditingController();
  final _memberPriceController = TextEditingController();
  final _memberPriceUsdController = TextEditingController();
  final _promoPriceController = TextEditingController();
  final _promoPriceUsdController = TextEditingController();
  final _stockController = TextEditingController();
  final _colorController = TextEditingController();
  final _shapeController = TextEditingController();
  final _costPriceController = TextEditingController();

  // Form state variables
  String _selectedCollection = '';
  String _selectedProductType = '';
  String _selectedStatus = 'draft'; // Default to draft
  bool _isFeatured = false;
  bool _isNewArrival = false;
  bool _isBestSeller = false;
  bool _isVaultItem = false;
  bool _allowGiftWrap = false;
  bool _allowGiftMessage = false;

  // Vault settings
  double? _vaultPriceZar;
  DateTime? _vaultEndDate;
  int? _vaultQuantity;
  double? _vaultPriceUsd;

  // Cost price (calculated from cost calculator)
  double? _costPrice;
  String _costCurrency = 'ZAR';

  // Inventory data from inventory tab
  int? _itemsSold;
  String? _selectedProductTypeFromInventory;

  // Profit values (in USD)
  double? _profitZar; // Profit in USD when sold in ZAR
  double? _profitUsd; // Profit in USD when sold in USD
  double? _memberProfitZar; // Member price profit in USD for ZAR sales
  double? _memberProfitUsd; // Member price profit in USD for USD sales

  // Dropdown data
  List<String> _artists = [];
  List<String> _materials = [];

  // Image state
  final ImagePicker _imagePicker = ImagePicker();
  final List<XFile> _selectedImages = [];

  // Multiple materials selection
  final List<String> _selectedMaterials = [];

  // Colors and Tags
  final List<String> _selectedColors = [];
  final List<String> _selectedTags = [];

  // Collections
  List<Collection> _collections = [];

  // Reviews
  final _reviewsController = TextEditingController();
  List<ParsedReview> _parsedReviews = [];
  bool _isLoadingReviews = false;

  // Add state variables for inventory options:
  Map<String, bool>? _earringMaterials;
  Map<String, int>? _ringSizes;
  Map<String, bool>? _chainOptions;
  bool? _leatherOption;
  bool? _enableMaterialCustomization;
  bool? _enableMetalChain;

  // Add promotion state variables:
  bool _isPromotionActive = false;
  DateTime? _promotionStart;
  DateTime? _promotionEnd;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 8, vsync: this);
    _setupListeners();
    _loadCollections();
    _loadArtists();
    _loadMaterials();

    // Load product data if editing
    if (widget.product != null) {
      // Schedule loading after the widget tree is built
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadProductData(widget.product!);
      });
    } else {
      _generateSKU();
    }
  }

  Future<void> _loadProductData(Product product) async {
    debugPrint('🔄 Loading product data for editing: ${product.name}');
    debugPrint('   ID: ${product.id}');

    // General tab
    _nameController.text = product.name;
    _descriptionController.text = product.description;
    _stylingController.text = product.styling ?? '';
    _urlSlugController.text = product.urlSlug;
    _skuController.text = product.sku;
    _madeByController.text = product.madeBy;
    _selectedMaterials.addAll(product.materials);
    _selectedColors.addAll(product.colors);
    _selectedTags.addAll(product.tags);
    _selectedCollection = product.category;
    _selectedProductType = product.productType;
    _selectedStatus = product.status;

    debugPrint('   Collection: $_selectedCollection');
    debugPrint('   Product Type: $_selectedProductType');
    debugPrint('   Status: $_selectedStatus');

    // Pricing tab
    _basePriceController.text = product.basePriceZar.toString();
    _basePriceUsdController.text = product.basePriceUsd.toString();
    _sellingPriceController.text = product.sellingPriceZar.toString();
    _sellingPriceUsdController.text = product.sellingPriceUsd.toString();
    _memberPriceController.text = product.memberPriceZar?.toString() ?? '';
    _memberPriceUsdController.text = product.memberPriceUsd?.toString() ?? '';
    _promoPriceController.text = product.promoPriceZar?.toString() ?? '';
    _promoPriceUsdController.text = product.promoPriceUsd?.toString() ?? '';

    // Load cost prices if they exist
    if (product.costPrice != null) {
      _costPrice = product.costPrice;
      _costCurrency = product.costCurrency;
      _costPriceController.text = product.costPrice!.toStringAsFixed(2);
      debugPrint('   Cost Price: $_costCurrency$_costPrice');
    }

    // Load profit values if they exist
    if (product.profitZar != null) {
      _profitZar = product.profitZar;
      debugPrint('   Profit ZAR: R$_profitZar');
    }
    if (product.profitUsd != null) {
      _profitUsd = product.profitUsd;
      debugPrint('   Profit USD (in ZAR): R$_profitUsd');
    }
    if (product.memberProfitZar != null) {
      _memberProfitZar = product.memberProfitZar;
      debugPrint('   Member Profit ZAR: R$_memberProfitZar');
    }
    if (product.memberProfitUsd != null) {
      _memberProfitUsd = product.memberProfitUsd;
      debugPrint('   Member Profit USD (in ZAR): R$_memberProfitUsd');
    }

    // Inventory tab
    _stockController.text = product.stockQuantity.toString();
    _itemsSold = product.itemsSold;
    _selectedProductTypeFromInventory = product.productType;
    _earringMaterials = product.earringMaterials;
    _ringSizes = product.ringSizes;
    _chainOptions = product.chainOptions;
    _leatherOption = product.leatherOption;
    _enableMaterialCustomization = product.enableMaterialCustomization;
    _enableMetalChain = product.enableMetalChain;

    debugPrint('   Stock: ${product.stockQuantity}');

    // Load inventory-specific data
    if (product.itemsSold != null) {
      _itemsSold = product.itemsSold;
      debugPrint('   Items Sold: ${product.itemsSold}');
    }
    if (product.productType.isNotEmpty) {
      _selectedProductTypeFromInventory = product.productType;
      debugPrint('   Product Type (Inventory): ${product.productType}');
    }

    // Marketing tab
    _isFeatured = product.isFeatured;
    _isNewArrival = product.isNewArrival;
    _isBestSeller = product.isBestSeller;
    _isVaultItem = product.isVaultItem;

    debugPrint('   Featured: $_isFeatured, New: $_isNewArrival, Best Seller: $_isBestSeller');

    // Gifts tab
    _allowGiftWrap = product.allowGiftWrap;
    _allowGiftMessage = product.allowGiftMessage;

    debugPrint('✅ Product data loaded successfully');
    // Note: Images would need special handling for existing URLs
    // For now, they would need to be re-uploaded if changed

    // Load reviews from database if editing existing product
    if (product.id != null) {
      await _loadReviewsFromDatabase(product.id!);
      // Force UI update after reviews are loaded
      if (mounted) {
        setState(() {});
      }
    }
  }

  Future<void> _loadReviewsFromDatabase(String productId) async {
    setState(() {
      _isLoadingReviews = true;
    });

    try {
      debugPrint('📖 Loading reviews for product: $productId');

      final response = await Supabase.instance.client
          .from('reviews')
          .select()
          .eq('product_id', productId)
          .order('created_at', ascending: false);

      debugPrint('📊 Database response: ${response.length} reviews found');

      if (response.isNotEmpty) {
        setState(() {
          _parsedReviews.clear();
        });

        for (final reviewData in response) {
          final parsedReview = ParsedReview(
            name: reviewData['reviewer_name'] ?? 'Anonymous',
            country: reviewData['reviewer_country'] ?? 'Unknown',
            flag: reviewData['reviewer_flag'] ?? '🏳️',
            rating: reviewData['rating'] ?? 5,
            reviewText: reviewData['review_text'] ?? '',
            date: reviewData['created_at'] != null
                ? DateTime.parse(reviewData['created_at'])
                : DateTime.now(),
          );
          _parsedReviews.add(parsedReview);
          debugPrint('   ✅ Loaded review: ${parsedReview.name} (${parsedReview.rating} stars)');
        }

        debugPrint('✅ Loaded ${_parsedReviews.length} reviews from database');

        // Update the reviews controller with formatted text for display
        _updateReviewsControllerFromParsedReviews();

        setState(() {
          _isLoadingReviews = false;
        });
      } else {
        debugPrint('ℹ️ No reviews found for this product');
        setState(() {
          _isLoadingReviews = false;
        });
      }
    } catch (e) {
      debugPrint('❌ Error loading reviews: $e');
      setState(() {
        _isLoadingReviews = false;
      });
    }
  }

  void _updateReviewsControllerFromParsedReviews() {
    if (_parsedReviews.isEmpty) {
      _reviewsController.clear();
      return;
    }

    final formattedReviews = _parsedReviews.map((review) {
      final dateStr = '${review.date.month}/${review.date.day}/${review.date.year}';
      // Show orderId in back office UI
      return '[${review.name}, ${review.country}] ${review.reviewText} ${review.rating}/5 $dateStr\nOrder ID: ${review.orderId}';
    }).join('\n');

    _reviewsController.text = formattedReviews;

    // Force UI update to show loaded reviews
    if (mounted) {
      setState(() {});
    }
  }

  void _setupListeners() {
    // Auto-generate URL slug from product name (only for new products)
    _nameController.addListener(() {
      if (_nameController.text.isNotEmpty && widget.product == null) {
        _urlSlugController.text = _generateSlug(_nameController.text);
      }
    });

    // Auto-calculate USD membership price when ZAR selling price changes
    _sellingPriceController.addListener(() {
      final sellingPriceZar = double.tryParse(_sellingPriceController.text) ?? 0;
      final membershipPriceZar = sellingPriceZar * 0.8; // 20% discount
      _memberPriceController.text = membershipPriceZar.toStringAsFixed(2);

      // Also update USD membership price if USD selling price is set
      final sellingPriceUsd = double.tryParse(_sellingPriceUsdController.text) ?? 0;
      if (sellingPriceUsd > 0) {
        final membershipPriceUsd = sellingPriceUsd * 0.8; // 20% discount
        _memberPriceUsdController.text = membershipPriceUsd.toStringAsFixed(2);
      }
    });

    // Auto-calculate USD membership price when USD selling price changes
    _sellingPriceUsdController.addListener(() {
      final sellingPriceUsd = double.tryParse(_sellingPriceUsdController.text) ?? 0;
      final membershipPriceUsd = sellingPriceUsd * 0.8; // 20% discount
      _memberPriceUsdController.text = membershipPriceUsd.toStringAsFixed(2);
    });

    // Update cost price variables when controllers change
    _costPriceController.addListener(() {
      _costPrice = double.tryParse(_costPriceController.text);
    });
  }

  String _generateSlug(String text) {
    return text
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s-]'), '') // Remove special characters
        .replaceAll(RegExp(r'\s+'), '-') // Replace spaces with hyphens
        .replaceAll(RegExp(r'-+'), '-') // Replace multiple hyphens with single
        .trim();
  }

  void _generateSKU() {
    // Generate SKU starting from SMV-1258961
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString().substring(8);
    _skuController.text = 'SMV-$timestamp';
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _urlSlugController.dispose();
    _skuController.dispose();
    _madeByController.dispose();
    _materialsController.dispose();
    _basePriceController.dispose();
    _basePriceUsdController.dispose();
    _sellingPriceController.dispose();
    _sellingPriceUsdController.dispose();
    _memberPriceController.dispose();
    _memberPriceUsdController.dispose();
    _promoPriceController.dispose();
    _promoPriceUsdController.dispose();
    _stockController.dispose();
    _colorController.dispose();
    _shapeController.dispose();
    _costPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.black,
      appBar: AppBar(
        backgroundColor: AppTheme.black,
        elevation: 0,
        title: Text(
          widget.product == null ? 'Create New Product' : 'Edit Product',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _saveProduct,
            child: const Text(
              'Save Product',
              style: TextStyle(color: AppTheme.cyan, fontSize: 16),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: AppTheme.pink,
          labelColor: AppTheme.pink,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'GENERAL'),
            Tab(text: 'MEDIA'),
            Tab(text: 'PRICING'),
            Tab(text: 'INVENTORY'),
            Tab(text: 'MARKETING'),
            Tab(text: 'REVIEWS'),
            Tab(text: 'PROMOTIONS'),
            Tab(text: 'GIFTS'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildGeneralTab(),
          _buildMediaTab(),
          _buildPricingTab(),
          _buildInventoryTab(),
          _buildMarketingTab(),
          _buildReviewsTab(),
          _buildPromotionsTab(),
          _buildGiftsTab(),
        ],
      ),
    );
  }

  Widget _buildGeneralTab() {
    return GeneralTab(
      nameController: _nameController,
      descriptionController: _descriptionController,
      stylingController: _stylingController,
      urlSlugController: _urlSlugController,
      skuController: _skuController,
      madeByController: _madeByController,
      materialsController: _materialsController,
      artists: _artists,
      materials: _materials,
      selectedMaterials: _selectedMaterials,
      selectedColors: _selectedColors,
      selectedTags: _selectedTags,
      collections: _collections,
      selectedCollection: _selectedCollection,
      selectedProductType: _selectedProductType,
      selectedStatus: _selectedStatus,
      onCollectionChanged: (value) => setState(() => _selectedCollection = value),
      onProductTypeChanged: (value) => setState(() => _selectedProductType = value),
      onStatusChanged: (value) => setState(() => _selectedStatus = value),
      onAddNewArtist: _addNewArtist,
      onAddNewMaterial: _addNewMaterial,
      onMaterialSelected: (material) => setState(() => _selectedMaterials.add(material)),
      onMaterialRemoved: (material) => setState(() => _selectedMaterials.remove(material)),
      onColorAdded: (color) => setState(() => _selectedColors.add(color)),
      onColorRemoved: (color) => setState(() => _selectedColors.remove(color)),
      onTagAdded: (tag) => setState(() => _selectedTags.add(tag)),
      onTagRemoved: (tag) => setState(() => _selectedTags.remove(tag)),
    );
  }

  Widget _buildPricingTab() {
    return PricingTab(
      basePriceController: _basePriceController,
      basePriceUsdController: _basePriceUsdController,
      sellingPriceController: _sellingPriceController,
      sellingPriceUsdController: _sellingPriceUsdController,
      memberPriceController: _memberPriceController,
      memberPriceUsdController: _memberPriceUsdController,
      promoPriceController: _promoPriceController,
      promoPriceUsdController: _promoPriceUsdController,
      costPriceController: _costPriceController,
      onCostPriceChanged: (cost) => setState(() => _costPrice = cost),
      onProfitZarChanged: (profit) => setState(() => _profitZar = profit),
      onProfitUsdChanged: (profit) => setState(() => _profitUsd = profit),
      onMemberProfitZarChanged: (profit) => setState(() => _memberProfitZar = profit),
      onMemberProfitUsdChanged: (profit) => setState(() => _memberProfitUsd = profit),
    );
  }

  Widget _buildInventoryTab() {
    return InventoryTab(
      stockController: _stockController,
      sellingPriceController: _sellingPriceController,
      onAdjustStock: (delta) => _adjustStock(delta),
      onItemsSoldChanged: (itemsSold) {
        setState(() => _itemsSold = itemsSold);
      },
      onProductTypeChanged: (productType) {
        setState(() => _selectedProductTypeFromInventory = productType);
      },
      initialItemsSold: _itemsSold,
      initialProductType: _selectedProductTypeFromInventory,
      onEarringMaterialsChanged: (materials) => setState(() => _earringMaterials = materials),
      onRingSizesChanged: (sizes) => setState(() => _ringSizes = sizes),
      onChainLengthsChanged: (chains) => setState(() => _chainOptions = chains),
      onEnableMaterialCustomizationChanged: (enabled) => setState(() => _enableMaterialCustomization = enabled),
      onEnableMetalChainChanged: (enabled) => setState(() => _enableMetalChain = enabled),
      onEnableLeatherChanged: (enabled) => setState(() => _leatherOption = enabled),
      earringMaterials: _earringMaterials,
      ringSizes: _ringSizes,
      chainOptions: _chainOptions,
      leatherOption: _leatherOption,
      enableMaterialCustomization: _enableMaterialCustomization,
      enableMetalChain: _enableMetalChain,
    );
  }

  Widget _buildMediaTab() {
    return MediaTab(
      selectedImages: _selectedImages,
      onPickImages: _pickImages,
      onRemoveImage: (image) => setState(() => _selectedImages.remove(image)),
      onClearImages: () => setState(() => _selectedImages.clear()),
    );
  }

  Widget _buildMarketingTab() {
    // Calculate current cost from pricing tab
    final currentCostZar = double.tryParse(_basePriceController.text);
    final currentCostUsd = double.tryParse(_basePriceUsdController.text);

    return MarketingTab(
      isFeatured: _isFeatured,
      isNewArrival: _isNewArrival,
      isBestSeller: _isBestSeller,
      isVaultItem: _isVaultItem,
      onFeaturedChanged: (value) => setState(() => _isFeatured = value),
      onNewArrivalChanged: (value) => setState(() => _isNewArrival = value),
      onBestSellerChanged: (value) => setState(() => _isBestSeller = value),
      onVaultItemChanged: (value) => setState(() => _isVaultItem = value),
      currentSellingPriceZar: double.tryParse(_sellingPriceController.text),
      currentCostZar: currentCostZar,
      vaultPriceZar: _vaultPriceZar,
      vaultEndDate: _vaultEndDate,
      vaultQuantity: _vaultQuantity,
      onVaultPriceZarChanged: (price) => setState(() => _vaultPriceZar = price),
      onVaultEndDateChanged: (date) => setState(() => _vaultEndDate = date),
      onVaultQuantityChanged: (quantity) => setState(() => _vaultQuantity = quantity),
      currentSellingPriceUsd: double.tryParse(_sellingPriceUsdController.text),
      currentCostUsd: currentCostUsd,
      vaultPriceUsd: _vaultPriceUsd,
      onVaultPriceUsdChanged: (price) => setState(() => _vaultPriceUsd = price),
      vaultProducts: [], // TODO: Load actual vault products from Supabase
    );
  }

  Widget _buildReviewsTab() {
    return ReviewsTab(
      reviewsController: _reviewsController,
      parsedReviews: _parsedReviews,
      onParseReviews: _parseReviews,
      isLoadingReviews: _isLoadingReviews,
    );
  }

  Widget _buildPromotionsTab() {
    return PromotionsTab(
      isPromotionActive: _isPromotionActive,
      promotionStart: _promotionStart,
      promotionEnd: _promotionEnd,
      promoPriceZar: _promoPriceController.text.isNotEmpty ? double.tryParse(_promoPriceController.text) : null,
      promoPriceUsd: _promoPriceUsdController.text.isNotEmpty ? double.tryParse(_promoPriceUsdController.text) : null,
      onPromotionActiveChanged: (active) => setState(() => _isPromotionActive = active),
      onPromotionStartChanged: (date) => setState(() => _promotionStart = date),
      onPromotionEndChanged: (date) => setState(() => _promotionEnd = date),
      onPromoPriceZarChanged: (price) => setState(() => _promoPriceController.text = price?.toString() ?? ''),
      onPromoPriceUsdChanged: (price) => setState(() => _promoPriceUsdController.text = price?.toString() ?? ''),
    );
  }

  Widget _buildGiftsTab() {
    return GiftsTab(
      allowGiftWrap: _allowGiftWrap,
      allowGiftMessage: _allowGiftMessage,
      onGiftWrapChanged: (value) => setState(() => _allowGiftWrap = value),
      onGiftMessageChanged: (value) => setState(() => _allowGiftMessage = value),
    );
  }

  void _adjustStock(int delta) {
    final currentStock = int.tryParse(_stockController.text) ?? 0;
    final newStock = (currentStock + delta).clamp(0, 9999);
    _stockController.text = newStock.toString();
  }

  Future<void> _pickImages() async {
    final messenger = ScaffoldMessenger.of(context);

    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          backgroundColor: AppTheme.cardDark,
          content: Row(
            children: [
              CircularProgressIndicator(color: AppTheme.cyan),
              SizedBox(width: 16),
              Text(
                'Processing images...',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      );

      final List<XFile> images = await _imagePicker.pickMultiImage(
        // Remove size constraints for faster initial loading
        // maxWidth: 1920,
        // maxHeight: 1080,
        imageQuality: 95, // Higher quality, faster processing
        limit: 8, // Limit selection to prevent memory issues
      );

      // Close loading dialog
      if (mounted) Navigator.of(context).pop();

      if (images.isNotEmpty && mounted) {
        // Process images in smaller batches to avoid UI freezing
        await _processImagesInBatches(images);
      }
    } catch (e) {
      // Close loading dialog if open
      if (mounted) Navigator.of(context).pop();

      if (mounted) {
        messenger.showSnackBar(
          SnackBar(
            content: Text('Error selecting images: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _processImagesInBatches(List<XFile> images) async {
    const batchSize = 3; // Process 3 images at a time
    final totalImages = images.length;
    var processedCount = 0;

    for (var i = 0; i < totalImages; i += batchSize) {
      final batch = images.skip(i).take(batchSize).toList();

      // Process batch asynchronously
      final processedBatch = await Future.wait(
        batch.map((image) => _processSingleImage(image)),
      );

      if (mounted) {
        setState(() {
          // Limit to 8 images total
          final availableSlots = 8 - _selectedImages.length;
          final imagesToAdd = processedBatch.take(availableSlots);
          _selectedImages.addAll(imagesToAdd);
          processedCount += imagesToAdd.length;
        });
      }

      // Small delay between batches to keep UI responsive
      await Future.delayed(const Duration(milliseconds: 50));
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$processedCount image(s) processed successfully!'),
          backgroundColor: AppTheme.cyan,
        ),
      );
    }
  }

  Future<XFile> _processSingleImage(XFile image) async {
    // For now, just return the image as-is
    // In the future, you could add compression here if needed
    return image;
  }

  void _saveProduct() async {
    // Manual validation
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a product name'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_selectedCollection.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a collection'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_basePriceController.text.trim().isEmpty ||
        _basePriceUsdController.text.trim().isEmpty ||
        _sellingPriceController.text.trim().isEmpty ||
        _sellingPriceUsdController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required price fields'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_stockController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter stock quantity'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Save new artist/material if not in list
    if (_madeByController.text.isNotEmpty && !_artists.contains(_madeByController.text)) {
      _artists.add(_madeByController.text);
    }
    if (_materialsController.text.isNotEmpty && !_materials.contains(_materialsController.text)) {
      _materials.add(_materialsController.text);
    }

    try {
      // Show loading indicator
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                ),
                SizedBox(width: 16),
                Text('Saving product...'),
              ],
            ),
            duration: Duration(seconds: 30),
          ),
        );
      }

      // Upload images to Supabase Storage if any were selected
      List<String> imageUrls = [];

      if (_selectedImages.isNotEmpty) {
        debugPrint('📸 Uploading ${_selectedImages.length} images to Supabase Storage...');

        for (int i = 0; i < _selectedImages.length; i++) {
          final image = _selectedImages[i];
          try {
            debugPrint('   📤 Uploading image ${i + 1}/${_selectedImages.length}: ${image.name}');

            // Read image as bytes
            final bytes = await image.readAsBytes();
            debugPrint('      Size: ${bytes.length} bytes');

            // Generate unique filename
            final timestamp = DateTime.now().millisecondsSinceEpoch;
            final fileName = '${timestamp}_${i}_${image.name}';
            debugPrint('      Filename: $fileName');

            // Upload to Supabase Storage
            await Supabase.instance.client.storage
                .from('products')
                .uploadBinary(fileName, bytes);

            // Get public URL
            final publicUrl = Supabase.instance.client.storage
                .from('products')
                .getPublicUrl(fileName);

            imageUrls.add(publicUrl);
            debugPrint('      ✅ Uploaded: $publicUrl');
          } catch (e) {
            debugPrint('      ❌ Failed to upload image ${i + 1}: $e');
          }
        }

        debugPrint('✅ Image upload complete: ${imageUrls.length}/${_selectedImages.length} successful');
      } else {
        debugPrint('📸 No new images to upload');
        // Keep existing images if editing
        if (widget.product != null) {
          imageUrls = widget.product!.images;
          debugPrint('   Using existing ${imageUrls.length} image(s)');
        }
      }

      debugPrint('📦 Final image URLs (${imageUrls.length}):');
      for (var url in imageUrls) {
        debugPrint('   - $url');
      }

      // Create product object
      final product = Product(
        id: widget.product?.id, // Include ID if editing
        name: _nameController.text.trim(),
        category: _selectedCollection,
        description: _descriptionController.text.trim(),
        styling: _stylingController.text.trim().isNotEmpty ? _stylingController.text.trim() : null,
        basePriceZar: double.parse(_basePriceController.text),
        basePriceUsd: double.parse(_basePriceUsdController.text),
        sellingPriceZar: double.parse(_sellingPriceController.text),
        sellingPriceUsd: double.parse(_sellingPriceUsdController.text),
        memberPriceZar: _memberPriceController.text.isNotEmpty
            ? double.parse(_memberPriceController.text)
            : null,
        memberPriceUsd: _memberPriceUsdController.text.isNotEmpty
            ? double.parse(_memberPriceUsdController.text)
            : null,
        promoPriceZar: _promoPriceController.text.isNotEmpty
            ? double.parse(_promoPriceController.text)
            : null,
        promoPriceUsd: _promoPriceUsdController.text.isNotEmpty
            ? double.parse(_promoPriceUsdController.text)
            : null,
        costPrice: _costPrice,
        costCurrency: _costCurrency,
        profitZar: _profitZar,
        profitUsd: _profitUsd,
        memberProfitZar: _memberProfitZar,
        memberProfitUsd: _memberProfitUsd,
        stockQuantity: int.parse(_stockController.text),
        itemsSold: _itemsSold,
        productType: _selectedProductTypeFromInventory ?? _selectedProductType,
        status: _selectedStatus, // Use selected status (draft or active)
        urlSlug: _urlSlugController.text.trim(),
        sku: _skuController.text.trim(),
        madeBy: _madeByController.text.trim(),
        materials: _selectedMaterials,
        colors: _selectedColors,
        tags: _selectedTags,
        images: imageUrls, // Add uploaded image URLs
        isFeatured: _isFeatured,
        isNewArrival: _isNewArrival,
        isBestSeller: _isBestSeller,
        isVaultItem: _isVaultItem,
        allowGiftWrap: _allowGiftWrap,
        allowGiftMessage: _allowGiftMessage,
        earringMaterials: _earringMaterials,
        ringSizes: _ringSizes,
        chainOptions: _chainOptions,
        leatherOption: _leatherOption,
        enableMaterialCustomization: _enableMaterialCustomization,
        enableMetalChain: _enableMetalChain,
        isPromotionActive: _isPromotionActive,
        promotionStart: _promotionStart,
        promotionEnd: _promotionEnd,
      );

      // Save product to Supabase
      final productData = product.toJson();

      debugPrint('💾 Saving product to database...');

      late final Map<String, dynamic> response;
      if (widget.product == null) {
        // Creating new product - prepare clean data
        final insertData = <String, dynamic>{};

        // Copy all non-null values except auto-generated fields
        productData.forEach((key, value) {
          if (value != null && key != 'id' && key != 'created_at' && key != 'updated_at') {
            insertData[key] = value;
          }
        });

        debugPrint('📦 Insert data: ${insertData.keys.toList()}');
        debugPrint('📊 Data has ${insertData.length} fields');
        debugPrint('📊 Critical field values:');
        debugPrint('   name: ${insertData['name']}');
        debugPrint('   images: ${insertData['images']}');
        debugPrint('   images type: ${insertData['images'].runtimeType}');
        debugPrint('   images length: ${insertData['images'] is List ? (insertData['images'] as List).length : 'N/A'}');
        if (insertData['images'] is List && (insertData['images'] as List).isNotEmpty) {
          final imageList = insertData['images'] as List;
          for (int i = 0; i < imageList.length; i++) {
            debugPrint('   Image $i: ${imageList[i]}');
          }
        }

        response = await Supabase.instance.client
            .from('products')
            .insert(insertData)
            .select()
            .single();
      } else {
        // Updating existing product
        final productId = widget.product!.id!;

        debugPrint('📝 Updating product: ${widget.product!.name}');
        debugPrint('   Product ID: $productId');

        // Prepare update data - exclude id and created_at
        final updateData = <String, dynamic>{};
        productData.forEach((key, value) {
          if (key != 'id' && key != 'created_at') {
            updateData[key] = value;
          }
        });

        // Set updated_at timestamp
        updateData['updated_at'] = DateTime.now().toIso8601String();

        debugPrint('📊 Update data keys: ${updateData.keys.toList()}');
        debugPrint('📊 Critical field values:');
        debugPrint('   name: ${updateData['name']}');
        debugPrint('   category: ${updateData['category']}');
        debugPrint('   product_type: ${updateData['product_type']}');
        debugPrint('   images: ${updateData['images']}');
        debugPrint('   images type: ${updateData['images'].runtimeType}');
        debugPrint('   images length: ${updateData['images'] is List ? (updateData['images'] as List).length : 'N/A'}');
        if (updateData['images'] is List && (updateData['images'] as List).isNotEmpty) {
          debugPrint('   First image URL: ${(updateData['images'] as List).first}');
        }
        debugPrint('   materials: ${updateData['materials']}');
        debugPrint('   colors: ${updateData['colors']}');
        debugPrint('   tags: ${updateData['tags']}');
        debugPrint('   stock_quantity: ${updateData['stock_quantity']}');
        debugPrint('   selling_price_zar: ${updateData['selling_price_zar']}');

        response = await Supabase.instance.client
            .from('products')
            .update(updateData)
            .eq('id', productId)
            .select()
            .single();

        debugPrint('✅ Product updated successfully');
        debugPrint('   Response images: ${response['images']}');
      }

      final productId = response['id'] as String;
      debugPrint('✅ Product saved with ID: $productId');

      // Save reviews if any were parsed
      if (_parsedReviews.isNotEmpty) {
        debugPrint('💾 Saving ${_parsedReviews.length} reviews for product $productId');

        // First, delete existing reviews for this product
        try {
          final deleteResponse = await Supabase.instance.client
              .from('reviews')
              .delete()
              .eq('product_id', productId);
          debugPrint('🗑️ Delete response: $deleteResponse');
        } catch (deleteError) {
          debugPrint('❌ Error deleting existing reviews: $deleteError');
        }

        debugPrint('🗑️ Deleted existing reviews for product $productId');

        int savedCount = 0;
        for (final review in _parsedReviews) {
          try {
            debugPrint('📝 Saving review ${savedCount + 1}: ${review.name} (${review.rating} stars)');
            // Use the generated UUID orderId for each review
            final reviewData = review.toJson(productId);
            debugPrint('📊 Review data: $reviewData');

            final insertResponse = await Supabase.instance.client.from('reviews').insert(reviewData);
            debugPrint('✅ Insert response: $insertResponse');
            savedCount++;
          } catch (e) {
            debugPrint('⚠️ Error saving review ${_parsedReviews.indexOf(review) + 1}: $e');
          }
        }

        debugPrint('✅ Saved $savedCount/${_parsedReviews.length} reviews successfully!');
      } else {
        // If no reviews in the list, delete any existing reviews for this product
        debugPrint('🗑️ No reviews to save, deleting existing reviews for product $productId');
        await Supabase.instance.client
            .from('reviews')
            .delete()
            .eq('product_id', productId);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Product saved successfully! ${_parsedReviews.isNotEmpty ? '(${_parsedReviews.length} reviews added)' : ''}',
            ),
            backgroundColor: Colors.green,
          ),
        );

        // Wait a moment for the snackbar to show, then navigate back
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          Navigator.pop(context, Product.fromJson(response));
        }
      }
    } catch (e) {
      debugPrint('❌ Error saving product: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving product: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  void _loadCollections() async {
    try {
      final response = await Supabase.instance.client
          .from('collections')
          .select()
          .eq('is_active', true)
          .order('name');

      if (mounted) {
        setState(() {
          _collections = response.map((json) => Collection.fromJson(json)).toList();
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading collections: $e')),
        );
      }
    }
  }

  void _loadArtists() async {
    try {
      final response = await Supabase.instance.client
          .from('Artist-Names')
          .select()
          .eq('is_active', true)
          .order('artist name');

      if (mounted) {
        setState(() {
          _artists = response.map((json) => json['artist name'] as String).toList();
        });
      }
    } catch (e) {
      debugPrint('Error loading artists: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading artists: $e')),
        );
      }
    }
  }

  void _loadMaterials() async {
    try {
      final response = await Supabase.instance.client
          .from('Materials')
          .select()
          .eq('is_active', true)
          .order('type');

      if (mounted) {
        setState(() {
          _materials = response.map((json) => json['type'] as String).toList();
        });
      }
    } catch (e) {
      debugPrint('Error loading materials: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading materials: $e')),
        );
      }
    }
  }

  void _addNewArtist(String artist) async {
    try {
      await Supabase.instance.client.from('Artist-Names').insert({
        'artist name': artist,
        'is_active': true,
        'created_at': DateTime.now().toIso8601String(),
      });

      setState(() {
        _artists.add(artist);
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Artist "$artist" added successfully!'),
            backgroundColor: AppTheme.cyan,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding artist: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _addNewMaterial(String material) async {
    try {
      await Supabase.instance.client.from('Materials').insert({
        'type': material,
        'is_active': true,
        'created_at': DateTime.now().toIso8601String(),
      });

      setState(() {
        _materials.add(material);
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Material "$material" added successfully!'),
            backgroundColor: AppTheme.cyan,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding material: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _parseReviews() {
    final text = _reviewsController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please paste some reviews first!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final reviews = <ParsedReview>[];

    // Split reviews - they can be on separate lines OR on the same line separated by ]. [
    List<String> reviewStrings = [];

    // First, split by newlines
    final lines = text.split('\n');
    for (final line in lines) {
      if (line.trim().isEmpty) continue;

      // Check if this line contains multiple reviews (pattern: ]. [)
      if (line.contains(']. [')) {
        // Split by ]. [ and add back the closing bracket to each review
        final parts = line.split(']. [');
        for (int i = 0; i < parts.length; i++) {
          String part = parts[i].trim();
          if (part.isEmpty) continue;

          // Add back the closing bracket if not the last part
          if (i < parts.length - 1 && !part.endsWith('.')) {
            part = '$part.';
          }
          // Add opening bracket if not the first part
          if (i > 0 && !part.startsWith('[')) {
            part = '[$part';
          }
          reviewStrings.add(part);
        }
      } else {
        reviewStrings.add(line);
      }
    }

    // Parse each review string
    for (final reviewStr in reviewStrings) {
      if (reviewStr.trim().isEmpty) continue;
      final review = ParsedReview.fromText(reviewStr.trim());
      if (review != null) {
        reviews.add(review);
      } else {
        debugPrint('Failed to parse: $reviewStr');
      }
    }

    setState(() {
      _parsedReviews = reviews;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Parsed ${reviews.length} review${reviews.length != 1 ? 's' : ''} successfully! ⭐'),
          backgroundColor: reviews.isNotEmpty ? Colors.green : Colors.orange,
        ),
      );
    }
  }
}

