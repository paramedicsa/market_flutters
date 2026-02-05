import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../gift_vault/evening_gift/evening_free_gift_tier1_screen.dart';

/// Main Gift Vault Admin Screen with Tabs
class GiftVaultScreen extends StatefulWidget {
  const GiftVaultScreen({super.key});

  @override
  State<GiftVaultScreen> createState() => _GiftVaultScreenState();
}

class _GiftVaultScreenState extends State<GiftVaultScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.black,
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.cyan.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppTheme.cyan, width: 2),
                      ),
                      child: const Icon(
                        Icons.card_giftcard,
                        size: 32,
                        color: AppTheme.cyan,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Gift Vault Management',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Manage gift vault events and previews',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Tab Bar
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              border: Border(
                bottom: BorderSide(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorColor: AppTheme.cyan,
              labelColor: AppTheme.cyan,
              unselectedLabelColor: Colors.white60,
              tabs: const [
                Tab(text: 'Dashboard'),
                Tab(text: 'Page Previews'),
              ],
            ),
          ),

          // Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                VaultDashboardTab(),
                PagePreviewsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Dashboard Tab - Placeholder for future functionality
class VaultDashboardTab extends StatelessWidget {
  const VaultDashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.dashboard,
            size: 64,
            color: Colors.white.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'Dashboard Coming Soon',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}

/// Page Previews Tab - Preview different gift vault screens
class PagePreviewsTab extends StatelessWidget {
  const PagePreviewsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Screen Previews',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Click below to preview the specific screens in isolation.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white60,
            ),
          ),
          const SizedBox(height: 24),
          _buildPageButtons(context),
        ],
      ),
    );
  }

  Widget _buildPageButtons(BuildContext context) {
    final List<Map<String, dynamic>> pages = [
      {
        'title': 'Evening Gift Tier 1 (Select 2)',
        'description': 'Preview the Evening Free Gift Tier 1 screen with select 2 functionality',
        'icon': Icons.night_shelter,
        'screen': Builder(
          builder: (previewContext) => Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              title: const Text("Preview Mode"),
              backgroundColor: Colors.black,
            ),
            body: EveningFreeGiftTier1Screen(
              matrixType: 'evening',
              onConfirmSelection: (products) {
                showDialog(
                  context: previewContext,
                  builder: (dialogContext) => AlertDialog(
                    title: const Text("Success!"),
                    content: Text(
                      "You selected ${products.length} items:\n\n${products.map((p) => p.name).join('\n')}",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        child: const Text("OK"),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      },
      {
        'title': 'Evening Gift Tier 2 (Select 3)',
        'description': 'Preview the Evening Free Gift Tier 2 screen',
        'icon': Icons.nights_stay,
        'screen': const Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: Text(
              'Evening Tier 2 Screen\n(Coming Soon)',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ),
      },
      {
        'title': 'Evening Bonus Gift',
        'description': 'Preview the Evening Bonus Gift screen',
        'icon': Icons.star,
        'screen': const Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: Text(
              'Evening Bonus Gift Screen\n(Coming Soon)',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ),
      },
      {
        'title': 'Saturday Gift Event',
        'description': 'Preview the Saturday Gift Event screen',
        'icon': Icons.weekend,
        'screen': const Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: Text(
              'Saturday Gift Event Screen\n(Coming Soon)',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ),
      },
    ];

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: pages.map((page) {
        return SizedBox(
          width: (MediaQuery.of(context).size.width - 80) / 2,
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => page['screen'] as Widget,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2A2A2A), // Dark grey for admin buttons
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Color(0xFFFF0080), width: 1),
              ),
              elevation: 4,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  page['icon'] as IconData,
                  size: 32,
                  color: const Color(0xFFFF0080),
                ),
                const SizedBox(height: 12),
                Text(
                  page['title'] as String,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  page['description'] as String,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
