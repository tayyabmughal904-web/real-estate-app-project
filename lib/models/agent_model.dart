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
  });
}
