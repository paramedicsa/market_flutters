import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class CostCalculatorWidget extends StatefulWidget {
  final TextEditingController sellingPriceController;
  final TextEditingController? sellingPriceUsdController;
  final Function(double) onTotalCostChanged;
  final Function(double) onArtistCommissionChanged;
  final Function(double)? onArtistCommissionUsdChanged;
  final Function(double)? onProfitZarChanged;
  final Function(double)? onProfitUsdChanged;
  final Function(double)? onMemberProfitZarChanged;
  final Function(double)? onMemberProfitUsdChanged;
  final String costCurrency; // Currency for cost calculations

  const CostCalculatorWidget({
    super.key,
    required this.sellingPriceController,
    this.sellingPriceUsdController,
    required this.onTotalCostChanged,
    required this.onArtistCommissionChanged,
    this.onArtistCommissionUsdChanged,
    this.onProfitZarChanged,
    this.onProfitUsdChanged,
    this.onMemberProfitZarChanged,
    this.onMemberProfitUsdChanged,
    required this.costCurrency,
  });

  @override
  State<CostCalculatorWidget> createState() => _CostCalculatorWidgetState();
}

class _CostCalculatorWidgetState extends State<CostCalculatorWidget> {
  final TextEditingController _productCostController = TextEditingController();
  final TextEditingController _packagingAmountController = TextEditingController();
  final TextEditingController _packagingQuantityController = TextEditingController();
  final TextEditingController _shippingAmountController = TextEditingController();
  final TextEditingController _shippingQuantityController = TextEditingController();

  final List<Map<String, TextEditingController>> _customCosts = [];
  bool _includeArtistCommission = true;

  // Profit values for display
  double _sellingProfitZarUsd = 0;
  double _membershipProfitZarUsd = 0;
  double _sellingProfitUsdZar = 0;
  double _membershipProfitUsdZar = 0;

  @override
  void initState() {
    super.initState();
    widget.sellingPriceController.addListener(_calculateTotals);
    _setupListeners();
  }

  void _setupListeners() {
    _productCostController.addListener(_calculateTotals);
    _packagingAmountController.addListener(_calculateTotals);
    _packagingQuantityController.addListener(_calculateTotals);
    _shippingAmountController.addListener(_calculateTotals);
    _shippingQuantityController.addListener(_calculateTotals);
  }

  void _calculateTotals() {
    double totalCost = 0;

    // Product cost
    final productCost = double.tryParse(_productCostController.text) ?? 0;
    totalCost += productCost;

    // Packaging cost per item
    final packagingAmount = double.tryParse(_packagingAmountController.text) ?? 0;
    final packagingQuantity = int.tryParse(_packagingQuantityController.text) ?? 1;
    if (packagingQuantity > 0) {
      totalCost += packagingAmount / packagingQuantity;
    }

    // Shipping cost per item
    final shippingAmount = double.tryParse(_shippingAmountController.text) ?? 0;
    final shippingQuantity = int.tryParse(_shippingQuantityController.text) ?? 1;
    if (shippingQuantity > 0) {
      totalCost += shippingAmount / shippingQuantity;
    }

    // Custom costs
    for (final customCost in _customCosts) {
      final amount = double.tryParse(customCost['amount']!.text) ?? 0;
      final quantity = int.tryParse(customCost['quantity']!.text) ?? 1;
      if (quantity > 0) {
        totalCost += amount / quantity;
      }
    }

    // Artist commission (1% of selling price) - ZAR
    final sellingPriceZar = double.tryParse(widget.sellingPriceController.text) ?? 0;
    final membershipPriceZar = sellingPriceZar * 0.8; // 20% discount
    final artistCommissionZar = _includeArtistCommission ? sellingPriceZar * 0.01 : 0.0;
    widget.onArtistCommissionChanged(artistCommissionZar);

    // Artist commission (1% of selling price) - USD
    if (widget.sellingPriceUsdController != null && widget.onArtistCommissionUsdChanged != null) {
      final sellingPriceUsd = double.tryParse(widget.sellingPriceUsdController!.text) ?? 0;
      final artistCommissionUsd = _includeArtistCommission ? sellingPriceUsd * 0.01 : 0.0;
      widget.onArtistCommissionUsdChanged!(artistCommissionUsd);
    }

    // Convert cost to USD for profit calculations
    final costUsd = widget.costCurrency == 'ZAR' ? totalCost / 18.0 : totalCost;

    // Profit calculations based on cost currency
    double sellingProfitZarUsd = 0;
    double membershipProfitZarUsd = 0;
    double sellingProfitUsdZar = 0;
    double membershipProfitUsdZar = 0;

    // Define USD prices for the build method
    final sellingPriceUsd = widget.sellingPriceUsdController != null ? double.tryParse(widget.sellingPriceUsdController!.text) ?? 0 : 0;
    final membershipPriceUsd = sellingPriceUsd * 0.8; // 20% discount

    if (widget.costCurrency == 'USD') {
      // Cost is in USD - convert ZAR prices to USD for profit calculation
      sellingProfitZarUsd = (sellingPriceZar / 18.0) - costUsd;
      membershipProfitZarUsd = (membershipPriceZar / 18.0) - costUsd;

      // USD sales profit (USD selling price - USD cost)
      final sellingProfitUsd = sellingPriceUsd - costUsd;
      final membershipProfitUsd = membershipPriceUsd - costUsd;

      // Store profit values for display
      setState(() {
        _sellingProfitZarUsd = sellingProfitZarUsd;
        _membershipProfitZarUsd = membershipProfitZarUsd;
        _sellingProfitUsdZar = sellingProfitUsd;
        _membershipProfitUsdZar = membershipProfitUsd;
      });

      // Notify parent of USD profits
      widget.onProfitUsdChanged?.call(sellingProfitUsd);
      widget.onMemberProfitUsdChanged?.call(membershipProfitUsd);
    } else {
      // Cost is in ZAR - calculate profits in ZAR
      sellingProfitZarUsd = sellingPriceZar - costUsd; // ZAR selling - ZAR cost
      membershipProfitZarUsd = membershipPriceZar - costUsd; // ZAR membership - ZAR cost

      // USD to ZAR conversion: USD selling price × 18 - ZAR cost
      sellingProfitUsdZar = (sellingPriceUsd * 18.0) - costUsd;
      membershipProfitUsdZar = (membershipPriceUsd * 18.0) - costUsd;

      // Store profit values for display
      setState(() {
        _sellingProfitZarUsd = sellingProfitZarUsd;
        _membershipProfitZarUsd = membershipProfitZarUsd;
        _sellingProfitUsdZar = sellingProfitUsdZar;
        _membershipProfitUsdZar = membershipProfitUsdZar;
      });

      // Notify parent of USD to ZAR profits
      widget.onProfitUsdChanged?.call(sellingProfitUsdZar);
      widget.onMemberProfitUsdChanged?.call(membershipProfitUsdZar);
    }

    // Call onTotalCostChanged and profit callbacks after build is complete to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onTotalCostChanged(totalCost);
      widget.onProfitZarChanged?.call(sellingProfitZarUsd);
      widget.onMemberProfitZarChanged?.call(membershipProfitZarUsd);
    });
  }

  void _addCustomCost() {
    setState(() {
      _customCosts.add({
        'name': TextEditingController(),
        'amount': TextEditingController(),
        'quantity': TextEditingController(text: '1'),
      });
    });
  }

  void _removeCustomCost(int index) {
    setState(() {
      _customCosts[index]['name']!.dispose();
      _customCosts[index]['amount']!.dispose();
      _customCosts[index]['quantity']!.dispose();
      _customCosts.removeAt(index);
      _calculateTotals();
    });
  }

  double _getTotalCost() {
    double total = 0;

    // Product cost
    total += double.tryParse(_productCostController.text) ?? 0;

    // Packaging
    final packagingAmount = double.tryParse(_packagingAmountController.text) ?? 0;
    final packagingQuantity = int.tryParse(_packagingQuantityController.text) ?? 1;
    if (packagingQuantity > 0) total += packagingAmount / packagingQuantity;

    // Shipping
    final shippingAmount = double.tryParse(_shippingAmountController.text) ?? 0;
    final shippingQuantity = int.tryParse(_shippingQuantityController.text) ?? 1;
    if (shippingQuantity > 0) total += shippingAmount / shippingQuantity;

    // Custom costs
    for (final customCost in _customCosts) {
      final amount = double.tryParse(customCost['amount']!.text) ?? 0;
      final quantity = int.tryParse(customCost['quantity']!.text) ?? 1;
      if (quantity > 0) total += amount / quantity;
    }

    return total;
  }

  double _getSellingPrice() => double.tryParse(widget.sellingPriceController.text) ?? 0;

  Widget _buildCostInputRow(String label, TextEditingController amountController,
      TextEditingController quantityController, String helpText) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () => _showHelpDialog(context, label, helpText),
                icon: const Icon(Icons.help_outline, size: 16, color: AppTheme.cyan),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                  decoration: InputDecoration(
                    labelText: 'Total Amount (${widget.costCurrency})',
                    labelStyle: const TextStyle(color: Colors.white70, fontSize: 11),
                    prefixText: widget.costCurrency == 'ZAR' ? 'R ' : '\$ ',
                    prefixStyle: const TextStyle(color: AppTheme.cyan, fontSize: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(color: Colors.white30),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(color: Colors.white30),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(color: AppTheme.cyan),
                    ),
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.05),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 1,
                child: TextField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                  decoration: InputDecoration(
                    labelText: 'Qty',
                    labelStyle: const TextStyle(color: Colors.white70, fontSize: 11),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(color: Colors.white30),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(color: Colors.white30),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(color: AppTheme.cyan),
                    ),
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.05),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.cyan.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${widget.costCurrency} ${((double.tryParse(amountController.text) ?? 0) / (int.tryParse(quantityController.text) ?? 1)).toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: AppTheme.cyan,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
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
    final totalCost = _getTotalCost();
    final sellingPriceZar = _getSellingPrice();
    final artistCommissionZar = _includeArtistCommission ? sellingPriceZar * 0.01 : 0;

    // Define USD prices for the build method
    final sellingPriceUsd = widget.sellingPriceUsdController != null ? double.tryParse(widget.sellingPriceUsdController!.text) ?? 0 : 0;
    final membershipPriceUsd = sellingPriceUsd * 0.8; // 20% discount

    // Convert cost to USD for profit calculations
    final costUsd = widget.costCurrency == 'ZAR' ? totalCost / 18.0 : totalCost;


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
          Row(
            children: [
              const Text(
                'Cost Calculator',
                style: TextStyle(
                  color: AppTheme.purple,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () => _showHelpDialog(
                  context,
                  'Cost Calculator',
                  'Calculate your total cost per item including product cost, packaging, shipping, and custom costs. This helps you determine your profit margins.',
                ),
                icon: const Icon(Icons.help_outline, size: 16, color: AppTheme.purple),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Total Cost Display
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.black.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.purple.withValues(alpha: 0.2)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Cost per Item:',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${widget.costCurrency} ${totalCost.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: AppTheme.purple,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Cost Inputs
          _buildCostInputRow(
            'Product Cost',
            _productCostController,
            TextEditingController(text: '1'), // Single item
            'The wholesale or manufacturing cost of the actual product.',
          ),

          _buildCostInputRow(
            'Product Packaging',
            _packagingAmountController,
            _packagingQuantityController,
            'Cost of packaging materials divided by the number of items packaged together.',
          ),

          _buildCostInputRow(
            'Shipping Cost',
            _shippingAmountController,
            _shippingQuantityController,
            'Total shipping cost divided by the number of items shipped together.',
          ),

          // Custom Costs
          ..._customCosts.asMap().entries.map((entry) {
            final index = entry.key;
            final customCost = entry.value;
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.black.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: customCost['name'],
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                          decoration: InputDecoration(
                            labelText: 'Custom Cost Name',
                            labelStyle: const TextStyle(color: Colors.white70, fontSize: 11),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: const BorderSide(color: Colors.white30),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: const BorderSide(color: Colors.white30),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: const BorderSide(color: AppTheme.cyan),
                            ),
                            filled: true,
                            fillColor: Colors.white.withValues(alpha: 0.05),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => _removeCustomCost(index),
                        icon: const Icon(Icons.delete, size: 16, color: Colors.red),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: customCost['amount'],
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                          decoration: InputDecoration(
                            labelText: 'Amount (${widget.costCurrency})',
                            labelStyle: const TextStyle(color: Colors.white70, fontSize: 11),
                            prefixText: widget.costCurrency == 'ZAR' ? 'R ' : '\$ ',
                            prefixStyle: const TextStyle(color: AppTheme.cyan, fontSize: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: const BorderSide(color: Colors.white30),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: const BorderSide(color: Colors.white30),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: const BorderSide(color: AppTheme.cyan),
                            ),
                            filled: true,
                            fillColor: Colors.white.withValues(alpha: 0.05),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 1,
                        child: TextField(
                          controller: customCost['quantity'],
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                          decoration: InputDecoration(
                            labelText: 'Qty',
                            labelStyle: const TextStyle(color: Colors.white70, fontSize: 11),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: const BorderSide(color: Colors.white30),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: const BorderSide(color: Colors.white30),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: const BorderSide(color: AppTheme.cyan),
                            ),
                            filled: true,
                            fillColor: Colors.white.withValues(alpha: 0.05),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.cyan.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${widget.costCurrency} ${((double.tryParse(customCost['amount']!.text) ?? 0) / (int.tryParse(customCost['quantity']!.text) ?? 1)).toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: AppTheme.cyan,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),

          // Add Custom Cost Button
          TextButton.icon(
            onPressed: _addCustomCost,
            icon: const Icon(Icons.add, color: AppTheme.cyan),
            label: const Text(
              'Add Custom Cost',
              style: TextStyle(color: AppTheme.cyan),
            ),
          ),
          const SizedBox(height: 16),

          // Platform Commission (Artist pays to site)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.black.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      'Platform Commission (1%)',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () => _showHelpDialog(
                        context,
                        'Platform Commission',
                        'This is the commission the artist pays to the platform for selling their product (1% of selling price). Toggle to include or exclude from cost calculations.',
                      ),
                      icon: const Icon(Icons.help_outline, size: 14, color: AppTheme.cyan),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'R ${artistCommissionZar.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: AppTheme.purple,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (widget.sellingPriceUsdController != null)
                          Text(
                            '\$ ${((double.tryParse(widget.sellingPriceUsdController!.text) ?? 0) * 0.01 * (_includeArtistCommission ? 1 : 0)).toStringAsFixed(2)}',
                            style: TextStyle(
                              color: AppTheme.purple.withValues(alpha: 0.7),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    Switch(
                      value: _includeArtistCommission,
                      onChanged: (value) {
                        setState(() => _includeArtistCommission = value);
                        _calculateTotals();
                      },
                      activeThumbColor: AppTheme.purple,
                      activeTrackColor: AppTheme.purple.withValues(alpha: 0.3),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Profit Calculations
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _membershipProfitZarUsd < 0 ? Colors.red.withValues(alpha: 0.1) : AppTheme.black.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _membershipProfitZarUsd < 0 ? Colors.red : Colors.white.withValues(alpha: 0.1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Profit Analysis (${widget.costCurrency == 'USD' ? 'in USD' : 'in ZAR'})',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                if (_membershipProfitZarUsd < 0)
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.warning, color: Colors.red, size: 16),
                        SizedBox(width: 8),
                        Text(
                          'Warning: Membership price results in loss!',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 8),

                if (widget.costCurrency == 'USD') ...[
                  // USD Cost Currency - Show ZAR to USD conversion profits
                  const Text(
                    'Profit in Dollar from Rand First Column:',
                    style: TextStyle(
                      color: AppTheme.cyan,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Formula: (R${sellingPriceZar.toStringAsFixed(2)} ÷ 18) - \$${costUsd.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 10,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Selling Price Profit: (\$${_sellingProfitZarUsd.toStringAsFixed(2)})',
                        style: const TextStyle(color: Colors.white70, fontSize: 11),
                      ),
                      Text(
                        '\$${_sellingProfitZarUsd.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: _sellingProfitZarUsd >= 0 ? Colors.green : Colors.red,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Membership Price Profit: (\$${_membershipProfitZarUsd.toStringAsFixed(2)})',
                        style: const TextStyle(color: Colors.white70, fontSize: 11),
                      ),
                      Text(
                        '\$${_membershipProfitZarUsd.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: _membershipProfitZarUsd >= 0 ? Colors.green : Colors.red,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  // USD Sales Section
                  if (widget.sellingPriceUsdController != null && sellingPriceUsd > 0) ...[
                    const SizedBox(height: 12),
                    const Divider(color: Colors.white24),
                    const SizedBox(height: 8),
                    const Text(
                      'When Sold in USD (Profit in USD):',
                      style: TextStyle(
                        color: AppTheme.cyan,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Formula: \$${sellingPriceUsd.toStringAsFixed(2)} - \$${costUsd.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 10,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Selling Price Profit: (\$${(sellingPriceUsd - costUsd).toStringAsFixed(2)})',
                          style: const TextStyle(color: Colors.white70, fontSize: 11),
                        ),
                        Text(
                          '\$${(sellingPriceUsd - costUsd).toStringAsFixed(2)}',
                          style: TextStyle(
                            color: (sellingPriceUsd - costUsd) >= 0 ? Colors.green : Colors.red,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Membership Price Profit: (\$${(membershipPriceUsd - costUsd).toStringAsFixed(2)})',
                          style: const TextStyle(color: Colors.white70, fontSize: 11),
                        ),
                        Text(
                          '\$${(membershipPriceUsd - costUsd).toStringAsFixed(2)}',
                          style: TextStyle(
                            color: (membershipPriceUsd - costUsd) >= 0 ? Colors.green : Colors.red,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ] else ...[
                  // ZAR Cost Currency - Show ZAR profits and USD to ZAR conversion
                  const Text(
                    'Profit in Rand:',
                    style: TextStyle(
                      color: AppTheme.cyan,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Formula: R${sellingPriceZar.toStringAsFixed(2)} - R${costUsd.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 10,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Selling Price Profit: (R${_sellingProfitZarUsd.toStringAsFixed(2)})',
                        style: const TextStyle(color: Colors.white70, fontSize: 11),
                      ),
                      Text(
                        'R${_sellingProfitZarUsd.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: _sellingProfitZarUsd >= 0 ? Colors.green : Colors.red,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Membership Price Profit: (R${_membershipProfitZarUsd.toStringAsFixed(2)})',
                        style: const TextStyle(color: Colors.white70, fontSize: 11),
                      ),
                      Text(
                        'R${_membershipProfitZarUsd.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: _membershipProfitZarUsd >= 0 ? Colors.green : Colors.red,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  // USD to ZAR Section
                  if (widget.sellingPriceUsdController != null && sellingPriceUsd > 0) ...[
                    const SizedBox(height: 12),
                    const Divider(color: Colors.white24),
                    const SizedBox(height: 8),
                    const Text(
                      'Dollar to Rand Profit:',
                      style: TextStyle(
                        color: AppTheme.cyan,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Formula: (\$${sellingPriceUsd.toStringAsFixed(2)} × 18) - R${costUsd.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 10,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Selling Price Profit: (R${_sellingProfitUsdZar.toStringAsFixed(2)})',
                          style: const TextStyle(color: Colors.white70, fontSize: 11),
                        ),
                        Text(
                          'R${_sellingProfitUsdZar.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: _sellingProfitUsdZar >= 0 ? Colors.green : Colors.red,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Membership Price Profit: (R${_membershipProfitUsdZar.toStringAsFixed(2)})',
                          style: const TextStyle(color: Colors.white70, fontSize: 11),
                        ),
                        Text(
                          'R${_membershipProfitUsdZar.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: _membershipProfitUsdZar >= 0 ? Colors.green : Colors.red,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],

              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _productCostController.dispose();
    _packagingAmountController.dispose();
    _packagingQuantityController.dispose();
    _shippingAmountController.dispose();
    _shippingQuantityController.dispose();
    for (final customCost in _customCosts) {
      customCost['name']!.dispose();
      customCost['amount']!.dispose();
      customCost['quantity']!.dispose();
    }
    super.dispose();
  }
}
