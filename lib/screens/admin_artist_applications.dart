import 'package:flutter/material.dart';
import '../models/artist_application.dart';
import '../models/artist_notification.dart';
import '../services/supabase_service.dart';
import '../widgets/artist_application_card.dart';

class AdminArtistApplicationsScreen extends StatefulWidget {
  const AdminArtistApplicationsScreen({super.key});
  @override
  State<AdminArtistApplicationsScreen> createState() => _AdminArtistApplicationsScreenState();
}

class _AdminArtistApplicationsScreenState extends State<AdminArtistApplicationsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final SupabaseService _service = SupabaseService();
  List<ArtistApplication> _pending = [];
  List<ArtistApplication> _approved = [];
  List<ArtistApplication> _denied = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    _pending = await _service.fetchArtistApplications(status: 'pending');
    _approved = await _service.fetchArtistApplications(status: 'approved');
    _denied = await _service.fetchArtistApplications(status: 'denied');
    setState(() => _loading = false);
  }

  void _approve(ArtistApplication app) async {
    await _service.updateArtistApplicationStatus(app.id, 'approved');
    await _service.sendNotification(ArtistNotification(
      id: '',
      artistApplicationId: app.id,
      type: 'approval',
      message: 'Congratulations! Your artist application has been approved. Access your dashboard now.',
      createdAt: DateTime.now(),
      read: false,
    ));
    _load();
  }

  void _deny(ArtistApplication app) async {
    final reason = await _getDenialReason();
    if (reason == null || reason.isEmpty) return;
    await _service.updateArtistApplicationStatus(app.id, 'denied', denialReason: reason);
    await _service.sendNotification(ArtistNotification(
      id: '',
      artistApplicationId: app.id,
      type: 'denial',
      message: 'Your artist application was denied. Reason: $reason',
      createdAt: DateTime.now(),
      read: false,
    ));
    _load();
  }

  void _delete(ArtistApplication app) async {
    await _service.deleteArtistApplication(app.id);
    _load();
  }

  Future<String?> _getDenialReason() async {
    String? reason;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reason for Denial'),
        content: TextField(
          onChanged: (v) => reason = v,
          decoration: const InputDecoration(hintText: 'Enter reason...'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
        ],
      ),
    );
    return reason;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Artist Applications'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Applications'),
            Tab(text: 'Approved'),
            Tab(text: 'Denied'),
          ],
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildList(_pending, true),
                _buildList(_approved, false),
                _buildList(_denied, false),
              ],
            ),
    );
  }

  Widget _buildList(List<ArtistApplication> apps, bool showActions) {
    if (apps.isEmpty) {
      return const Center(child: Text('No applications found', style: TextStyle(color: Colors.white)));
    }
    return ListView(
      children: apps.map((app) => ArtistApplicationCard(
        application: app,
        onApprove: showActions ? () => _approve(app) : null,
        onDeny: showActions ? () => _deny(app) : null,
        onDelete: () => _delete(app),
      )).toList(),
    );
  }
}
