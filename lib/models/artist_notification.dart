class ArtistNotification {
  final String id;
  final String artistApplicationId;
  final String type; // approval, denial, info
  final String message;
  final DateTime createdAt;
  final bool read;

  ArtistNotification({
    required this.id,
    required this.artistApplicationId,
    required this.type,
    required this.message,
    required this.createdAt,
    required this.read,
  });

  factory ArtistNotification.fromJson(Map<String, dynamic> json) => ArtistNotification(
    id: json['id'],
    artistApplicationId: json['artist_application_id'],
    type: json['type'],
    message: json['message'],
    createdAt: DateTime.parse(json['created_at']),
    read: json['read'] ?? false,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'artist_application_id': artistApplicationId,
    'type': type,
    'message': message,
    'created_at': createdAt.toIso8601String(),
    'read': read,
  };
}

