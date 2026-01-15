import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class GiftsTab extends StatelessWidget {
  final bool allowGiftWrap;
  final bool allowGiftMessage;
  final Function(bool) onGiftWrapChanged;
  final Function(bool) onGiftMessageChanged;

  const GiftsTab({
    super.key,
    required this.allowGiftWrap,
    required this.allowGiftMessage,
    required this.onGiftWrapChanged,
    required this.onGiftMessageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Gift Options',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Gift Packaging',
                  style: TextStyle(
                    color: AppTheme.purple,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Gift Box Compatible', style: TextStyle(color: Colors.white)),
                  subtitle: const Text('Can be packaged in gift boxes', style: TextStyle(color: Colors.white70)),
                  value: allowGiftWrap,
                  onChanged: onGiftWrapChanged,
                  activeThumbColor: AppTheme.purple,
                ),
                SwitchListTile(
                  title: const Text('Allow Gift Message', style: TextStyle(color: Colors.white)),
                  subtitle: const Text('Customers can add personalized messages', style: TextStyle(color: Colors.white70)),
                  value: allowGiftMessage,
                  onChanged: onGiftMessageChanged,
                  activeThumbColor: AppTheme.purple,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
