import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/currency_service.dart';

class GiftProgressBar extends StatefulWidget {
  final double currentAmount;
  final String currency;

  const GiftProgressBar({
    super.key,
    required this.currentAmount,
    required this.currency,
  });

  @override
  State<GiftProgressBar> createState() => _GiftProgressBarState();
}

class _GiftProgressBarState extends State<GiftProgressBar>
    with TickerProviderStateMixin {
  late AnimationController _giftPulseController;
  late AnimationController _shippingPulseController;
  bool _giftMilestoneReached = false;
  bool _shippingMilestoneReached = false;

  @override
  void initState() {
    super.initState();
    _giftPulseController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _shippingPulseController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _checkMilestones();
  }

  @override
  void didUpdateWidget(GiftProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentAmount != widget.currentAmount) {
      _checkMilestones();
    }
  }

  void _checkMilestones() {
    final freeGiftTarget = CurrencyService.getFreeGiftTarget(widget.currency);
    final freeShippingTarget =
        CurrencyService.getFreeShippingTarget(widget.currency);

    // Check gift milestone
    if (widget.currentAmount >= freeGiftTarget && !_giftMilestoneReached) {
      setState(() => _giftMilestoneReached = true);
      _giftPulseController.repeat(reverse: true);
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          _giftPulseController.stop();
        }
      });
    }

    // Check shipping milestone
    if (widget.currentAmount >= freeShippingTarget &&
        !_shippingMilestoneReached) {
      setState(() => _shippingMilestoneReached = true);
      _shippingPulseController.repeat(reverse: true);
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          _shippingPulseController.stop();
        }
      });
    }
  }

  @override
  void dispose() {
    _giftPulseController.dispose();
    _shippingPulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final freeGiftTarget = CurrencyService.getFreeGiftTarget(widget.currency);
    final freeShippingTarget =
        CurrencyService.getFreeShippingTarget(widget.currency);

    final giftProgress = (widget.currentAmount / freeGiftTarget).clamp(0.0, 1.0);
    final shippingProgress =
        (widget.currentAmount / freeShippingTarget).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.zinc900,
        border: Border(
          bottom: BorderSide(
            color: AppTheme.cardBorder,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Gift Icon
              _buildMilestoneIcon(
                icon: Icons.card_giftcard,
                isReached: _giftMilestoneReached,
                controller: _giftPulseController,
              ),
              const SizedBox(width: 12),
              // Progress Bar
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Free Gift',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.8),
                            fontFamily: 'IndieFlower',
                          ),
                        ),
                        Text(
                          CurrencyService.formatCurrency(
                              freeGiftTarget, widget.currency),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.8),
                            fontFamily: 'IndieFlower',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    _buildProgressBar(giftProgress),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Shipping Icon
              _buildMilestoneIcon(
                icon: Icons.local_shipping,
                isReached: _shippingMilestoneReached,
                controller: _shippingPulseController,
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Shipping Progress
          Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Free Shipping',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.8),
                        fontFamily: 'IndieFlower',
                      ),
                    ),
                    Text(
                      CurrencyService.formatCurrency(
                          freeShippingTarget, widget.currency),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.8),
                        fontFamily: 'IndieFlower',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          _buildProgressBar(shippingProgress),
        ],
      ),
    );
  }

  Widget _buildMilestoneIcon({
    required IconData icon,
    required bool isReached,
    required AnimationController controller,
  }) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final scale = isReached ? 1.0 + (controller.value * 0.2) : 1.0;
        return Transform.scale(
          scale: scale,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: isReached
                  ? AppTheme.vaultGradient()
                  : LinearGradient(
                      colors: [
                        Colors.grey.withOpacity(0.3),
                        Colors.grey.withOpacity(0.1),
                      ],
                    ),
              boxShadow: isReached
                  ? [
                      BoxShadow(
                        color: AppTheme.pink.withOpacity(0.5),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: Icon(
              icon,
              color: isReached ? Colors.white : Colors.grey,
              size: 24,
            ),
          ),
        );
      },
    );
  }

  Widget _buildProgressBar(double progress) {
    return Container(
      height: 8,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.transparent,
          valueColor: AlwaysStoppedAnimation<Color>(
            progress >= 1.0
                ? AppTheme.green
                : Color.lerp(
                    AppTheme.pink,
                    AppTheme.cyan,
                    progress,
                  )!,
          ),
        ),
      ),
    );
  }
}
