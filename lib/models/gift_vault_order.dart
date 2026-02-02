class GiftVaultOrder {
  final String id;
  final String userId;
  final String groupId; // User's email for grouping
  final List<String> productIds;
  final double totalAmount;
  final String currency;
  final String tier; // 'starter', 'premium', 'bonus'
  final String status;
  final DateTime createdAt;
  final String? referrerId;

  GiftVaultOrder({
    required this.id,
    required this.userId,
    required this.groupId,
    required this.productIds,
    required this.totalAmount,
    required this.currency,
    required this.tier,
    this.status = 'pending',
    required this.createdAt,
    this.referrerId,
  });

  factory GiftVaultOrder.fromJson(Map<String, dynamic> json) {
    return GiftVaultOrder(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      groupId: json['group_id'] as String,
      productIds: (json['product_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] as String? ?? 'ZAR',
      tier: json['tier'] as String,
      status: json['status'] as String? ?? 'pending',
      createdAt: DateTime.parse(json['created_at'] as String),
      referrerId: json['referrer_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'group_id': groupId,
      'product_ids': productIds,
      'total_amount': totalAmount,
      'currency': currency,
      'tier': tier,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'referrer_id': referrerId,
    };
  }
}
