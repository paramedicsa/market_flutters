class LoyaltyPoints {
  final String id;
  final String userId;
  final int points;
  final int lifetimePoints;
  final DateTime updatedAt;

  LoyaltyPoints({
    required this.id,
    required this.userId,
    required this.points,
    required this.lifetimePoints,
    required this.updatedAt,
  });

  factory LoyaltyPoints.fromJson(Map<String, dynamic> json) => LoyaltyPoints(
    id: json['id'],
    userId: json['user_id'],
    points: json['points'] ?? 0,
    lifetimePoints: json['lifetime_points'] ?? 0,
    updatedAt: DateTime.parse(json['updated_at']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'points': points,
    'lifetime_points': lifetimePoints,
    'updated_at': updatedAt.toIso8601String(),
  };
}

class PointsTransaction {
  final String id;
  final String userId;
  final int points;
  final String transactionType;
  final String? referenceId;
  final String? description;
  final DateTime createdAt;

  PointsTransaction({
    required this.id,
    required this.userId,
    required this.points,
    required this.transactionType,
    this.referenceId,
    this.description,
    required this.createdAt,
  });

  factory PointsTransaction.fromJson(Map<String, dynamic> json) => PointsTransaction(
    id: json['id'],
    userId: json['user_id'],
    points: json['points'],
    transactionType: json['transaction_type'],
    referenceId: json['reference_id'],
    description: json['description'],
    createdAt: DateTime.parse(json['created_at']),
  );

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'points': points,
    'transaction_type': transactionType,
    'reference_id': referenceId,
    'description': description,
  };
}

