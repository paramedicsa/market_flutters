class CurrencyService {
  // Spend targets for different currencies
  static const Map<String, Map<String, double>> spendTargets = {
    'ZAR': {
      'starter': 100.0, // R100 minimum
      'free_gift': 800.0, // R800 for free gift
      'free_shipping': 1000.0, // R1000 for free shipping
    },
    'USD': {
      'starter': 20.0, // $20 minimum
      'free_gift': 50.0, // $50 for free gift
      'free_shipping': 75.0, // $75 for free shipping
    },
  };

  // Share rewards per currency
  static const Map<String, double> shareRewards = {
    'ZAR': 20.0, // R20 per share
    'USD': 1.0, // $1 per share
  };

  // Referral bonus per currency
  static const Map<String, double> referralBonus = {
    'ZAR': 100.0, // R100 bonus
    'USD': 20.0, // $20 bonus
  };

  // Default currency for fallback
  static const String defaultCurrency = 'ZAR';

  static double getStarterTarget(String currency) {
    return spendTargets[currency]?['starter'] ?? 
           spendTargets[defaultCurrency]?['starter'] ?? 
           100.0;
  }

  static double getFreeGiftTarget(String currency) {
    return spendTargets[currency]?['free_gift'] ?? 
           spendTargets[defaultCurrency]?['free_gift'] ?? 
           800.0;
  }

  static double getFreeShippingTarget(String currency) {
    return spendTargets[currency]?['free_shipping'] ?? 
           spendTargets[defaultCurrency]?['free_shipping'] ?? 
           1000.0;
  }

  static double getShareReward(String currency) {
    return shareRewards[currency] ?? shareRewards[defaultCurrency] ?? 20.0;
  }

  static double getReferralBonus(String currency) {
    return referralBonus[currency] ?? referralBonus[defaultCurrency] ?? 100.0;
  }

  static String formatCurrency(double amount, String currency) {
    if (currency == 'USD') {
      return '\$${amount.toStringAsFixed(2)}';
    } else {
      return 'R${amount.toStringAsFixed(2)}';
    }
  }
}
