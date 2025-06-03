class DestinationModel {
  final String id;
  final String name;
  final String location;
  final String country;
  final String imageUrl;
  final double price;
  final double rating;
  final String description;
  final List<String> categories;
  final bool isFavorite;

  DestinationModel({
    required this.id,
    required this.name,
    required this.location,
    required this.country,
    required this.imageUrl,
    required this.price,
    required this.rating,
    required this.description,
    required this.categories,
    this.isFavorite = false,
  });

  factory DestinationModel.fromJson(Map<String, dynamic> json) {
    return DestinationModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      location: json['location'] ?? '',
      country: json['country'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      rating: (json['rating'] ?? 0).toDouble(),
      description: json['description'] ?? '',
      categories: List<String>.from(json['categories'] ?? []),
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'country': country,
      'imageUrl': imageUrl,
      'price': price,
      'rating': rating,
      'description': description,
      'categories': categories,
      'isFavorite': isFavorite,
    };
  }

  DestinationModel copyWith({
    String? id,
    String? name,
    String? location,
    String? country,
    String? imageUrl,
    double? price,
    double? rating,
    String? description,
    List<String>? categories,
    bool? isFavorite,
  }) {
    return DestinationModel(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      country: country ?? this.country,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      description: description ?? this.description,
      categories: categories ?? this.categories,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
