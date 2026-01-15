import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import 'cost_calculator_widget.dart';

class PricingTab extends StatefulWidget {
  final TextEditingController basePriceController; // RRP ZAR
  final TextEditingController basePriceUsdController; // RRP USD
  final TextEditingController sellingPriceController; // Selling Price ZAR
  final TextEditingController sellingPriceUsdController; // Selling Price USD
  final TextEditingController memberPriceController; // Membership Price ZAR (auto-calculated)
  final TextEditingController memberPriceUsdController; // Membership Price USD (auto-calculated)
  final TextEditingController promoPriceController; // Promotional Price ZAR
  final TextEditingController promoPriceUsdController; // Promotional Price USD
  final TextEditingController? costPriceController; // Cost Price
  final Function(double?)? onCostPriceChanged;
  final Function(double?)? onProfitZarChanged;
  final Function(double?)? onProfitUsdChanged;
  final Function(double?)? onMemberProfitZarChanged;
  final Function(double?)? onMemberProfitUsdChanged;

  const PricingTab({
    super.key,
    required this.basePriceController,
    required this.basePriceUsdController,
    required this.sellingPriceController,
    required this.sellingPriceUsdController,
    required this.memberPriceController,
    required this.memberPriceUsdController,
    required this.promoPriceController,
    required this.promoPriceUsdController,
    this.costPriceController,
    this.onCostPriceChanged,
    this.onProfitZarChanged,
    this.onProfitUsdChanged,
    this.onMemberProfitZarChanged,
    this.onMemberProfitUsdChanged,
  });

  @override
  State<PricingTab> createState() => _PricingTabState();
}

class _PricingTabState extends State<PricingTab> {
  double _totalCost = 0;
  double _artistCommissionZar = 0;
  double _artistCommissionUsd = 0;
  String _costCurrency = 'ZAR'; // Currency for cost price
  bool _isCurrencySelected = false; // Track if currency has been selected

  @override
  void initState() {
    super.initState();
    widget.sellingPriceController.addListener(_updateMembershipPrice);
    widget.sellingPriceUsdController.addListener(_updateMembershipPriceUsd);
    widget.sellingPriceController.addListener(_updateArtistCommissions);
    widget.sellingPriceUsdController.addListener(_updateArtistCommissions);
    _updateMembershipPrice();
    _updateMembershipPriceUsd();
    _updateArtistCommissions();

    // Initialize currency selection if cost price controller has a value
    if (widget.costPriceController != null && widget.costPriceController!.text.isNotEmpty) {
      _isCurrencySelected = true;
    }
  }

  void _updateMembershipPrice() {
    final sellingPrice = double.tryParse(widget.sellingPriceController.text) ?? 0;
    final membershipPrice = sellingPrice * 0.8; // 20% discount
    widget.memberPriceController.text = membershipPrice.toStringAsFixed(2);
  }

  void _updateMembershipPriceUsd() {
    final sellingPriceUsd = double.tryParse(widget.sellingPriceUsdController.text) ?? 0;
    final membershipPriceUsd = sellingPriceUsd * 0.8; // 20% discount
    widget.memberPriceUsdController.text = membershipPriceUsd.toStringAsFixed(2);
  }

  void _updateArtistCommissions() {
    final sellingPriceZar = double.tryParse(widget.sellingPriceController.text) ?? 0;
    final sellingPriceUsd = double.tryParse(widget.sellingPriceUsdController.text) ?? 0;

    setState(() {
      _artistCommissionZar = sellingPriceZar * 0.01; // 1% of ZAR price
      _artistCommissionUsd = sellingPriceUsd * 0.01; // 1% of USD price
    });
  }

  Widget _buildPriceField(String label, TextEditingController controller, Color color,
      {bool readOnly = false, String? helpText}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (helpText != null) ...[
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => _showHelpDialog(context, label, helpText),
                  icon: Icon(Icons.help_outline, size: 16, color: color),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            readOnly: readOnly,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: color.withValues(alpha: 0.3)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: color.withValues(alpha: 0.3)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: color),
              ),
              filled: true,
              fillColor: AppTheme.black.withValues(alpha: 0.3),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardDark,
        title: Text(title, style: const TextStyle(color: Colors.white)),
        content: Text(content, style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: AppTheme.cyan)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Use the fields to avoid unused warnings
    final _ = _totalCost + _artistCommissionZar + _artistCommissionUsd;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pricing Configuration',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),

          // Price Columns
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ZAR Column
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.cardDark,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.cyan.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'South African Rand (ZAR)',
                            style: TextStyle(
                              color: AppTheme.cyan,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: () => _showHelpDialog(
                              context,
                              'ZAR Pricing',
                              'Set your prices in South African Rand. Membership prices are automatically calculated as 20% off the selling price.',
                            ),
                            icon: const Icon(Icons.help_outline, size: 16, color: AppTheme.cyan),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      _buildPriceField(
                        'RRP (Recommended Retail Price)',
                        widget.basePriceController,
                        AppTheme.cyan,
                        helpText: 'The original retail price before any discounts.',
                      ),

                      _buildPriceField(
                        'Selling Price',
                        widget.sellingPriceController,
                        Colors.green,
                        helpText: 'The actual price customers pay for the product.',
                      ),

                      _buildPriceField(
                        'Membership Price (20% off)',
                        widget.memberPriceController,
                        AppTheme.purple,
                        readOnly: true,
                        helpText: 'Automatically calculated as 20% discount from selling price.',
                      ),

                      _buildPriceField(
                        'Promotional Price (Optional)',
                        widget.promoPriceController,
                        AppTheme.pink,
                        helpText: 'Special promotional price for limited time offers.',
                      ),
                    ],
                  ),
                ),
              ),

              // USD Column
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.cardDark,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'US Dollar (USD)',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: () => _showHelpDialog(
                              context,
                              'USD Pricing',
                              'Set your prices in US Dollars. Membership prices are automatically calculated as 20% off the selling price.',
                            ),
                            icon: const Icon(Icons.help_outline, size: 16, color: Colors.blue),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      _buildPriceField(
                        'RRP (USD)',
                        widget.basePriceUsdController,
                        AppTheme.cyan,
                        helpText: 'The original retail price in USD.',
                      ),

                      _buildPriceField(
                        'Selling Price (USD)',
                        widget.sellingPriceUsdController,
                        Colors.green,
                        helpText: 'The actual price in USD.',
                      ),

                      _buildPriceField(
                        'Membership Price (20% off USD)',
                        widget.memberPriceUsdController,
                        AppTheme.purple,
                        readOnly: true,
                        helpText: 'Automatically calculated as 20% discount from selling price in USD.',
                      ),

                      _buildPriceField(
                        'Promotional Price (Optional USD)',
                        widget.promoPriceUsdController,
                        AppTheme.pink,
                        helpText: 'Special promotional price in USD.',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Cost Price Section
          if (widget.costPriceController != null) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calculate, color: Colors.orange, size: 20),
                      const SizedBox(width: 8),
                      const Text(
                        'Product Cost Price',
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Tooltip(
                        message: 'This is the saved cost price from the calculator below',
                        child: Icon(Icons.info_outline, color: Colors.orange.withValues(alpha: 0.7), size: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: widget.costPriceController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                          decoration: InputDecoration(
                            prefixText: 'Amount ',
                            prefixStyle: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 18),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.orange.withValues(alpha: 0.3)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.orange.withValues(alpha: 0.3)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.orange, width: 2),
                            ),
                            filled: true,
                            fillColor: AppTheme.black.withValues(alpha: 0.3),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          ),
                          onChanged: (value) {
                            final cost = double.tryParse(value);
                            widget.onCostPriceChanged?.call(cost);
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Currency',
                              style: TextStyle(color: Colors.orange.withValues(alpha: 0.7), fontSize: 11),
                            ),
                            const SizedBox(height: 4),
                            DropdownButtonFormField<String>(
                              initialValue: _costCurrency, // Default to ZAR
                              items: const [
                                DropdownMenuItem(value: 'ZAR', child: Text('ZAR (Rand)', style: TextStyle(color: Colors.white))),
                                DropdownMenuItem(value: 'USD', child: Text('USD (Dollar)', style: TextStyle(color: Colors.white))),
                              ],
                              onChanged: _isCurrencySelected ? null : (value) {
                                if (value != null && widget.costPriceController != null) {
                                  final currentCostPrice = double.tryParse(widget.costPriceController!.text) ?? 0;
                                  double convertedCostPrice = currentCostPrice;

                                  // Convert cost price when changing currency
                                  if (_costCurrency == 'ZAR' && value == 'USD') {
                                    // Converting from ZAR to USD: divide by 18
                                    convertedCostPrice = currentCostPrice / 18.0;
                                  } else if (_costCurrency == 'USD' && value == 'ZAR') {
                                    // Converting from USD to ZAR: multiply by 18
                                    convertedCostPrice = currentCostPrice * 18.0;
                                  }

                                  setState(() {
                                    _costCurrency = value;
                                    _isCurrencySelected = true;
                                  });

                                  // Update the cost price controller with converted value
                                  widget.costPriceController!.text = convertedCostPrice.toStringAsFixed(2);
                                }
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: Colors.orange.withValues(alpha: 0.3)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: Colors.orange.withValues(alpha: 0.3)),
                                ),
                                filled: true,
                                fillColor: _isCurrencySelected ? Colors.grey.withValues(alpha: 0.1) : AppTheme.black.withValues(alpha: 0.3),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              ),
                              dropdownColor: AppTheme.cardDark,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'This value is saved with the product. Use the calculator below to recalculate if needed.',
                    style: TextStyle(color: Colors.orange.withValues(alpha: 0.7), fontSize: 11),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Cancel button and currency selection
          Row(
            children: [
              if (_isCurrencySelected) ...[
                TextButton.icon(
                  onPressed: () {
                    if (widget.costPriceController != null) {
                      final currentCostPrice = double.tryParse(widget.costPriceController!.text) ?? 0;
                      double convertedCostPrice = currentCostPrice;

                      // Convert back to ZAR when canceling (assuming current is USD)
                      if (_costCurrency == 'USD') {
                        convertedCostPrice = currentCostPrice * 18.0; // USD to ZAR
                      }

                      setState(() {
                        _isCurrencySelected = false;
                        _costCurrency = 'ZAR'; // Reset to default
                      });

                      // Update the cost price controller with converted value
                      widget.costPriceController!.text = convertedCostPrice.toStringAsFixed(2);
                    }
                  },
                  icon: const Icon(Icons.cancel, size: 16, color: Colors.red),
                  label: const Text(
                    'Cancel Selection',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              ],
            ],
          ),

          // Cost Calculator Widget - Only show if currency is selected
          if (_isCurrencySelected) ...[
            CostCalculatorWidget(
              sellingPriceController: widget.sellingPriceController,
              sellingPriceUsdController: widget.sellingPriceUsdController,
              onTotalCostChanged: (cost) {
                setState(() => _totalCost = cost);
                // Update the cost price controller with the total cost in the selected currency
                if (widget.costPriceController != null) {
                  widget.costPriceController!.text = cost.toStringAsFixed(2);
                }
                // Notify parent of cost price change
                widget.onCostPriceChanged?.call(cost);
              },
              onArtistCommissionChanged: (commission) => setState(() => _artistCommissionZar = commission),
              onArtistCommissionUsdChanged: (commission) => setState(() => _artistCommissionUsd = commission),
              onProfitZarChanged: widget.onProfitZarChanged,
              onProfitUsdChanged: widget.onProfitUsdChanged,
              onMemberProfitZarChanged: widget.onMemberProfitZarChanged,
              onMemberProfitUsdChanged: widget.onMemberProfitUsdChanged,
              costCurrency: _costCurrency,
            ),
          ],
        ],
      ),
    );
  }
}
