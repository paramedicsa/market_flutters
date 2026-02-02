import 'package:flutter/material.dart';
import 'dart:async';
import '../../theme/app_theme.dart';
import '../../models/product.dart';
import '../../models/user_wallet.dart';
import '../../services/supabase_service.dart';
import '../../utils/currency_service.dart';
import 'widgets/vault_door.dart';
import 'widgets/gift_progress_bar.dart';
import 'widgets/magic_dust.dart';
import 'widgets/bonus_game_popup.dart';

class GiftVaultScreen extends StatefulWidget {
  final String userId;
  final String userEmail;
  final String userName;
  final String currency;

  const GiftVaultScreen({
    super.key,
    required this.userId,
    required this.userEmail,
    required this.userName,
    this.currency = 'ZAR',
  });

  @override
  State<GiftVaultScreen> createState() => _GiftVaultScreenState();
}

class _GiftVaultScreenState extends State<GiftVaultScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  
  // Timer states
  Timer? _selectionTimer;
  Timer? _paymentTimer;
  Timer? _questTimer;
  int _selectionSecondsRemaining = 20 * 60; // 20 minutes
  int _paymentSecondsRemaining = 0;
  int _questSecondsRemaining = 0;

  // UI state
  bool _isDoorsOpen = false;
  bool _isLoading = true;
  String _currentTier = 'starter';
  List<Product> _products = [];
  List<Product> _selectedProducts = [];
  double _currentTotal = 0.0;
  UserWallet? _userWallet;
  bool _hasReservedGift = false;

  @override
  void initState() {
    super.initState();
    _checkAccessTime();
    _loadData();
  }

  @override
  void dispose() {
    _selectionTimer?.cancel();
    _paymentTimer?.cancel();
    _questTimer?.cancel();
    super.dispose();
  }

  bool get _isEvening {
    final hour = DateTime.now().hour;
    return hour >= 18 || hour < 6; // 6PM - 6AM
  }

  bool get _isSaturday {
    return DateTime.now().weekday == DateTime.saturday;
  }

  void _checkAccessTime() {
    if (!_isEvening && !_isSaturday) {
      // Show dialog that vault is closed
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showVaultClosedDialog();
      });
    } else {
      setState(() => _isDoorsOpen = true);
      if (!_hasReservedGift) {
        _startSelectionTimer();
      }
    }
  }

  void _showVaultClosedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.zinc900,
        title: const Text(
          '🔒 Vault Closed',
          style: TextStyle(
            fontFamily: 'CherryCreamSoda',
            color: Colors.white,
          ),
        ),
        content: Text(
          'The Gift Vault is only open:\n• Every evening (6PM - 6AM)\n• All day Saturday\n\nCome back during these times!',
          style: TextStyle(
            fontFamily: 'IndieFlower',
            color: Colors.white.withOpacity(0.9),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    try {
      // Load products for current tier
      final products =
          await _supabaseService.fetchProductsByFunnelTier(_currentTier);
      
      // Load user wallet
      final wallet = await _supabaseService.fetchUserWallet(widget.userId);

      setState(() {
        _products = products;
        _userWallet = wallet;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading data: $e');
      setState(() => _isLoading = false);
    }
  }

  void _startSelectionTimer() {
    _selectionTimer?.cancel();
    _selectionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _selectionSecondsRemaining--;
        if (_selectionSecondsRemaining <= 0) {
          timer.cancel();
          _handleTimerExpired();
        }
      });
    });
  }

  void _handleTimerExpired() {
    // Slam doors shut
    setState(() => _isDoorsOpen = false);
    
    // Show expiration message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('⏰ Time\'s up! The vault has closed.'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _handleProductTap(Product product, BuildContext context) {
    // Get product position for animation
    final RenderBox? box = context.findRenderObject() as RenderBox?;
    if (box == null) return;

    final position = box.localToGlobal(Offset.zero);
    final size = box.size;
    
    // Calculate start and end positions for fly animation
    final startPos = Offset(
      position.dx + size.width / 2,
      position.dy + size.height / 2,
    );
    final endPos = const Offset(100, 50); // Top tray position

    // Show magic dust animation
    MagicDustOverlay.showFlyAnimation(
      context: context,
      startPosition: startPos,
      endPosition: endPos,
      productImage: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: product.imageUrl != null
              ? DecorationImage(
                  image: NetworkImage(product.imageUrl!),
                  fit: BoxFit.cover,
                )
              : null,
          color: product.imageUrl == null ? Colors.grey : null,
        ),
      ),
      onComplete: () {
        setState(() {
          _selectedProducts.add(product);
          _currentTotal += product.price;
        });
      },
    );
  }

  void _handleSecureGifts() async {
    final starterTarget =
        CurrencyService.getStarterTarget(widget.currency);
    
    if (_currentTotal < starterTarget) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Minimum spend: ${CurrencyService.formatCurrency(starterTarget, widget.currency)}',
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Show fork in the road dialog
    _showForkInRoadDialog();
  }

  void _showForkInRoadDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '✨ Choose Your Path ✨',
                style: TextStyle(
                  fontFamily: 'CherryCreamSoda',
                  fontSize: 32,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  // Standard Path
                  Expanded(
                    child: _buildPathCard(
                      title: 'Standard',
                      subtitle: 'Pay Shipping\n& Finish',
                      color: Colors.grey,
                      onTap: () {
                        Navigator.pop(context);
                        _completeOrder('starter');
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Hero Path
                  Expanded(
                    child: _buildPathCard(
                      title: 'UNLOCK TIER 2',
                      subtitle: 'GET FREE\nSHIPPING',
                      color: AppTheme.pink,
                      isHero: true,
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          _currentTier = 'premium';
                        });
                        _loadData();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPathCard({
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
    bool isHero = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.zinc900,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color,
            width: isHero ? 3 : 2,
          ),
          gradient: isHero ? AppTheme.vaultGradient() : null,
          boxShadow: isHero
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.5),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'CherryCreamSoda',
                fontSize: isHero ? 24 : 20,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'IndieFlower',
                fontSize: 16,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _completeOrder(String tier) async {
    // Show bonus game popup
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => BonusGamePopup(
        userName: widget.userName,
        userId: widget.userId,
        currency: widget.currency,
        onComplete: () {
          Navigator.pop(context);
          // Navigate to bonus vault
          setState(() {
            _currentTier = 'bonus';
          });
          _loadData();
        },
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  bool get _isTimerCritical => _selectionSecondsRemaining < 120; // Less than 2 min

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.zinc900,
      appBar: AppBar(
        backgroundColor: AppTheme.black,
        title: const Text(
          'Gift Vault Quest',
          style: TextStyle(
            fontFamily: 'CherryCreamSoda',
            color: Colors.white,
          ),
        ),
        actions: [
          // Timer display
          if (_selectionSecondsRemaining > 0)
            Center(
              child: Container(
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: _isTimerCritical ? Colors.red : AppTheme.cardDark,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _isTimerCritical ? Colors.red : AppTheme.pink,
                    width: 2,
                  ),
                ),
                child: Text(
                  _formatTime(_selectionSecondsRemaining),
                  style: TextStyle(
                    fontFamily: 'CherryCreamSoda',
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Progress Bar
          GiftProgressBar(
            currentAmount: _currentTotal,
            currency: widget.currency,
          ),
          // Main content
          Expanded(
            child: Stack(
              children: [
                // Product Grid
                _buildProductGrid(),
                // Vault Doors Overlay
                if (!_isDoorsOpen)
                  Positioned.fill(
                    child: VaultDoor(
                      isOpen: _isDoorsOpen,
                    ),
                  ),
              ],
            ),
          ),
          // Bottom Action Bar
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildProductGrid() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _products.length,
      itemBuilder: (context, index) {
        final product = _products[index];
        return _buildProductCard(product);
      },
    );
  }

  Widget _buildProductCard(Product product) {
    return Builder(
      builder: (context) {
        return GestureDetector(
          onTap: () => _handleProductTap(product, context),
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.cardDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.pink,
                width: 3,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(9),
                      ),
                      image: product.imageUrl != null
                          ? DecorationImage(
                              image: NetworkImage(product.imageUrl!),
                              fit: BoxFit.cover,
                            )
                          : null,
                      color: product.imageUrl == null ? Colors.grey : null,
                    ),
                  ),
                ),
                // Product Info
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'IndieFlower',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        CurrencyService.formatCurrency(
                          product.price,
                          widget.currency,
                        ),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.pink,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomBar() {
    final starterTarget = CurrencyService.getStarterTarget(widget.currency);
    final canSecure = _currentTotal >= starterTarget;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.black,
        border: Border(
          top: BorderSide(
            color: AppTheme.cardBorder,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Total Display
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.7),
                      fontFamily: 'IndieFlower',
                    ),
                  ),
                  Text(
                    CurrencyService.formatCurrency(
                      _currentTotal,
                      widget.currency,
                    ),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'CherryCreamSoda',
                    ),
                  ),
                ],
              ),
            ),
            // Secure Button
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: canSecure ? _handleSecureGifts : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: canSecure ? AppTheme.pink : Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                ),
                child: const Text(
                  'SECURE MY GIFTS',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'CherryCreamSoda',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
