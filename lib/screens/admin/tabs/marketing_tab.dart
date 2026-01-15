import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class MarketingTab extends StatefulWidget {
  final bool isFeatured;
  final bool isNewArrival;
  final bool isBestSeller;
  final bool isVaultItem;
  final Function(bool) onFeaturedChanged;
  final Function(bool) onNewArrivalChanged;
  final Function(bool) onBestSellerChanged;
  final Function(bool) onVaultItemChanged;

  // Vault parameters - ZAR
  final double? currentSellingPriceZar;
  final double? currentCostZar;
  final double? vaultPriceZar;
  final DateTime? vaultEndDate;
  final int? vaultQuantity;
  final Function(double?) onVaultPriceZarChanged;
  final Function(DateTime?) onVaultEndDateChanged;
  final Function(int?) onVaultQuantityChanged;

  // Vault parameters - USD
  final double? currentSellingPriceUsd;
  final double? currentCostUsd;
  final double? vaultPriceUsd;
  final Function(double?) onVaultPriceUsdChanged;

  // Vault products list (for display when vault is active)
  final List<Map<String, dynamic>>? vaultProducts;

  const MarketingTab({
    super.key,
    required this.isFeatured,
    required this.isNewArrival,
    required this.isBestSeller,
    required this.isVaultItem,
    required this.onFeaturedChanged,
    required this.onNewArrivalChanged,
    required this.onBestSellerChanged,
    required this.onVaultItemChanged,
    this.currentSellingPriceZar,
    this.currentCostZar,
    this.vaultPriceZar,
    this.vaultEndDate,
    this.vaultQuantity,
    required this.onVaultPriceZarChanged,
    required this.onVaultEndDateChanged,
    required this.onVaultQuantityChanged,
    this.currentSellingPriceUsd,
    this.currentCostUsd,
    this.vaultPriceUsd,
    required this.onVaultPriceUsdChanged,
    this.vaultProducts,
  });

  @override
  State<MarketingTab> createState() => _MarketingTabState();
}

class _MarketingTabState extends State<MarketingTab> {
  // Featured items for different product types
  final Map<String, bool> _featuredItems = {
    'Featured Ring': false,
    'Featured Bracelet': false,
    'Unique Pendant': false,
    'Featured Studs': false,
    'Featured Dangles': false,
    'Featured Watch': false,
    'Featured Jewelry Box': false,
    'Featured Perfume Holder': false,
  };

  // Paid promotion
  bool _isPaidPromotion = false;

  // Vault settings
  late TextEditingController _vaultPriceZarController;
  late TextEditingController _vaultQuantityController;
  late TextEditingController _vaultPriceUsdController;
  DateTime? _selectedVaultEndDate;

  @override
  void initState() {
    super.initState();
    _vaultPriceZarController = TextEditingController(
      text: widget.vaultPriceZar?.toStringAsFixed(2) ?? '',
    );
    _vaultQuantityController = TextEditingController(
      text: widget.vaultQuantity?.toString() ?? '',
    );
    _vaultPriceUsdController = TextEditingController(
      text: widget.vaultPriceUsd?.toStringAsFixed(2) ?? '',
    );
    _selectedVaultEndDate = widget.vaultEndDate;
  }

  @override
  void didUpdateWidget(MarketingTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.vaultPriceZar != oldWidget.vaultPriceZar) {
      _vaultPriceZarController.text = widget.vaultPriceZar?.toStringAsFixed(2) ?? '';
    }
    if (widget.vaultQuantity != oldWidget.vaultQuantity) {
      _vaultQuantityController.text = widget.vaultQuantity?.toString() ?? '';
    }
    if (widget.vaultPriceUsd != oldWidget.vaultPriceUsd) {
      _vaultPriceUsdController.text = widget.vaultPriceUsd?.toStringAsFixed(2) ?? '';
    }
    if (widget.vaultEndDate != oldWidget.vaultEndDate) {
      _selectedVaultEndDate = widget.vaultEndDate;
    }
  }

  @override
  void dispose() {
    _vaultPriceZarController.dispose();
    _vaultQuantityController.dispose();
    _vaultPriceUsdController.dispose();
    super.dispose();
  }

  Future<void> _selectVaultEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedVaultEndDate ?? DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppTheme.purple,
              onPrimary: Colors.white,
              surface: Color(0xFF1E1E1E),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedVaultEndDate) {
      setState(() {
        _selectedVaultEndDate = picked;
      });
      widget.onVaultEndDateChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Marketing & Visibility',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),

          // Product Badges Section
          _buildProductBadgesSection(),

          const SizedBox(height: 24),

          // Featured Items Section
          _buildFeaturedItemsSection(),

          const SizedBox(height: 24),

          // Paid Promotion Section
          _buildPaidPromotionSection(),

          const SizedBox(height: 24),

          // Vault Section
          _buildVaultSection(),
        ],
      ),
    );
  }

  Widget _buildProductBadgesSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.pink.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Product Badges',
            style: TextStyle(
              color: AppTheme.pink,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Featured Product', style: TextStyle(color: Colors.white)),
            subtitle: const Text('Show in featured section on homepage', style: TextStyle(color: Colors.white70, fontSize: 12)),
            value: widget.isFeatured,
            onChanged: widget.onFeaturedChanged,
            activeThumbColor: AppTheme.pink,
            activeTrackColor: AppTheme.pink.withValues(alpha: 0.3),
          ),
          SwitchListTile(
            title: const Text('New Arrival', style: TextStyle(color: Colors.white)),
            subtitle: const Text('Highlight as new product', style: TextStyle(color: Colors.white70, fontSize: 12)),
            value: widget.isNewArrival,
            onChanged: widget.onNewArrivalChanged,
            activeThumbColor: AppTheme.cyan,
            activeTrackColor: AppTheme.cyan.withValues(alpha: 0.3),
          ),
          SwitchListTile(
            title: const Text('Best Seller', style: TextStyle(color: Colors.white)),
            subtitle: const Text('Mark as top-selling item', style: TextStyle(color: Colors.white70, fontSize: 12)),
            value: widget.isBestSeller,
            onChanged: widget.onBestSellerChanged,
            activeThumbColor: AppTheme.purple,
            activeTrackColor: AppTheme.purple.withValues(alpha: 0.3),
          ),
          SwitchListTile(
            title: const Text('Vault Item', style: TextStyle(color: Colors.white)),
            subtitle: const Text('Clearance/sale item', style: TextStyle(color: Colors.white70, fontSize: 12)),
            value: widget.isVaultItem,
            onChanged: widget.onVaultItemChanged,
            activeThumbColor: Colors.orange,
            activeTrackColor: Colors.orange.withValues(alpha: 0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedItemsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.purple.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Homepage Featured Items',
            style: TextStyle(
              color: AppTheme.purple,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Check items to feature on the homepage sections:',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 16),
          ..._featuredItems.entries.map((entry) {
            return CheckboxListTile(
              title: Text(
                entry.key,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
              subtitle: Text(
                _getFeaturedDescription(entry.key),
                style: const TextStyle(color: Colors.white60, fontSize: 11),
              ),
              value: entry.value,
              onChanged: (value) {
                setState(() {
                  _featuredItems[entry.key] = value ?? false;
                });
              },
              activeColor: AppTheme.purple,
              checkColor: Colors.white,
              tileColor: Colors.white.withValues(alpha: 0.05),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPaidPromotionSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Paid Promotion',
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Enable paid promotion to appear in the promotion section on the homepage',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text(
              'Enable Paid Promotion',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            subtitle: const Text(
              'Product will appear in the promotion section with special highlighting',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
            value: _isPaidPromotion,
            onChanged: (value) {
              setState(() {
                _isPaidPromotion = value;
              });
            },
            activeThumbColor: Colors.amber,
            activeTrackColor: Colors.amber.withValues(alpha: 0.3),
          ),
          if (_isPaidPromotion) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.celebration, color: Colors.amber, size: 16),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'This product will be prominently featured in the promotion section on the homepage!',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildVaultSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.inventory, color: Colors.red, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Vault Settings',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Configure vault pricing and availability. When active, this will override regular pricing and move the item to the vault section.',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 16),

          // Current Price & Cost Display
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Current Selling Price (ZAR):',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    Text(
                      widget.currentSellingPriceZar != null
                          ? 'R ${widget.currentSellingPriceZar!.toStringAsFixed(2)}'
                          : 'Not set',
                      style: const TextStyle(
                        color: AppTheme.cyan,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Current Cost (ZAR):',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    Text(
                      widget.currentCostZar != null
                          ? 'R ${widget.currentCostZar!.toStringAsFixed(2)}'
                          : 'Not set',
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Current Selling Price (USD):',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    Text(
                      widget.currentSellingPriceUsd != null
                          ? '\$ ${widget.currentSellingPriceUsd!.toStringAsFixed(2)}'
                          : 'Not set',
                      style: const TextStyle(
                        color: AppTheme.cyan,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Current Cost (USD):',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    Text(
                      widget.currentCostUsd != null
                          ? '\$ ${widget.currentCostUsd!.toStringAsFixed(2)}'
                          : 'Not set',
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Vault Price (ZAR)
          TextFormField(
            controller: _vaultPriceZarController,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Vault Price (R)',
              labelStyle: const TextStyle(color: Colors.white70),
              hintText: 'Enter discounted price',
              hintStyle: const TextStyle(color: Colors.white30),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.white30),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.white30),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.red),
              ),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.05),
              prefixIcon: const Icon(Icons.attach_money, color: Colors.red),
            ),
            onChanged: (value) {
              final price = double.tryParse(value);
              widget.onVaultPriceZarChanged(price);
            },
          ),

          const SizedBox(height: 16),

          // Vault Price (USD)
          TextFormField(
            controller: _vaultPriceUsdController,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Vault Price (USD)',
              labelStyle: const TextStyle(color: Colors.white70),
              hintText: 'Enter discounted price',
              hintStyle: const TextStyle(color: Colors.white30),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.white30),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.white30),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.red),
              ),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.05),
              prefixIcon: const Icon(Icons.attach_money, color: Colors.red),
            ),
            onChanged: (value) {
              final price = double.tryParse(value);
              widget.onVaultPriceUsdChanged(price);
            },
          ),

          const SizedBox(height: 16),

          // Vault End Date
          InkWell(
            onTap: () => _selectVaultEndDate(context),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white30),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, color: Colors.red),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Vault End Date',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          _selectedVaultEndDate != null
                              ? '${_selectedVaultEndDate!.day}/${_selectedVaultEndDate!.month}/${_selectedVaultEndDate!.year}'
                              : 'Select end date',
                          style: TextStyle(
                            color: _selectedVaultEndDate != null ? Colors.white : Colors.white30,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down, color: Colors.white30),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Vault Quantity
          TextFormField(
            controller: _vaultQuantityController,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Vault Quantity',
              labelStyle: const TextStyle(color: Colors.white70),
              hintText: 'Enter available quantity',
              hintStyle: const TextStyle(color: Colors.white30),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.white30),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.white30),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.red),
              ),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.05),
              prefixIcon: const Icon(Icons.inventory, color: Colors.red),
            ),
            onChanged: (value) {
              final quantity = int.tryParse(value);
              widget.onVaultQuantityChanged(quantity);
            },
          ),

          const SizedBox(height: 16),

          // Vault Status & Profit Calculation
          if (widget.vaultPriceZar != null && widget.currentCostZar != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (widget.vaultPriceZar! > widget.currentCostZar!)
                    ? Colors.green.withValues(alpha: 0.1)
                    : Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: (widget.vaultPriceZar! > widget.currentCostZar!)
                      ? Colors.green.withValues(alpha: 0.3)
                      : Colors.red.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Vault Profit per Item (ZAR):',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      Text(
                        'R ${(widget.vaultPriceZar! - widget.currentCostZar!).toStringAsFixed(2)}',
                        style: TextStyle(
                          color: (widget.vaultPriceZar! > widget.currentCostZar!)
                              ? Colors.green
                              : Colors.red,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.vaultPriceZar! > widget.currentCostZar!
                        ? '✅ Profitable vault pricing'
                        : '⚠️ Loss-making vault pricing',
                    style: TextStyle(
                      color: widget.vaultPriceZar! > widget.currentCostZar!
                          ? Colors.green
                          : Colors.red,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (widget.vaultPriceUsd != null && widget.currentCostUsd != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (widget.vaultPriceUsd! > widget.currentCostUsd!)
                    ? Colors.green.withValues(alpha: 0.1)
                    : Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: (widget.vaultPriceUsd! > widget.currentCostUsd!)
                      ? Colors.green.withValues(alpha: 0.3)
                      : Colors.red.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Vault Profit per Item (USD):',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      Text(
                        '\$ ${(widget.vaultPriceUsd! - widget.currentCostUsd!).toStringAsFixed(2)}',
                        style: TextStyle(
                          color: (widget.vaultPriceUsd! > widget.currentCostUsd!)
                              ? Colors.green
                              : Colors.red,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.vaultPriceUsd! > widget.currentCostUsd!
                        ? '✅ Profitable vault pricing'
                        : '⚠️ Loss-making vault pricing',
                    style: TextStyle(
                      color: widget.vaultPriceUsd! > widget.currentCostUsd!
                          ? Colors.green
                          : Colors.red,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 16),

          // Vault Activation Status
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: (widget.vaultPriceZar != null && widget.vaultEndDate != null && widget.vaultQuantity != null)
                  ? Colors.red.withValues(alpha: 0.1)
                  : Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: (widget.vaultPriceZar != null && widget.vaultEndDate != null && widget.vaultQuantity != null)
                    ? Colors.red.withValues(alpha: 0.3)
                    : Colors.white30,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  (widget.vaultPriceZar != null && widget.vaultEndDate != null && widget.vaultQuantity != null)
                      ? Icons.check_circle
                      : Icons.info,
                  color: (widget.vaultPriceZar != null && widget.vaultEndDate != null && widget.vaultQuantity != null)
                      ? Colors.red
                      : Colors.white30,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    (widget.vaultPriceZar != null && widget.vaultEndDate != null && widget.vaultQuantity != null)
                        ? 'Vault settings active - Item will appear in vault section'
                        : 'Complete all vault settings to activate',
                    style: TextStyle(
                      color: (widget.vaultPriceZar != null && widget.vaultEndDate != null && widget.vaultQuantity != null)
                          ? Colors.white
                          : Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Vault Products List (when vault is active)
          if (widget.vaultProducts != null && widget.vaultProducts!.isNotEmpty) ...[
            const Text(
              'Vault Products',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...widget.vaultProducts!.map((product) {
              return Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: AppTheme.cardDark,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white30),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product['name'] ?? 'Unknown Product',
                            style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Vault Price: ${product['vaultPriceZar'] != null ? 'R ${product['vaultPriceZar'].toStringAsFixed(2)}' : 'N/A'}',
                            style: const TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                          Text(
                            'USD Price: ${product['vaultPriceUsd'] != null ? '\$ ${product['vaultPriceUsd'].toStringAsFixed(2)}' : 'N/A'}',
                            style: const TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, color: Colors.white30, size: 16),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }

  String _getFeaturedDescription(String featuredType) {
    switch (featuredType) {
      case 'Featured Ring':
        return 'Showcase in the rings collection section';
      case 'Featured Bracelet':
        return 'Highlight in the bracelets category';
      case 'Unique Pendant':
        return 'Display in the pendants showcase';
      case 'Featured Studs':
        return 'Feature in the stud earrings section';
      case 'Featured Dangles':
        return 'Showcase in the dangle earrings collection';
      case 'Featured Watch':
        return 'Display in the watches category';
      case 'Featured Jewelry Box':
        return 'Highlight in the jewelry boxes section';
      case 'Featured Perfume Holder':
        return 'Showcase in the perfume holders collection';
      default:
        return 'Feature on homepage';
    }
  }
}
