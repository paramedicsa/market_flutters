import 'package:share_plus/share_plus.dart';

class ViralShareService {
  static String generateShareMessage({
    required String userName,
    required String referrerId,
    required String deepLink,
  }) {
    return '''🎁 $userName sent you a Golden Key 🗝️ to Spoil Me Vintage!

Claim your free gift before the vault closes: $deepLink?ref=$referrerId

✨ Limited time only - The vault slams shut when the timer hits zero!''';
  }

  static Future<void> shareVaultInvite({
    required String userName,
    required String referrerId,
    required String baseUrl,
  }) async {
    final deepLink = '$baseUrl/gift-vault';
    final message = generateShareMessage(
      userName: userName,
      referrerId: referrerId,
      deepLink: deepLink,
    );

    await Share.share(
      message,
      subject: '🎁 You\'ve been invited to Spoil Me Vintage Gift Vault!',
    );
  }

  static Future<ShareResult> shareWithResult({
    required String userName,
    required String referrerId,
    required String baseUrl,
  }) async {
    final deepLink = '$baseUrl/gift-vault';
    final message = generateShareMessage(
      userName: userName,
      referrerId: referrerId,
      deepLink: deepLink,
    );

    return await Share.shareWithResult(
      message,
      subject: '🎁 You\'ve been invited to Spoil Me Vintage Gift Vault!',
    );
  }
}
