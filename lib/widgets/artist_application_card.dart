import 'package:flutter/material.dart';
import '../models/artist_application.dart';

class ArtistApplicationCard extends StatelessWidget {
  final ArtistApplication application;
  final VoidCallback? onApprove;
  final VoidCallback? onDeny;
  final VoidCallback? onDelete;
  const ArtistApplicationCard({super.key, required this.application, this.onApprove, this.onDeny, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withValues(alpha: 0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.white, width: 1),
      ),
      elevation: 8,
      shadowColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${application.name} ${application.surname}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            Text(application.email, style: const TextStyle(color: Colors.white70)),
            Text('WhatsApp: ${application.countryCode} ${application.whatsapp}', style: const TextStyle(color: Colors.white70)),
            Text('Country: ${application.country}', style: const TextStyle(color: Colors.white70)),
            Text('Artist Name: ${application.artistName}', style: const TextStyle(color: Colors.white)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: application.imageUrls.map((url) => Image.network(url, width: 60, height: 60)).toList(),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                if (onApprove != null)
                  ElevatedButton(
                    onPressed: onApprove,
                    child: const Text('Approve'),
                  ),
                if (onDeny != null)
                  ElevatedButton(
                    onPressed: onDeny,
                    child: const Text('Deny'),
                  ),
                if (onDelete != null)
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: onDelete,
                  ),
              ],
            ),
            if (application.denialReason != null && application.denialReason!.isNotEmpty)
              Text('Denied: ${application.denialReason}', style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
