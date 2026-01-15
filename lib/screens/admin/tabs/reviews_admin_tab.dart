import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../theme/app_theme.dart';
import '../../../data/models/review_model.dart';

class ReviewsAdminTab extends StatefulWidget {
  const ReviewsAdminTab({super.key});

  @override
  State<ReviewsAdminTab> createState() => _ReviewsAdminTabState();
}

class _ReviewsAdminTabState extends State<ReviewsAdminTab> {
  final _supabase = Supabase.instance.client;
  List<Review> _reviews = [];
  bool _loading = true;
  String _filterStatus = 'all'; // all, pending, approved, rejected

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    setState(() => _loading = true);
    try {
      var query = _supabase.from('reviews').select();

      if (_filterStatus != 'all') {
        query = query.eq('status', _filterStatus);
      }

      final data = await query.order('created_at', ascending: false);

      if (mounted) {
        setState(() {
          _reviews = (data as List).map((json) => Review.fromJson(json)).toList();
          _loading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading reviews: $e');
      if (mounted) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading reviews: $e')),
        );
      }
    }
  }

  Future<void> _updateReviewStatus(String reviewId, String status) async {
    try {
      await _supabase.from('reviews').update({
        'status': status,
        'approved_at': status == 'approved' ? DateTime.now().toIso8601String() : null,
        'approved_by': _supabase.auth.currentUser?.id,
      }).eq('id', reviewId);

      await _loadReviews();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              status == 'approved'
                  ? '✅ Review approved! User earned 100 points.'
                  : '❌ Review rejected.',
            ),
            backgroundColor: status == 'approved' ? Colors.green : Colors.red,
          ),
        );
      }
    } catch (e) {
      debugPrint('Error updating review: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Filter Tabs
        Container(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('All', 'all'),
                const SizedBox(width: 8),
                _buildFilterChip('Pending', 'pending'),
                const SizedBox(width: 8),
                _buildFilterChip('Approved', 'approved'),
                const SizedBox(width: 8),
                _buildFilterChip('Rejected', 'rejected'),
              ],
            ),
          ),
        ),

        // Reviews List
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator(color: AppTheme.cyan))
              : _reviews.isEmpty
                  ? const Center(
                      child: Text(
                        'No reviews found',
                        style: TextStyle(color: Colors.white70),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _reviews.length,
                      itemBuilder: (context, index) {
                        final review = _reviews[index];
                        return _buildReviewCard(review);
                      },
                    ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _filterStatus == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() => _filterStatus = value);
        _loadReviews();
      },
      backgroundColor: AppTheme.cardDark,
      selectedColor: AppTheme.pink,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.white70,
      ),
    );
  }

  Widget _buildReviewCard(Review review) {
    return Card(
      color: AppTheme.cardDark,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Reviewer info
                if (review.reviewerFlag != null)
                  Text(review.reviewerFlag!, style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (review.reviewerName != null)
                        Text(
                          review.reviewerName!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      if (review.reviewerCountry != null)
                        Text(
                          review.reviewerCountry!,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.6),
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ),
                // Star Rating
                Row(
                  children: List.generate(5, (index) => Icon(
                    index < review.rating ? Icons.star : Icons.star_border,
                    color: AppTheme.cyan,
                    size: 18,
                  )),
                ),
                const SizedBox(width: 8),
                // Status Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(review.status).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _getStatusColor(review.status)),
                  ),
                  child: Text(
                    review.status.toUpperCase(),
                    style: TextStyle(
                      color: _getStatusColor(review.status),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '❤️ ${review.reviewText}',
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
            const SizedBox(height: 12),
            Text(
              'Product ID: ${review.productId} • ${_formatDate(review.createdAt)}',
              style: const TextStyle(color: Colors.white54, fontSize: 12),
            ),
            if (review.status == 'pending') ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _updateReviewStatus(review.id, 'approved'),
                      icon: const Icon(Icons.check, size: 18),
                      label: const Text('Approve & Award 100 Points'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _updateReviewStatus(review.id, 'rejected'),
                      icon: const Icon(Icons.close, size: 18),
                      label: const Text('Reject'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}

