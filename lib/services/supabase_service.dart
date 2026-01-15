import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/artist_application.dart';
import '../models/artist_notification.dart';

class SupabaseService {
  final _client = Supabase.instance.client;

  Future<void> submitArtistApplication(ArtistApplication app) async {
    await _client.from('artist_applications').insert(app.toJson());
  }

  Future<List<ArtistApplication>> fetchArtistApplications({String? status}) async {
    final query = _client.from('artist_applications').select();
    if (status != null) {
      query.eq('status', status);
    }
    final data = await query;
    return (data as List).map((e) => ArtistApplication.fromJson(e)).toList();
  }

  Future<void> updateArtistApplicationStatus(String id, String status, {String? denialReason}) async {
    await _client.from('artist_applications').update({
      'status': status,
      'denial_reason': denialReason,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', id);
  }

  Future<void> deleteArtistApplication(String id) async {
    await _client.from('artist_applications').delete().eq('id', id);
  }

  Future<void> sendNotification(ArtistNotification notification) async {
    await _client.from('artist_notifications').insert(notification.toJson());
  }

  Future<List<ArtistNotification>> fetchNotifications(String artistApplicationId) async {
    final data = await _client.from('artist_notifications')
      .select()
      .eq('artist_application_id', artistApplicationId);
    return (data as List).map((e) => ArtistNotification.fromJson(e)).toList();
  }
}

