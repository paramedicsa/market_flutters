import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class InventoryTab extends StatefulWidget {
  final TextEditingController stockController;
  final TextEditingController sellingPriceController;
  final Function(int) onAdjustStock;
  final Function(int?)? onItemsSoldChanged;
  final Function(String?)? onProductTypeChanged;
  final int? initialItemsSold;
  final String? initialProductType;

  // New callbacks for inventory options
  final Function(bool)? onEnableMaterialCustomizationChanged;
  final Function(Map<String, bool>)? onEarringMaterialsChanged;
  final Function(Map<String, int>)? onRingSizesChanged;
  final Function(bool)? onEnableMetalChainChanged;
  final Function(Map<String, bool>)? onChainLengthsChanged;
  final Function(bool)? onEnableLeatherChanged;

  // Added fields for initial values
  final Map<String, bool>? earringMaterials;
  final Map<String, int>? ringSizes;
  final Map<String, bool>? chainOptions;
  final bool? leatherOption;
  final bool? enableMaterialCustomization;
  final bool? enableMetalChain;

  const InventoryTab({
    super.key,
    required this.stockController,
    required this.sellingPriceController,
    required this.onAdjustStock,
    this.onItemsSoldChanged,
    this.onProductTypeChanged,
    this.initialItemsSold,
    this.initialProductType,
    this.onEnableMaterialCustomizationChanged,
    this.onEarringMaterialsChanged,
    this.onRingSizesChanged,
    this.onEnableMetalChainChanged,
    this.onChainLengthsChanged,
    this.onEnableLeatherChanged,
    this.earringMaterials,
    this.ringSizes,
    this.chainOptions,
    this.leatherOption,
    this.enableMaterialCustomization,
    this.enableMetalChain,
  });

  @override
  State<InventoryTab> createState() => _InventoryTabState();
}

class _InventoryTabState extends State<InventoryTab> {
  final TextEditingController _itemsSoldController = TextEditingController();
  String _selectedProductType = 'Rings';

  // Material customization for earrings
  bool _enableMaterialCustomization = false;
  final Map<String, bool> _selectedMaterials = {
    'Sterling Silver +R30': false,
    'Stainless Steel Black +R0': false,
    'Stainless Steel Silver +R0': false,
    'Hypo-Allergic Plastic +R0': false,
  };

  // Ring sizes
  final Map<String, TextEditingController> _ringSizeControllers = {
    'Size 5': TextEditingController(),
    'Size 6': TextEditingController(),
    'Size 7': TextEditingController(),
    'Size 8': TextEditingController(),
    'Size 9': TextEditingController(),
    'Size 10': TextEditingController(),
    'Size 11': TextEditingController(),
  };

  // Chain/Leather options for pendants and necklaces
  bool _enableMetalChain = false;
  bool _enableLeather = false;
  final Map<String, bool> _selectedChainLengths = {
    'Choker – 35 cm': false,
    'Collar – 40 cm': false,
    'Princess – 45 cm': false,
    'Matinee – 50 cm': false,
    'Matinee Long – 60 cm': false,
  };

  final List<String> _productTypes = [
    'Rings',
    'Bracelets',
    'Stud Earrings',
    'Dangle Earrings',
    'Watches',
    'Girls',
    'Jewelry Sets',
    'Perfume Bottles',
    'Jewelry Boxes',
    'Pendants and Necklaces',
  ];

  @override
  void initState() {
    super.initState();
    _itemsSoldController.text = widget.initialItemsSold?.toString() ?? '0';
    // Only update total quantity if stock is not already set
    if (widget.stockController.text.isEmpty || widget.stockController.text == '0') {
      _updateTotalQuantity();
    }

    // Listen to changes in stock and items sold to update available stock
    widget.stockController.addListener(() {
      setState(() {}); // Rebuild to show updated available stock
    });
    _itemsSoldController.addListener(() {
      setState(() {}); // Rebuild to show updated available stock
      if (widget.onItemsSoldChanged != null) {
        final value = int.tryParse(_itemsSoldController.text);
        widget.onItemsSoldChanged!(value);
      }
    });

    // Set initial values for items sold and product type if provided
    if (widget.initialProductType != null && _productTypes.contains(widget.initialProductType)) {
      _selectedProductType = widget.initialProductType!;
    }

    // Initialize earring materials
    if (widget.onEarringMaterialsChanged != null && widget.earringMaterials != null) {
      _selectedMaterials.clear();
      _selectedMaterials.addAll(widget.earringMaterials!);
    }
    // Initialize ring sizes
    if (widget.onRingSizesChanged != null && widget.ringSizes != null) {
      widget.ringSizes!.forEach((key, value) {
        if (_ringSizeControllers.containsKey(key)) {
          _ringSizeControllers[key]!.text = value.toString();
        }
      });
    }
    // Initialize chain options
    if (widget.onChainLengthsChanged != null && widget.chainOptions != null) {
      _selectedChainLengths.clear();
      _selectedChainLengths.addAll(widget.chainOptions!);
    }
    // Initialize leather option
    if (widget.onEnableLeatherChanged != null && widget.leatherOption != null) {
      _enableLeather = widget.leatherOption!;
    }
    // Initialize enable material customization
    if (widget.onEnableMaterialCustomizationChanged != null && widget.enableMaterialCustomization != null) {
      _enableMaterialCustomization = widget.enableMaterialCustomization!;
    }
    // Initialize enable metal chain
    if (widget.onEnableMetalChainChanged != null && widget.enableMetalChain != null) {
      _enableMetalChain = widget.enableMetalChain!;
    }
  }

  @override
  void dispose() {
    _itemsSoldController.dispose();
    for (final controller in _ringSizeControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _updateTotalQuantity() {
    int total = 0;

    // Add ring sizes if rings are selected
    if (_selectedProductType == 'Rings') {
      for (final controller in _ringSizeControllers.values) {
        final qty = int.tryParse(controller.text) ?? 0;
        total += qty;
      }
    } else {
      // For other product types, use the main stock controller
      total = int.tryParse(widget.stockController.text) ?? 0;
    }

    widget.stockController.text = total.toString();
  }

  Widget _buildStockSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.cyan.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Stock Management',
            style: TextStyle(
              color: AppTheme.cyan,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Quantity in Stock
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: widget.stockController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Quantity in Stock',
                    labelStyle: const TextStyle(color: Colors.white70),
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
                      borderSide: const BorderSide(color: AppTheme.cyan),
                    ),
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.05),
                  ),
                  readOnly: _selectedProductType == 'Rings', // Auto-calculated for rings
                  validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                ),
              ),
              const SizedBox(width: 16),
              IconButton(
                onPressed: () => widget.onAdjustStock(-1),
                icon: const Icon(Icons.remove, color: Colors.red),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.red.withValues(alpha: 0.1),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () => widget.onAdjustStock(1),
                icon: const Icon(Icons.add, color: Colors.green),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.green.withValues(alpha: 0.1),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Items Sold
          TextFormField(
            controller: _itemsSoldController,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Items Sold',
              labelStyle: const TextStyle(color: Colors.white70),
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
                borderSide: const BorderSide(color: AppTheme.pink),
              ),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.05),
            ),
          ),

          const SizedBox(height: 16),

          // Available Stock Display
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.black.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Available Stock:',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${(int.tryParse(widget.stockController.text) ?? 0) - (int.tryParse(_itemsSoldController.text) ?? 0)}',
                  style: const TextStyle(
                    color: AppTheme.cyan,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductTypeSection() {
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
            'Product Type',
            style: TextStyle(
              color: AppTheme.purple,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _selectedProductType,
            decoration: InputDecoration(
              labelText: 'Select Product Type',
              labelStyle: const TextStyle(color: Colors.white70),
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
                borderSide: const BorderSide(color: AppTheme.purple),
              ),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.05),
            ),
            dropdownColor: AppTheme.cardDark,
            style: const TextStyle(color: Colors.white),
            items: _productTypes.map((type) {
              return DropdownMenuItem(
                value: type,
                child: Text(type),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedProductType = value!;
                _updateTotalQuantity();
              });
              if (widget.onProductTypeChanged != null) {
                widget.onProductTypeChanged!(value);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEarringMaterials() {
    if (!(_selectedProductType == 'Stud Earrings' || _selectedProductType == 'Dangle Earrings')) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.pink.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Material Customization',
                style: TextStyle(
                  color: AppTheme.pink,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 16),
              Checkbox(
                value: _enableMaterialCustomization,
                onChanged: (value) {
                  setState(() {
                    _enableMaterialCustomization = value ?? false;
                  });
                  if (widget.onEnableMaterialCustomizationChanged != null) widget.onEnableMaterialCustomizationChanged!(_enableMaterialCustomization);
                },
                activeColor: AppTheme.pink,
              ),
              const Text(
                'Enable Material Options',
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
          if (_enableMaterialCustomization) ...[
            const SizedBox(height: 16),
            const Text(
              'Available Materials (check to enable on frontend):',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
            const SizedBox(height: 8),
            ..._selectedMaterials.entries.map((entry) {
              return CheckboxListTile(
                title: Text(
                  entry.key,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
                value: entry.value,
                onChanged: (value) {
                  setState(() {
                    _selectedMaterials[entry.key] = value ?? false;
                  });
                  if (widget.onEarringMaterialsChanged != null) widget.onEarringMaterialsChanged!(_selectedMaterials);
                },
                activeColor: AppTheme.pink,
                checkColor: Colors.white,
                tileColor: Colors.white.withValues(alpha: 0.05),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              );
            }),

            // Price calculation display for Sterling Silver
            if (_selectedMaterials['Sterling Silver +R30'] == true) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.pink.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.pink.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Price Impact:',
                      style: TextStyle(
                        color: AppTheme.pink,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Builder(
                      builder: (context) {
                        final basePrice = double.tryParse(widget.sellingPriceController.text.isNotEmpty ?
                          widget.sellingPriceController.text : '0') ?? 0;
                        final adjustedPrice = basePrice + 30; // Sterling Silver +R30
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Selling Price with Sterling Silver:',
                              style: TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                            Text(
                              'R ${adjustedPrice.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: AppTheme.pink,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '+R30 for Sterling Silver material upgrade',
                      style: TextStyle(color: Colors.white60, fontSize: 10),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildRingSizes() {
    if (_selectedProductType != 'Rings') {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.cyan.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ring Sizes',
            style: TextStyle(
              color: AppTheme.cyan,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Set quantity for each size (0 = out of stock):',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _ringSizeControllers.entries.map((entry) {
              return SizedBox(
                width: 120,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.key,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    TextFormField(
                      controller: entry.value,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                      decoration: InputDecoration(
                        hintText: 'Qty',
                        hintStyle: const TextStyle(color: Colors.white30, fontSize: 10),
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
                        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      ),
                      onChanged: (value) {
                        setState(() {
                          entry.value.text = value;
                          _updateTotalQuantity();
                        });
                        if (widget.onRingSizesChanged != null) {
                          final ringSizes = <String, int>{};
                          _ringSizeControllers.forEach((key, controller) {
                            ringSizes[key] = int.tryParse(controller.text) ?? 0;
                          });
                          widget.onRingSizesChanged!(ringSizes);
                        }
                      },
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildChainOptions() {
    if (_selectedProductType != 'Pendants and Necklaces') {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(top: 16),
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
            'Chain/Leather Options',
            style: TextStyle(
              color: AppTheme.purple,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Metal Chain Option
          Row(
            children: [
              Checkbox(
                value: _enableMetalChain,
                onChanged: (value) {
                  setState(() {
                    _enableMetalChain = value ?? false;
                  });
                  if (widget.onEnableMetalChainChanged != null) widget.onEnableMetalChainChanged!(_enableMetalChain);
                },
                activeColor: AppTheme.purple,
              ),
              const Text(
                'Metal Chain',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),

          if (_enableMetalChain) ...[
            const SizedBox(height: 8),
            const Text(
              'Available Lengths:',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _selectedChainLengths.entries.map((entry) {
                return FilterChip(
                  label: Text(
                    entry.key,
                    style: TextStyle(
                      color: entry.value ? Colors.white : Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                  selected: entry.value,
                  onSelected: (selected) {
                    setState(() {
                      _selectedChainLengths[entry.key] = selected;
                    });
                    if (widget.onChainLengthsChanged != null) widget.onChainLengthsChanged!(_selectedChainLengths);
                  },
                  backgroundColor: Colors.white.withValues(alpha: 0.05),
                  selectedColor: AppTheme.purple.withValues(alpha: 0.3),
                  checkmarkColor: Colors.white,
                );
              }).toList(),
            ),
          ],

          const SizedBox(height: 16),

          // Leather Option
          Row(
            children: [
              Checkbox(
                value: _enableLeather,
                onChanged: (value) {
                  setState(() {
                    _enableLeather = value ?? false;
                  });
                  if (widget.onEnableLeatherChanged != null) widget.onEnableLeatherChanged!(_enableLeather);
                },
                activeColor: AppTheme.purple,
              ),
              const Text(
                'Leather Cord',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),

          if (_enableLeather) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'Princess – 45 cm (automatically included)',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Inventory Management',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),

          // Stock Management
          _buildStockSection(),

          const SizedBox(height: 24),

          // Product Type
          _buildProductTypeSection(),

          // Conditional sections based on product type
          _buildEarringMaterials(),
          _buildRingSizes(),
          _buildChainOptions(),
        ],
      ),
    );
  }
}
