import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/supabase_service.dart';
import '../../models/gift_vault_order.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  bool _isLoading = true;
  Map<String, List<GiftVaultOrder>> _groupedOrders = {};
  String _selectedView = 'all'; // 'all' or 'grouped'

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() => _isLoading = true);
    
    try {
      final grouped = await _supabaseService.fetchGroupedOrders();
      setState(() {
        _groupedOrders = grouped;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading orders: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.purple.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                          border: Border.all(color: AppTheme.purple, width: 3),
                        ),
                        child: const Icon(
                          Icons.shopping_cart,
                          size: 32,
                          color: AppTheme.purple,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Order Management',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Track and manage Gift Vault orders grouped by customer',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: _loadOrders,
                        tooltip: 'Refresh Orders',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // View Toggle
                  Row(
                    children: [
                      _buildViewButton('All Orders', 'all'),
                      const SizedBox(width: 8),
                      _buildViewButton('Grouped by Customer', 'grouped'),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(color: AppTheme.cardBorder),
            // Content
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _selectedView == 'grouped'
                      ? _buildGroupedView()
                      : _buildAllOrdersView(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildViewButton(String label, String value) {
    final isSelected = _selectedView == value;
    return ElevatedButton(
      onPressed: () => setState(() => _selectedView = value),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? AppTheme.purple : AppTheme.cardDark,
        foregroundColor: Colors.white,
      ),
      child: Text(label),
    );
  }

  Widget _buildGroupedView() {
    if (_groupedOrders.isEmpty) {
      return const Center(
        child: Text(
          'No orders yet',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: _groupedOrders.length,
      itemBuilder: (context, index) {
        final entry = _groupedOrders.entries.elementAt(index);
        final groupId = entry.key;
        final orders = entry.value;
        return _buildCustomerGroup(groupId, orders);
      },
    );
  }

  Widget _buildCustomerGroup(String groupId, List<GiftVaultOrder> orders) {
    // Group orders by tier
    final starterOrders = orders.where((o) => o.tier == 'starter').toList();
    final premiumOrders = orders.where((o) => o.tier == 'premium').toList();
    final bonusOrders = orders.where((o) => o.tier == 'bonus').toList();

    final totalSpent = orders.fold<double>(
      0.0,
      (sum, order) => sum + order.totalAmount,
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: AppTheme.cardDark,
      child: ExpansionTile(
        title: Text(
          groupId,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          'Total Spent: ${orders.isNotEmpty ? _formatCurrency(totalSpent, orders.first.currency) : ""}',
          style: const TextStyle(color: Colors.white70),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (starterOrders.isNotEmpty) ...[
                  _buildTierSection('Tier 1 (Starter)', starterOrders, AppTheme.pink),
                  const SizedBox(height: 16),
                ],
                if (premiumOrders.isNotEmpty) ...[
                  _buildTierSection('Tier 2 (Premium)', premiumOrders, AppTheme.purple),
                  const SizedBox(height: 16),
                ],
                if (bonusOrders.isNotEmpty) ...[
                  _buildTierSection('Bonus Tier', bonusOrders, AppTheme.cyan),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTierSection(String title, List<GiftVaultOrder> orders, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          ...orders.map((order) => _buildOrderItem(order)),
        ],
      ),
    );
  }

  Widget _buildOrderItem(GiftVaultOrder order) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            Icons.circle,
            size: 8,
            color: Colors.white.withOpacity(0.5),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '${order.productIds.length} items - ${_formatCurrency(order.totalAmount, order.currency)}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ),
          Text(
            _formatDate(order.createdAt),
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllOrdersView() {
    final allOrders = _groupedOrders.values.expand((list) => list).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    if (allOrders.isEmpty) {
      return const Center(
        child: Text(
          'No orders yet',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: allOrders.length,
      itemBuilder: (context, index) {
        final order = allOrders[index];
        return _buildOrderCard(order);
      },
    );
  }

  Widget _buildOrderCard(GiftVaultOrder order) {
    Color tierColor;
    switch (order.tier) {
      case 'premium':
        tierColor = AppTheme.purple;
        break;
      case 'bonus':
        tierColor = AppTheme.cyan;
        break;
      default:
        tierColor = AppTheme.pink;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: AppTheme.cardDark,
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: tierColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: tierColor, width: 2),
          ),
          child: Center(
            child: Text(
              order.tier[0].toUpperCase(),
              style: TextStyle(
                color: tierColor,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ),
        title: Text(
          order.groupId,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          '${order.productIds.length} items • ${order.tier.toUpperCase()}',
          style: const TextStyle(color: Colors.white70),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              _formatCurrency(order.totalAmount, order.currency),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              _formatDate(order.createdAt),
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatCurrency(double amount, String currency) {
    if (currency == 'USD') {
      return '\$${amount.toStringAsFixed(2)}';
    }
    return 'R${amount.toStringAsFixed(2)}';
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
