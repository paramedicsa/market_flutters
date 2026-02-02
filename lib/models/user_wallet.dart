class UserWallet {
  final String userId;
  final double bonusGiftCredit;
  final double referralBonus;
  final String currency;
  final DateTime? lastUpdated;

  UserWallet({
    required this.userId,
    this.bonusGiftCredit = 0.0,
    this.referralBonus = 0.0,
    this.currency = 'ZAR',
    this.lastUpdated,
  });

  factory UserWallet.fromJson(Map<String, dynamic> json) {
    return UserWallet(
      userId: json['user_id'] as String,
      bonusGiftCredit: (json['bonus_gift_credit'] as num?)?.toDouble() ?? 0.0,
      referralBonus: (json['referral_bonus'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] as String? ?? 'ZAR',
      lastUpdated: json['last_updated'] != null
          ? DateTime.parse(json['last_updated'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'bonus_gift_credit': bonusGiftCredit,
      'referral_bonus': referralBonus,
      'currency': currency,
      'last_updated': lastUpdated?.toIso8601String(),
    };
  }

  UserWallet copyWith({
    String? userId,
    double? bonusGiftCredit,
    double? referralBonus,
    String? currency,
    DateTime? lastUpdated,
  }) {
    return UserWallet(
      userId: userId ?? this.userId,
      bonusGiftCredit: bonusGiftCredit ?? this.bonusGiftCredit,
      referralBonus: referralBonus ?? this.referralBonus,
      currency: currency ?? this.currency,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
