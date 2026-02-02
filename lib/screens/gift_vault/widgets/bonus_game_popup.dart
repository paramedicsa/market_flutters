import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/currency_service.dart';
import '../../../utils/viral_share_service.dart';

class BonusGamePopup extends StatefulWidget {
  final String userName;
  final String userId;
  final String currency;
  final VoidCallback onComplete;

  const BonusGamePopup({
    super.key,
    required this.userName,
    required this.userId,
    required this.currency,
    required this.onComplete,
  });

  @override
  State<BonusGamePopup> createState() => _BonusGamePopupState();
}

class _BonusGamePopupState extends State<BonusGamePopup>
    with TickerProviderStateMixin {
  int _completedShares = 0;
  double _earnedCredit = 0.0;
  final List<AnimationController> _bubbleControllers = [];
  bool _isSharing = false;

  @override
  void initState() {
    super.initState();
    // Create animation controllers for each bubble
    for (int i = 0; i < 5; i++) {
      final controller = AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: this,
      );
      _bubbleControllers.add(controller);
    }
  }

  @override
  void dispose() {
    for (final controller in _bubbleControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _handleShare() async {
    if (_isSharing || _completedShares >= 5) return;

    setState(() => _isSharing = true);

    try {
      // Note: ShareResultStatus.success only indicates the share sheet was presented,
      // not that content was actually shared. This is a limitation of the share_plus
      // package. For production, consider server-side validation via deep link tracking.
      final result = await ViralShareService.shareWithResult(
        userName: widget.userName,
        referrerId: widget.userId,
        baseUrl: 'https://spoilmevintage.com',
      );

      if (result.status == ShareResultStatus.success) {
        // Animate the bubble
        if (_completedShares < 5) {
          await _bubbleControllers[_completedShares].forward();
        }

        setState(() {
          _completedShares++;
          _earnedCredit += CurrencyService.getShareReward(widget.currency);
        });

        if (_completedShares >= 5) {
          // All bubbles filled - show completion
          Future.delayed(const Duration(seconds: 1), () {
            widget.onComplete();
          });
        }
      }
    } catch (e) {
      debugPrint('Share failed: $e');
    } finally {
      setState(() => _isSharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        decoration: BoxDecoration(
          color: AppTheme.zinc900,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            width: 3,
            color: AppTheme.pink,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.pink.withOpacity(0.5),
              blurRadius: 30,
              spreadRadius: 5,
            ),
          ],
        ),
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Text(
              '🎁 BONUS GAME 🎁',
              style: TextStyle(
                fontFamily: 'CherryCreamSoda',
                fontSize: 32,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Share 5 times to unlock the Bonus Vault!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'IndieFlower',
                fontSize: 18,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 32),
            // Credit Bubbles
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: _buildCreditBubble(index),
                );
              }),
            ),
            const SizedBox(height: 24),
            // Earned Credit Display
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                gradient: AppTheme.vaultGradient(),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Earned: ${CurrencyService.formatCurrency(_earnedCredit, widget.currency)}',
                style: const TextStyle(
                  fontFamily: 'IndieFlower',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Share Button
            if (_completedShares < 5)
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isSharing ? null : _handleShare,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.pink,
                    disabledBackgroundColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isSharing
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'SHARE NOW (${5 - _completedShares} left)',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'CherryCreamSoda',
                          ),
                        ),
                ),
              )
            else
              // Completion Message
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.green, width: 2),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: AppTheme.green,
                      size: 48,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Unlocking Bonus Vault...',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'CherryCreamSoda',
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            // Close Button
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                _completedShares >= 5 ? 'Continue' : 'Maybe Later',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontFamily: 'IndieFlower',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreditBubble(int index) {
    final isCompleted = index < _completedShares;
    final controller = _bubbleControllers[index];

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final scale = isCompleted ? 1.0 + (controller.value * 0.2) : 1.0;
        return Transform.scale(
          scale: scale,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: isCompleted
                  ? AppTheme.vaultGradient()
                  : LinearGradient(
                      colors: [
                        Colors.grey.withOpacity(0.3),
                        Colors.grey.withOpacity(0.1),
                      ],
                    ),
              border: Border.all(
                color: isCompleted ? AppTheme.pink : Colors.grey,
                width: 2,
              ),
              boxShadow: isCompleted
                  ? [
                      BoxShadow(
                        color: AppTheme.pink.withOpacity(0.6),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: isCompleted
                  ? const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 28,
                    )
                  : Text(
                      CurrencyService.formatCurrency(
                        CurrencyService.getShareReward(widget.currency),
                        widget.currency,
                      ),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}
