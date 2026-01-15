import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class ParsedReview {
  final String name;
  final String country;
  final String flag;
  final String reviewText;
  final int rating;
  final DateTime date;
  final String orderId; // Unique order ID for back office

  ParsedReview({
    required this.name,
    required this.country,
    required this.flag,
    required this.reviewText,
    required this.rating,
    required this.date,
    String? orderId,
  }) : orderId = orderId ?? const Uuid().v4(); // Generate UUID if not provided

  // Convert to Review model for database
  Map<String, dynamic> toJson(String productId) => {
    'product_id': productId,
    'order_id': orderId,
    'rating': rating,
    'review_text': reviewText,
    'status': 'approved', // Pre-approved
    'reviewer_name': name,
    'reviewer_country': country,
    'reviewer_flag': flag,
    'created_at': date.toIso8601String(), // Use parsed date
  };

  static final Map<String, String> countryFlags = {
    'Japan': '🇯🇵', 'Brazil': '🇧🇷', 'USA': '🇺🇸', 'France': '🇫🇷',
    'Germany': '🇩🇪', 'South Africa': '🇿🇦', 'Italy': '🇮🇹', 'Ireland': '🇮🇪',
    'India': '🇮🇳', 'China': '🇨🇳', 'UK': '🇬🇧', 'Canada': '🇨🇦',
    'Australia': '🇦🇺', 'Spain': '🇪🇸', 'Mexico': '🇲🇽', 'Argentina': '🇦🇷',
    'Netherlands': '🇳🇱', 'Sweden': '🇸🇪', 'Norway': '🇳🇴', 'Denmark': '🇩🇰',
    'Finland': '🇫🇮', 'Poland': '🇵🇱', 'Russia': '🇷🇺', 'South Korea': '🇰🇷',
    'Thailand': '🇹🇭', 'Vietnam': '🇻🇳', 'Singapore': '🇸🇬', 'Malaysia': '🇲🇾',
    'Philippines': '🇵🇭', 'Indonesia': '🇮🇩', 'Turkey': '🇹🇷', 'Egypt': '🇪🇬',
    'Saudi Arabia': '🇸🇦', 'UAE': '🇦🇪', 'Israel': '🇮🇱', 'Greece': '🇬🇷',
    'Portugal': '🇵🇹', 'Belgium': '🇧🇪', 'Switzerland': '🇨🇭', 'Austria': '🇦🇹',
    'New Zealand': '🇳🇿', 'Chile': '🇨🇱', 'Colombia': '🇨🇴', 'Peru': '🇵🇪',
    'Pakistan': '🇵🇰', 'Bangladesh': '🇧🇩', 'Nigeria': '🇳🇬', 'Kenya': '🇰🇪',
  };

  static DateTime? parseCustomDate(String dateString) {
    // Try parsing formats like 'October 12, 2023'
    try {
      final months = {
        'January': 1, 'February': 2, 'March': 3, 'April': 4, 'May': 5, 'June': 6,
        'July': 7, 'August': 8, 'September': 9, 'October': 10, 'November': 11, 'December': 12
      };
      final regex = RegExp(r'([A-Za-z]+)\s+(\d{1,2}),\s*(\d{4})');
      final match = regex.firstMatch(dateString);
      if (match != null) {
        final month = months[match.group(1)!];
        final day = int.parse(match.group(2)!);
        final year = int.parse(match.group(3)!);
        if (month != null) {
          return DateTime(year, month, day);
        }
      }
    } catch (_) {}
    return null;
  }

  static ParsedReview? fromText(String text) {
    try {
      // Parse: [Name, Country] Review text. Rating/5 Date.
      final nameCountryRegex = RegExp(r'\[([^,]+),\s*([^\]]+)\]');
      final ratingRegex = RegExp(r'(\d)/5');

      final nameCountryMatch = nameCountryRegex.firstMatch(text);
      final ratingMatch = ratingRegex.firstMatch(text);

      if (nameCountryMatch == null || ratingMatch == null) return null;

      final name = nameCountryMatch.group(1)!.trim();
      final country = nameCountryMatch.group(2)!.trim();
      final rating = int.parse(ratingMatch.group(1)!);

      // Extract review text (between ']' and rating)
      final reviewStart = text.indexOf(']') + 1;
      final reviewEnd = text.indexOf(ratingMatch.group(0)!);
      final reviewText = text.substring(reviewStart, reviewEnd).trim();

      // Extract date (after rating)
      final dateStart = text.indexOf(ratingMatch.group(0)!) + ratingMatch.group(0)!.length;
      final dateString = text.substring(dateStart).trim().replaceAll('.', '');
      DateTime? date = DateTime.tryParse(dateString);
      date ??= parseCustomDate(dateString); // Try custom parser
      date ??= DateTime.now(); // Fallback only if all parsing fails

      final flag = countryFlags[country] ?? '🌍';

      return ParsedReview(
        name: name,
        country: country,
        flag: flag,
        reviewText: reviewText,
        rating: rating,
        date: date,
      );
    } catch (e) {
      debugPrint('Error parsing review: $e');
      return null;
    }
  }
}
