class ArtistApplication {
  final String id;
  final String name;
  final String surname;
  final String email;
  final String whatsapp;
  final String countryCode;
  final String country;
  final String artistName;
  final List<String> imageUrls;
  final String status; // pending, approved, denied
  final String? denialReason;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? userId;

  ArtistApplication({
    required this.id,
    required this.name,
    required this.surname,
    required this.email,
    required this.whatsapp,
    required this.countryCode,
    required this.country,
    required this.artistName,
    required this.imageUrls,
    required this.status,
    this.denialReason,
    required this.createdAt,
    required this.updatedAt,
    this.userId,
  });

  factory ArtistApplication.fromJson(Map<String, dynamic> json) => ArtistApplication(
    id: json['id'],
    name: json['name'],
    surname: json['surname'],
    email: json['email'],
    whatsapp: json['whatsapp'],
    countryCode: json['country_code'],
    country: json['country'],
    artistName: json['artist_name'],
    imageUrls: List<String>.from(json['image_urls'] ?? []),
    status: json['status'],
    denialReason: json['denial_reason'],
    createdAt: DateTime.parse(json['created_at']),
    updatedAt: DateTime.parse(json['updated_at']),
    userId: json['user_id'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'surname': surname,
    'email': email,
    'whatsapp': whatsapp,
    'country_code': countryCode,
    'country': country,
    'artist_name': artistName,
    'image_urls': imageUrls,
    'status': status,
    'denial_reason': denialReason,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
    'user_id': userId,
  };
}
