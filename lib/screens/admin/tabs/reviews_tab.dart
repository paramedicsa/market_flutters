import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../data/models/parsed_review_model.dart';

class ReviewsTab extends StatefulWidget {
  final TextEditingController reviewsController;
  final List<ParsedReview> parsedReviews;
  final VoidCallback onParseReviews;
  final bool isLoadingReviews;

  const ReviewsTab({
    super.key,
    required this.reviewsController,
    required this.parsedReviews,
    required this.onParseReviews,
    this.isLoadingReviews = false,
  });

  @override
  State<ReviewsTab> createState() => _ReviewsTabState();
}

class _ReviewsTabState extends State<ReviewsTab> {
  void _addNewReview() {
    final newReview = ParsedReview(
      name: 'New Reviewer',
      country: 'South Africa',
      flag: '🇿🇦',
      rating: 5,
      reviewText: 'Great product!',
      date: DateTime.now(),
    );

    setState(() {
      widget.parsedReviews.add(newReview);
    });

    _updateReviewsController();
  }

  void _editReview(int index) {
    final review = widget.parsedReviews[index];
    showDialog(
      context: context,
      builder: (context) => _ReviewEditDialog(
        review: review,
        onSave: (updatedReview) {
          setState(() {
            widget.parsedReviews[index] = updatedReview;
          });
          _updateReviewsController();
        },
      ),
    );
  }

  void _deleteReview(int index) {
    setState(() {
      widget.parsedReviews.removeAt(index);
    });
    _updateReviewsController();
  }

  void _updateReviewsController() {
    if (widget.parsedReviews.isEmpty) {
      widget.reviewsController.clear();
      return;
    }

    final formattedReviews = widget.parsedReviews.map((review) {
      final dateStr = '${review.date.month}/${review.date.day}/${review.date.year}';
      return '[${review.name}, ${review.country}] ${review.reviewText} ${review.rating}/5 $dateStr';
    }).join('\n');

    widget.reviewsController.text = formattedReviews;
  }

  Widget _buildReviewPreview(ParsedReview review, int index) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                review.flag,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${review.name}, ${review.country}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              ...List.generate(5, (index) => Icon(
                index < review.rating ? Icons.star : Icons.star_border,
                color: Colors.amber,
                size: 16,
              )),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () => _editReview(index),
                icon: const Icon(Icons.edit, size: 16, color: AppTheme.cyan),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              IconButton(
                onPressed: () => _deleteReview(index),
                icon: const Icon(Icons.delete, size: 16, color: Colors.red),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '❤️ ${review.reviewText}',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 12,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            '${review.date.month}/${review.date.day}/${review.date.year}',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Product Reviews',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Paste reviews in format: [Name, Country] Review text. Rating/5 Date.\nReviews can be on separate lines OR all on one line.',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 12),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.cardDark,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.cyan.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.info_outline, color: AppTheme.cyan, size: 16),
                    const SizedBox(width: 8),
                    const Text(
                      'Example Formats:',
                      style: TextStyle(color: AppTheme.cyan, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '✓ One per line:\n[Sakura Tanaka, Japan] Beautiful! 5/5 August 12, 2023\n[Carlos Oliveira, Brazil] Amazing quality. 4/5 July 20, 2023',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '✓ All on one line:\n[Sakura Tanaka, Japan] Beautiful! 5/5 August 12, 2023. [Carlos Oliveira, Brazil] Amazing. 4/5 July 20, 2023.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: widget.reviewsController,
            maxLines: 10,
            style: const TextStyle(color: Colors.white, fontSize: 12),
            decoration: InputDecoration(
              hintText: 'Paste your reviews here, one per line...',
              hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 11),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.white30),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.white30),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.pink),
              ),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.05),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: widget.onParseReviews,
                icon: const Icon(Icons.rate_review),
                label: const Text('Parse Reviews'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.cyan,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: _addNewReview,
                icon: const Icon(Icons.add),
                label: const Text('Add Review'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.purple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),

          // Loading Indicator
          if (widget.isLoadingReviews) ...[
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.cyan.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.cyan.withValues(alpha: 0.3)),
              ),
              child: const Row(
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: AppTheme.cyan,
                      strokeWidth: 2,
                    ),
                  ),
                  SizedBox(width: 16),
                  Text(
                    'Loading reviews from database...',
                    style: TextStyle(color: AppTheme.cyan, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],

          // Parsed Reviews Preview
          if (!widget.isLoadingReviews && widget.parsedReviews.isNotEmpty) ...[
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        '${widget.parsedReviews.length} review${widget.parsedReviews.length != 1 ? 's' : ''} loaded',
                        style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.parsedReviews.length, // Show ALL reviews
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return _buildReviewPreview(widget.parsedReviews[index], index);
                    },
                  ),
                ],
              ),
            ),
          ],

          // Supported Countries Info
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.cardDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.purple.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.public, color: AppTheme.purple, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Supported Countries',
                      style: TextStyle(
                        color: AppTheme.purple,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    '🇯🇵 Japan', '🇧🇷 Brazil', '🇺🇸 USA', '🇫🇷 France', '🇩🇪 Germany',
                    '🇿🇦 South Africa', '🇮🇹 Italy', '🇮🇪 Ireland', '🇮🇳 India', '🇨🇳 China',
                    '🇬🇧 UK', '🇨🇦 Canada', '🇦🇺 Australia', '🇪🇸 Spain', '🇲🇽 Mexico',
                  ].map((country) => Chip(
                    label: Text(country, style: const TextStyle(fontSize: 11)),
                    backgroundColor: AppTheme.black.withValues(alpha: 0.3),
                    side: BorderSide(color: AppTheme.purple.withValues(alpha: 0.2)),
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                    labelPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                  )).toList(),
                ),
                const SizedBox(height: 8),
                Text(
                  '...and 30+ more countries!',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewEditDialog extends StatelessWidget {
  final ParsedReview review;
  final ValueChanged<ParsedReview> onSave;

  const _ReviewEditDialog({
    required this.review,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController(text: review.name);
    final countryController = TextEditingController(text: review.country);
    final reviewTextController = TextEditingController(text: review.reviewText);
    final dateController = TextEditingController(text: '${review.date.month}/${review.date.day}/${review.date.year}');
    int rating = review.rating;

    return StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        backgroundColor: AppTheme.cardDark,
        title: const Text('Edit Review', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField('Name', nameController),
            _buildTextField('Country', countryController),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) => IconButton(
                icon: Icon(
                  index < rating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 24,
                ),
                onPressed: () {
                  setState(() {
                    rating = index + 1;
                  });
                },
              )),
            ),
            _buildTextField('Review Text', reviewTextController),
            _buildTextField('Date (MM/DD/YYYY)', dateController, isDate: true),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              final updatedReview = ParsedReview(
                name: nameController.text,
                country: countryController.text,
                flag: review.flag, // Keep the same flag
                rating: rating,
                reviewText: reviewTextController.text,
                date: DateTime.tryParse(dateController.text) ?? review.date,
              );
              onSave(updatedReview);
              Navigator.of(context).pop();
            },
            child: const Text('Save', style: TextStyle(color: AppTheme.cyan)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool isNumber = false, bool isDate = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.white30),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppTheme.pink),
          ),
          filled: true,
          fillColor: Colors.white.withValues(alpha: 0.05),
        ),
      ),
    );
  }
}
