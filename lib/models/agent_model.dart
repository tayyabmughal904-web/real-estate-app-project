class Agent {
  final String id;
  final String name;
  final String agency;
  final String avatarUrl;
  final String phone;
  final String email;
  final double rating;
  final int reviewsCount;
  final String about;
  final int listingsCount;
  final bool isVerified;
  final String licenseNumber;
  final int yearsExperience;

  const Agent({
    required this.id,
    required this.name,
    required this.agency,
    required this.avatarUrl,
    required this.phone,
    required this.email,
    required this.rating,
    required this.reviewsCount,
    required this.about,
    this.listingsCount = 18,
    this.isVerified = true,
    this.licenseNumber = 'CAL-DRE #02194812',
    this.yearsExperience = 8,
  });

  factory Agent.fromJson(Map<String, dynamic> json) {
    return Agent(
      id: json['id'] as String,
      name: json['name'] as String,
      agency: json['agency'] as String? ?? 'Luxeylin Realty',
      avatarUrl: json['avatarUrl'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      email: json['email'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 4.9,
      reviewsCount: json['reviewsCount'] as int? ?? 120,
      about: json['about'] as String? ?? '',
      listingsCount: json['listingsCount'] as int? ?? 18,
      isVerified: json['isVerified'] as bool? ?? true,
      licenseNumber: json['licenseNumber'] as String? ?? 'CAL-DRE #02194812',
      yearsExperience: json['yearsExperience'] as int? ?? 8,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'agency': agency,
      'avatarUrl': avatarUrl,
      'phone': phone,
      'email': email,
      'rating': rating,
      'reviewsCount': reviewsCount,
      'about': about,
      'listingsCount': listingsCount,
      'isVerified': isVerified,
      'licenseNumber': licenseNumber,
      'yearsExperience': yearsExperience,
    };
  }
}
