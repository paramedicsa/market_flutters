class Review {
  final String id;
  final String productId;
  final String? userId;
  final String orderId;
  final int rating;
  final String reviewText;
  final String status; // pending, approved, rejected
  final DateTime createdAt;
  final DateTime? approvedAt;
  final String? approvedBy;
  final String? reviewerName;
  final String? reviewerCountry;
  final String? reviewerFlag;

  Review({
    required this.id,
    required this.productId,
    this.userId,
    required this.orderId,
    required this.rating,
    required this.reviewText,
    required this.status,
    required this.createdAt,
    this.approvedAt,
    this.approvedBy,
    this.reviewerName,
    this.reviewerCountry,
    this.reviewerFlag,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
    id: json['id'],
    productId: json['product_id'],
    userId: json['user_id'],
    orderId: json['order_id'],
    rating: json['rating'],
    reviewText: json['review_text'] ?? '',
    status: json['status'] ?? 'pending',
    createdAt: DateTime.parse(json['created_at']),
    approvedAt: json['approved_at'] != null ? DateTime.parse(json['approved_at']) : null,
    approvedBy: json['approved_by'],
    reviewerName: json['reviewer_name'],
    reviewerCountry: json['reviewer_country'],
    reviewerFlag: json['reviewer_flag'],
  );

  Map<String, dynamic> toJson() => {
    'product_id': productId,
    'user_id': userId,
    'order_id': orderId,
    'rating': rating,
    'review_text': reviewText,
    'status': status,
    'reviewer_name': reviewerName,
    'reviewer_country': reviewerCountry,
    'reviewer_flag': reviewerFlag,
    'created_at': createdAt.toIso8601String(), // Ensure provided date is used
  };
}
