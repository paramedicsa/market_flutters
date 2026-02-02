# Gift Vault Quest - Integration Guide

## Quick Start

This guide shows how to integrate the Gift Vault Quest feature into your app.

## Step 1: Database Setup

Run the database setup script:

```bash
# Connect to your Supabase project and run:
psql -h your-supabase-host -U postgres -d postgres -f gift_vault_database_setup.sql
```

Or use the Supabase SQL Editor to paste and execute the contents of `gift_vault_database_setup.sql`.

## Step 2: Install Dependencies

The Gift Vault feature requires `share_plus` package. It's already added to `pubspec.yaml`:

```bash
flutter pub get
```

## Step 3: Navigation Integration

### Option A: Add to Main Navigation

If you have a bottom navigation bar or drawer, add the Gift Vault option:

```dart
import 'package:flutter/material.dart';
import 'screens/gift_vault/gift_vault_screen.dart';

class MainNavigationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: /* Your current content */,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GiftVaultScreen(
                userId: 'current-user-id',  // Get from auth
                userEmail: 'user@example.com',  // Get from auth
                userName: 'User Name',  // Get from auth
                currency: 'ZAR',  // or 'USD' based on user preference
              ),
            ),
          );
        },
        icon: Icon(Icons.card_giftcard),
        label: Text('Gift Vault'),
        backgroundColor: AppTheme.pink,
      ),
    );
  }
}
```

### Option B: Add to App Bar

```dart
AppBar(
  title: Text('Your App'),
  actions: [
    IconButton(
      icon: Icon(Icons.card_giftcard),
      tooltip: 'Gift Vault Quest',
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GiftVaultScreen(
              userId: 'current-user-id',
              userEmail: 'user@example.com',
              userName: 'User Name',
              currency: 'ZAR',
            ),
          ),
        );
      },
    ),
  ],
)
```

### Option C: Deep Link Integration

For referral tracking, set up deep links in your app:

#### Android (`android/app/src/main/AndroidManifest.xml`)

```xml
<intent-filter>
  <action android:name="android.intent.action.VIEW" />
  <category android:name="android.intent.category.DEFAULT" />
  <category android:name="android.intent.category.BROWSABLE" />
  <data
    android:scheme="https"
    android:host="spoilmevintage.com"
    android:pathPrefix="/gift-vault" />
</intent-filter>
```

#### iOS (`ios/Runner/Info.plist`)

```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleTypeRole</key>
    <string>Editor</string>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>spoilmevintage</string>
    </array>
  </dict>
</array>
```

#### Handle Deep Links in Main

```dart
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // ... other initialization
  
  runApp(MyApp());
  
  // Listen for deep links
  const platform = MethodChannel('deep_links');
  platform.setMethodCallHandler((call) async {
    if (call.method == 'openGiftVault') {
      final referrerId = call.arguments['ref'] as String?;
      // Store referrerId and navigate to Gift Vault
    }
  });
}
```

## Step 4: User Authentication Integration

Integrate with your auth system:

```dart
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/gift_vault/gift_vault_screen.dart';

class YourScreen extends StatelessWidget {
  void _openGiftVault(BuildContext context) async {
    final user = Supabase.instance.client.auth.currentUser;
    
    if (user == null) {
      // Show login dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please log in to access Gift Vault')),
      );
      return;
    }
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GiftVaultScreen(
          userId: user.id,
          userEmail: user.email!,
          userName: user.userMetadata?['name'] ?? 'User',
          currency: user.userMetadata?['currency'] ?? 'ZAR',
        ),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _openGiftVault(context),
      child: Text('Open Gift Vault'),
    );
  }
}
```

## Step 5: Test the Integration

### Manual Testing Checklist

1. **Access Control**
   - [ ] Try accessing vault during restricted hours (should show closed dialog)
   - [ ] Access vault during evening (6PM-6AM) or Saturday (should open)

2. **Timer Functionality**
   - [ ] Verify 20-minute selection timer starts
   - [ ] Check timer turns red under 2 minutes
   - [ ] Test vault slam-shut on timer expiry

3. **Product Selection**
   - [ ] Tap product to see magic dust animation
   - [ ] Verify product flies to tray
   - [ ] Check total amount updates

4. **Progress Tracking**
   - [ ] Add products to reach R800/$50 milestone
   - [ ] Verify free gift icon pulses and lights up
   - [ ] Add products to reach R1000/$75 milestone
   - [ ] Verify free shipping icon pulses and lights up

5. **Tier Progression**
   - [ ] Complete R100/$20 minimum purchase
   - [ ] Verify "Fork in the Road" dialog appears
   - [ ] Test both paths (Standard and Hero/Tier 2)

6. **Bonus Game**
   - [ ] Complete checkout to trigger bonus game
   - [ ] Test share functionality
   - [ ] Verify credit bubbles fill on share
   - [ ] Complete 5 shares to unlock bonus catalog

7. **Admin Panel**
   - [ ] Check admin orders screen shows grouped orders
   - [ ] Verify tier-based order display

## Step 6: Configure for Production

### Update Base URL

In `lib/utils/viral_share_service.dart`, update the base URL:

```dart
static Future<void> shareVaultInvite({
  required String userName,
  required String referrerId,
  required String baseUrl,  // Use your production URL
}) async {
  final deepLink = '$baseUrl/gift-vault';
  // ...
}
```

### Set Up Server-Side Validation

For production, implement server-side validation:

1. **Timer Validation**: Verify timer hasn't expired on the server
2. **Share Tracking**: Track actual shares via deep link clicks
3. **Referral Validation**: Validate referrer_id on order creation

### Configure Currency

Set default currency based on user location:

```dart
String getUserCurrency(String? countryCode) {
  if (countryCode == 'US' || countryCode == 'USA') {
    return 'USD';
  }
  return 'ZAR';  // Default to South African Rand
}
```

## Step 7: Monitoring & Analytics

Add analytics tracking for key events:

```dart
// Example with Firebase Analytics
class GiftVaultAnalytics {
  static void trackVaultOpened(String userId) {
    // FirebaseAnalytics.instance.logEvent(name: 'gift_vault_opened');
  }
  
  static void trackProductSelected(String productId, String tier) {
    // FirebaseAnalytics.instance.logEvent(name: 'vault_product_selected');
  }
  
  static void trackOrderCompleted(String orderId, double amount, String tier) {
    // FirebaseAnalytics.instance.logEvent(name: 'vault_order_completed');
  }
  
  static void trackShareCompleted(int shareCount) {
    // FirebaseAnalytics.instance.logEvent(name: 'vault_share_completed');
  }
}
```

## Troubleshooting

### Issue: Vault doors don't open

**Solution**: Check time-based access logic. Verify device time is correct.

### Issue: Magic dust animation not showing

**Solution**: Ensure OverlayEntry is properly inserted. Check for context issues.

### Issue: Share button not working

**Solution**: 
- Verify share_plus package is installed
- Check platform permissions for sharing
- Test on physical device (may not work on simulator)

### Issue: Orders not grouping in admin

**Solution**: Verify group_id is set to user email when creating orders.

### Issue: Products not loading

**Solution**: 
- Check Supabase connection
- Verify funnel_tier column exists in products table
- Check RLS policies allow reading products

## Support

For additional help:
- Review `GIFT_VAULT_DOCUMENTATION.md` for detailed feature documentation
- Check database schema in `gift_vault_database_setup.sql`
- Contact development team for specific issues

## Next Steps

After integration:
1. Configure push notifications for vault opening times
2. Set up email campaigns for vault events
3. Monitor user engagement metrics
4. A/B test different spend targets
5. Optimize animation performance based on device capabilities
