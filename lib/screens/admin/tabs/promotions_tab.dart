import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class PromotionsTab extends StatefulWidget {
  final bool isPromotionActive;
  final DateTime? promotionStart;
  final DateTime? promotionEnd;
  final double? promoPriceZar;
  final double? promoPriceUsd;
  final Function(bool)? onPromotionActiveChanged;
  final Function(DateTime?)? onPromotionStartChanged;
  final Function(DateTime?)? onPromotionEndChanged;
  final Function(double?)? onPromoPriceZarChanged;
  final Function(double?)? onPromoPriceUsdChanged;

  const PromotionsTab({
    super.key,
    required this.isPromotionActive,
    this.promotionStart,
    this.promotionEnd,
    this.promoPriceZar,
    this.promoPriceUsd,
    this.onPromotionActiveChanged,
    this.onPromotionStartChanged,
    this.onPromotionEndChanged,
    this.onPromoPriceZarChanged,
    this.onPromoPriceUsdChanged,
  });

  @override
  State<PromotionsTab> createState() => _PromotionsTabState();
}

class _PromotionsTabState extends State<PromotionsTab> {
  late bool _isPromotionActive;
  DateTime? _promotionStart;
  DateTime? _promotionEnd;
  final TextEditingController _promoPriceZarController = TextEditingController();
  final TextEditingController _promoPriceUsdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _isPromotionActive = widget.isPromotionActive;
    _promotionStart = widget.promotionStart;
    _promotionEnd = widget.promotionEnd;
    _promoPriceZarController.text = widget.promoPriceZar?.toString() ?? '';
    _promoPriceUsdController.text = widget.promoPriceUsd?.toString() ?? '';
  }

  @override
  void dispose() {
    _promoPriceZarController.dispose();
    _promoPriceUsdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Promotions & Deals',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          SwitchListTile(
            title: const Text('Activate Promotion', style: TextStyle(color: Colors.white)),
            value: _isPromotionActive,
            onChanged: (value) {
              setState(() => _isPromotionActive = value);
              if (widget.onPromotionActiveChanged != null) widget.onPromotionActiveChanged!(value);
            },
            activeThumbColor: AppTheme.pink,
          ),
          if (_isPromotionActive) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _promoPriceZarController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Promo Price (ZAR)',
                      labelStyle: TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.white10,
                    ),
                    style: const TextStyle(color: Colors.white),
                    onChanged: (value) {
                      final price = double.tryParse(value);
                      if (widget.onPromoPriceZarChanged != null) widget.onPromoPriceZarChanged!(price);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _promoPriceUsdController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Promo Price (USD)',
                      labelStyle: TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.white10,
                    ),
                    style: const TextStyle(color: Colors.white),
                    onChanged: (value) {
                      final price = double.tryParse(value);
                      if (widget.onPromoPriceUsdChanged != null) widget.onPromoPriceUsdChanged!(price);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: const Text('Start Date', style: TextStyle(color: Colors.white)),
                    subtitle: Text(_promotionStart != null ? _promotionStart!.toLocal().toString().split(' ')[0] : 'Not set', style: const TextStyle(color: Colors.white70)),
                    trailing: IconButton(
                      icon: const Icon(Icons.calendar_today, color: AppTheme.pink),
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _promotionStart ?? DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          setState(() => _promotionStart = picked);
                          if (widget.onPromotionStartChanged != null) widget.onPromotionStartChanged!(picked);
                        }
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: const Text('End Date', style: TextStyle(color: Colors.white)),
                    subtitle: Text(_promotionEnd != null ? _promotionEnd!.toLocal().toString().split(' ')[0] : 'Not set', style: const TextStyle(color: Colors.white70)),
                    trailing: IconButton(
                      icon: const Icon(Icons.calendar_today, color: AppTheme.pink),
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _promotionEnd ?? DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          setState(() => _promotionEnd = picked);
                          if (widget.onPromotionEndChanged != null) widget.onPromotionEndChanged!(picked);
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
