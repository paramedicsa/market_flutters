import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/artist_application.dart';
import '../models/artist_notification.dart';
import '../models/product.dart';
import '../models/user_wallet.dart';
import '../models/gift_vault_order.dart';

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

  // Gift Vault Methods
  Future<List<Product>> fetchProductsByFunnelTier(String funnelTier) async {
    final data = await _client
        .from('products')
        .select()
        .eq('funnel_tier', funnelTier)
        .eq('is_available', true);
    return (data as List).map((e) => Product.fromJson(e)).toList();
  }

  Future<UserWallet?> fetchUserWallet(String userId) async {
    final data = await _client
        .from('user_wallet')
        .select()
        .eq('user_id', userId)
        .maybeSingle();
    
    if (data == null) return null;
    return UserWallet.fromJson(data);
  }

  Future<void> updateUserWallet(UserWallet wallet) async {
    await _client.from('user_wallet').upsert(wallet.toJson());
  }

  Future<void> saveGiftVaultOrder(GiftVaultOrder order) async {
    await _client.from('gift_vault_orders').insert(order.toJson());
  }

  Future<List<GiftVaultOrder>> fetchGiftVaultOrders({String? groupId}) async {
    final query = _client.from('gift_vault_orders').select();
    if (groupId != null) {
      query.eq('group_id', groupId);
    }
    final data = await query.order('created_at', ascending: false);
    return (data as List).map((e) => GiftVaultOrder.fromJson(e)).toList();
  }

  Future<Map<String, List<GiftVaultOrder>>> fetchGroupedOrders() async {
    final data = await _client
        .from('gift_vault_orders')
        .select()
        .order('created_at', ascending: false);
    
    final orders = (data as List).map((e) => GiftVaultOrder.fromJson(e)).toList();
    
    // Group by group_id (email)
    final Map<String, List<GiftVaultOrder>> grouped = {};
    for (final order in orders) {
      grouped.putIfAbsent(order.groupId, () => []).add(order);
    }
    
    return grouped;
  }
}

