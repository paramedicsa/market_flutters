import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../artist_dashboard.dart';
import '../admin_artist_applications.dart';

class ArtistsScreen extends StatelessWidget {
  const ArtistsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Artist Management'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 24),
          Center(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.dashboard, color: Colors.white),
              label: const Text('Artist Dashboard', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.cyan,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const ArtistDashboardScreen()),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          const Expanded(
            child: AdminArtistApplicationsScreen(),
          ),
        ],
      ),
    );
  }
}
