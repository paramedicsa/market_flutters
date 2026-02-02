import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../screens/gift_vault/gift_vault_screen.dart';
import 'dart:async';

/// A promotional banner widget for the Gift Vault Quest
/// 
/// This widget displays an animated banner that promotes the Gift Vault
/// feature and shows when it's available. It can be placed at the top
/// of your home screen or product listing pages.
/// 
/// Usage:
/// ```dart
/// GiftVaultPromoBanner(
///   userId: currentUser.id,
///   userEmail: currentUser.email,
///   userName: currentUser.name,
///   currency: 'ZAR',
/// )
/// ```
class GiftVaultPromoBanner extends StatefulWidget {
  final String userId;
  final String userEmail;
  final String userName;
  final String currency;
  final bool isDismissible;

  const GiftVaultPromoBanner({
    super.key,
    required this.userId,
    required this.userEmail,
    required this.userName,
    this.currency = 'ZAR',
    this.isDismissible = true,
  });

  @override
  State<GiftVaultPromoBanner> createState() => _GiftVaultPromoBannerState();
}

class _GiftVaultPromoBannerState extends State<GiftVaultPromoBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  bool _isDismissed = false;
  Timer? _timeCheckTimer;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    // Check time every minute to update availability
    _timeCheckTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _timeCheckTimer?.cancel();
    super.dispose();
  }

  bool get _isVaultOpen {
    final hour = DateTime.now().hour;
    final isEvening = hour >= 18 || hour < 6;
    final isSaturday = DateTime.now().weekday == DateTime.saturday;
    return isEvening || isSaturday;
  }

  String get _availabilityText {
    if (_isVaultOpen) {
      return '🔓 OPEN NOW';
    }
    
    final now = DateTime.now();
    if (now.weekday == DateTime.saturday) {
      return '🔓 Open all day!';
    }
    
    final hour = now.hour;
    if (hour < 6) {
      final hoursUntilClose = 6 - hour;
      return '⏰ Closes in $hoursUntilClose hours';
    } else if (hour < 18) {
      final hoursUntilOpen = 18 - hour;
      return '⏰ Opens in $hoursUntilOpen hours';
    } else {
      // Evening - open until 6 AM
      final hoursUntilClose = 24 - hour + 6;
      return '⏰ Closes in $hoursUntilClose hours';
    }
  }

  void _navigateToVault() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GiftVaultScreen(
          userId: widget.userId,
          userEmail: widget.userEmail,
          userName: widget.userName,
          currency: widget.currency,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isDismissed) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final scale = 1.0 + (_pulseController.value * 0.05);
        
        return Transform.scale(
          scale: _isVaultOpen ? scale : 1.0,
          child: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: _isVaultOpen
                  ? AppTheme.vaultGradient()
                  : LinearGradient(
                      colors: [
                        Colors.grey.shade800,
                        Colors.grey.shade900,
                      ],
                    ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _isVaultOpen ? AppTheme.pink : Colors.grey,
                width: 3,
              ),
              boxShadow: _isVaultOpen
                  ? [
                      BoxShadow(
                        color: AppTheme.pink.withOpacity(0.5),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: Stack(
              children: [
                // Main content
                InkWell(
                  onTap: _navigateToVault,
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        // Icon
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: _isVaultOpen
                                ? Colors.white.withOpacity(0.2)
                                : Colors.grey.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.card_giftcard,
                            size: 32,
                            color: _isVaultOpen ? Colors.white : Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Text content
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '🎁 Gift Vault Quest',
                                style: TextStyle(
                                  fontFamily: 'CherryCreamSoda',
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _availabilityText,
                                style: TextStyle(
                                  fontFamily: 'IndieFlower',
                                  fontSize: 16,
                                  color: _isVaultOpen
                                      ? Colors.white
                                      : Colors.white70,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _isVaultOpen
                                    ? 'Tap to enter before time runs out!'
                                    : 'Available evenings 6PM-6AM & all Saturday',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Arrow icon
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 24,
                        ),
                      ],
                    ),
                  ),
                ),
                // Dismiss button
                if (widget.isDismissible)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.white.withOpacity(0.7),
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() => _isDismissed = true);
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// A compact version of the Gift Vault promo for smaller spaces
class GiftVaultPromoChip extends StatelessWidget {
  final VoidCallback onTap;
  final bool isVaultOpen;

  const GiftVaultPromoChip({
    super.key,
    required this.onTap,
    this.isVaultOpen = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: isVaultOpen
              ? AppTheme.vaultGradient()
              : LinearGradient(
                  colors: [Colors.grey.shade700, Colors.grey.shade800],
                ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isVaultOpen ? AppTheme.pink : Colors.grey,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.card_giftcard,
              color: Colors.white,
              size: 16,
            ),
            const SizedBox(width: 8),
            Text(
              isVaultOpen ? '🎁 Gift Vault OPEN' : '🎁 Gift Vault',
              style: TextStyle(
                fontFamily: 'IndieFlower',
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A floating action button variant for the Gift Vault
class GiftVaultFloatingButton extends StatefulWidget {
  final String userId;
  final String userEmail;
  final String userName;
  final String currency;

  const GiftVaultFloatingButton({
    super.key,
    required this.userId,
    required this.userEmail,
    required this.userName,
    this.currency = 'ZAR',
  });

  @override
  State<GiftVaultFloatingButton> createState() => _GiftVaultFloatingButtonState();
}

class _GiftVaultFloatingButtonState extends State<GiftVaultFloatingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _isVaultOpen {
    final hour = DateTime.now().hour;
    final isEvening = hour >= 18 || hour < 6;
    final isSaturday = DateTime.now().weekday == DateTime.saturday;
    return isEvening || isSaturday;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final scale = _isVaultOpen ? 1.0 + (_controller.value * 0.1) : 1.0;
        
        return Transform.scale(
          scale: scale,
          child: FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GiftVaultScreen(
                    userId: widget.userId,
                    userEmail: widget.userEmail,
                    userName: widget.userName,
                    currency: widget.currency,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.card_giftcard),
            label: Text(
              _isVaultOpen ? '🎁 VAULT OPEN!' : '🎁 Gift Vault',
              style: const TextStyle(
                fontFamily: 'CherryCreamSoda',
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: _isVaultOpen ? AppTheme.pink : Colors.grey,
          ),
        );
      },
    );
  }
}
