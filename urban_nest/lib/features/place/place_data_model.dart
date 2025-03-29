class Place {
  final String name;
  final String description;
  final List<String> imageUrls; // Changed to a list
  final String category;
  final double rating;
  final String location;
  final double avgSpend;

  Place({
    required this.name,
    required this.description,
    required this.imageUrls,
    required this.category,
    required this.rating,
    required this.location,
    required this.avgSpend,
  });
}
