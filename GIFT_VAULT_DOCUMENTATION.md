# Gift Vault Quest Feature Documentation

## Overview
The Gift Vault Quest is a gamified shopping experience designed to encourage user engagement and viral sharing. It features time-based access, animated golden vault doors, milestone tracking, and a referral bonus system.

## Architecture

### Directory Structure
```
lib/screens/gift_vault/
├── gift_vault_screen.dart          # Main orchestrator screen
└── widgets/
    ├── vault_door.dart              # Animated golden doors
    ├── magic_dust.dart              # Fly-to-tray animation
    ├── gift_progress_bar.dart       # Progress tracking bar
    └── bonus_game_popup.dart        # Sharing game popup
```

### Core Models
- **Product** (`lib/models/product.dart`): Product with funnel_tier support
- **UserWallet** (`lib/models/user_wallet.dart`): User bonus credit tracking
- **GiftVaultOrder** (`lib/models/gift_vault_order.dart`): Order management with grouping

### Services
- **SupabaseService**: Extended with Gift Vault methods
- **CurrencyService** (`lib/utils/currency_service.dart`): Multi-currency support
- **ViralShareService** (`lib/utils/viral_share_service.dart`): Referral sharing

## Features

### 1. Time-Based Access Control
The vault is only accessible during:
- **Evening Hours**: 6PM - 6AM
- **All Saturday**: 24 hours on Saturdays

```dart
bool get _isEvening {
  final hour = DateTime.now().hour;
  return hour >= 18 || hour < 6; // 6PM - 6AM
}

bool get _isSaturday {
  return DateTime.now().weekday == DateTime.saturday;
}
```

### 2. Timer Management
Three timer types:
- **Selection Timer**: 20 minutes to select gifts
- **Payment Timer**: Time to complete payment
- **Quest Timer**: Overall quest duration

Timers pulse RED when under 2 minutes remaining.

### 3. Animated Vault Doors
- Golden metallic gradient design
- Matrix4 transform for smooth opening/closing
- Screen shake effect when timer expires
- CherryCreamSoda font for "GIFT VAULT" text

### 4. Magic Dust Animation
Fly-to-tray effect when reserving products:
- OverlayEntry creates a duplicate of the product image
- Travels from tap position to top tray
- 20 glowing particles (Pink/Purple/Blue) trail behind
- Particle physics with randomized offsets

### 5. Progress Bar
Two milestone targets:
- **Free Gift**: R800/$50
- **Free Shipping**: R1000/$75

Icons pulse and change to gradient when milestones are reached.

### 6. Funnel Tiers
Three catalog tiers:
- **Starter**: Entry level (R100/$20 minimum)
- **Premium**: After initial payment, free shipping unlocked
- **Bonus**: Unlocked after completing 5-step sharing game

### 7. Fork in the Road Dialog
Post-payment choice:
- **Standard Path**: Pay shipping and finish
- **Hero Path**: Unlock Tier 2 for free shipping (animated with neon glow)

### 8. Bonus Game Popup
5-step sharing mechanic:
- Each share fills a credit bubble
- Rewards: R20/$1 per share
- Unlocks bonus catalog on completion
- Uses share_plus package for WhatsApp/Facebook sharing

### 9. Viral Sharing
Deep links include referrer_id for tracking:
```
🎁 [userName] sent you a Golden Key 🗝️ to Spoil Me Vintage!
Claim your free gift before the vault closes: [Link]?ref=[referrerId]
```

Referral bonus: R100/$20 when friend makes purchase

### 10. Admin Order Grouping
Orders screen groups by customer email (group_id):
- View all orders by single customer
- Tier-based grouping (Starter, Premium, Bonus)
- Total spend calculation per customer

## Usage

### Integration Example

```dart
import 'package:flutter/material.dart';
import 'screens/gift_vault/gift_vault_screen.dart';

// Navigate to Gift Vault
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => GiftVaultScreen(
      userId: 'user-uuid',
      userEmail: 'user@example.com',
      userName: 'John Doe',
      currency: 'ZAR', // or 'USD'
    ),
  ),
);
```

### Database Schema Requirements

#### Products Table
```sql
CREATE TABLE products (
  id UUID PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  price DECIMAL NOT NULL,
  image_url TEXT,
  funnel_tier TEXT, -- 'starter', 'premium', 'bonus'
  currency TEXT DEFAULT 'ZAR',
  is_available BOOLEAN DEFAULT true
);
```

#### User Wallet Table
```sql
CREATE TABLE user_wallet (
  user_id UUID PRIMARY KEY,
  bonus_gift_credit DECIMAL DEFAULT 0.0,
  referral_bonus DECIMAL DEFAULT 0.0,
  currency TEXT DEFAULT 'ZAR',
  last_updated TIMESTAMP
);
```

#### Gift Vault Orders Table
```sql
CREATE TABLE gift_vault_orders (
  id UUID PRIMARY KEY,
  user_id UUID NOT NULL,
  group_id TEXT NOT NULL, -- User's email for grouping
  product_ids TEXT[] NOT NULL,
  total_amount DECIMAL NOT NULL,
  currency TEXT DEFAULT 'ZAR',
  tier TEXT NOT NULL, -- 'starter', 'premium', 'bonus'
  status TEXT DEFAULT 'pending',
  created_at TIMESTAMP DEFAULT NOW(),
  referrer_id UUID
);

-- Index for efficient grouping
CREATE INDEX idx_gift_vault_orders_group_id ON gift_vault_orders(group_id);
```

## Visual Design

### Color Scheme
- **Background**: Zinc-900 (#18181B)
- **Primary Gradient**: Pink → Purple → Cyan
- **Golden Doors**: Gold (#FFD700) → Orange Gold (#FFA500)
- **Success**: Green (#00FF88)

### Typography
- **Titles**: CherryCreamSoda (48px for doors, 32px for headers)
- **Labels/Notes**: IndieFlower (14-18px)
- **Body**: Roboto

### Borders
All cards and buttons use 3px nested gradient borders:
```dart
BoxDecoration(
  gradient: AppTheme.vaultGradient(),
  borderRadius: BorderRadius.circular(12),
)
```

## Currency Configuration

Spend targets by currency:
```dart
'ZAR': {
  'starter': 100.0,        // R100 minimum
  'free_gift': 800.0,      // R800 for free gift
  'free_shipping': 1000.0, // R1000 for free shipping
}

'USD': {
  'starter': 20.0,         // $20 minimum
  'free_gift': 50.0,       // $50 for free gift
  'free_shipping': 75.0,   // $75 for free shipping
}
```

## Security Considerations

### Share Validation
⚠️ **Note**: The share_plus package's `ShareResultStatus.success` only indicates the share sheet was presented, not that content was actually shared. For production, implement server-side validation via deep link tracking.

### Timer Synchronization
Timers are client-side only. For production, implement server-side timer validation to prevent manipulation.

### Deep Link Security
Validate referrer_ids on the server to prevent abuse of the referral bonus system.

## Testing Checklist

- [ ] Verify vault access during evening hours (6PM-6AM)
- [ ] Verify vault access all day Saturday
- [ ] Test vault closure dialog during restricted hours
- [ ] Test 20-minute selection timer countdown
- [ ] Test timer turning red under 2 minutes
- [ ] Test vault doors opening animation
- [ ] Test vault doors slam-shut on timer expiry
- [ ] Test magic dust animation for product selection
- [ ] Test progress bar milestone achievements
- [ ] Test milestone icon pulse animations
- [ ] Test "Fork in the Road" dialog appearance
- [ ] Test tier progression (Starter → Premium → Bonus)
- [ ] Test bonus game popup and share functionality
- [ ] Test credit bubble filling on share
- [ ] Test bonus catalog unlock after 5 shares
- [ ] Verify admin orders grouping by customer email
- [ ] Verify tier-based order display in admin
- [ ] Test multi-currency support (ZAR and USD)

## Performance Notes

- Magic dust animation uses 20 particles - adjust `particleCount` constant if needed
- Vault door animation duration: 2 seconds (adjustable via controller)
- Timer update frequency: 1 second (can be optimized if needed)
- Progress bar animations are hardware-accelerated

## Known Limitations

1. **Share Validation**: Cannot verify actual shares, only share sheet presentation
2. **Client-Side Timers**: Timers can be manipulated without server validation
3. **Time Zone**: Uses device local time for evening/Saturday checks
4. **Offline Support**: Requires internet connection for all features

## Future Enhancements

- [ ] Server-side timer validation
- [ ] Push notifications when vault opens
- [ ] Wishlist integration
- [ ] Social proof (show recent purchasers)
- [ ] Leaderboard for top sharers
- [ ] Time zone normalization
- [ ] Offline mode support
- [ ] Analytics integration
- [ ] A/B testing framework

## Support

For issues or questions, contact the development team or refer to the project documentation.
