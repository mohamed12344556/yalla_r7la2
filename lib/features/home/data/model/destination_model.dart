class DestinationModel {
  final String name;
  final String imageUrl;
  final List<String>? images;
  final String location;
  final String secondaryLocation;
  final double? rating;
  final double price;
  final String description;
  final List<String>? features;
  final bool? isFavorite;
  final String? category; // Added category field

  DestinationModel({
    required this.name,
    required this.imageUrl,
    this.images,
    required this.location,
    required this.secondaryLocation,
    this.rating,
    required this.price,
    required this.description,
    this.features,
    this.isFavorite,
    this.category, // Initialize category
  });
}

List<DestinationModel> cards = [
  DestinationModel(
    name: 'Cairo, Egypt',
    imageUrl: 'https://via.placeholder.com/400x300',
    images: [
      'https://via.placeholder.com/400x300',
      'https://via.placeholder.com/400x300?text=Image+2',
    ],
    location: 'Cairo, Egypt',
    secondaryLocation: 'Africa',
    rating: 4.5,
    price: 100.0,
    description:
        'Explore ancient pyramids and the rich history of the Nile. Cairo is a vibrant city full of culture and life.',
    features: ['Pyramids', 'Nile River', 'Rich History'],
    isFavorite: false,
    category: 'Historical', // Added category
  ),
  DestinationModel(
    name: 'Paris, France',
    imageUrl: 'https://via.placeholder.com/400x300',
    images: [
      'https://via.placeholder.com/400x300',
      'https://via.placeholder.com/400x300?text=Image+2',
    ],
    location: 'Paris, France',
    secondaryLocation: 'Europe',
    rating: 4.8,
    price: 250.0,
    description:
        'Visit the Eiffel Tower and stroll through romantic streets. Paris is the heart of fashion and art.',
    features: ['Eiffel Tower', 'Art Museums', 'Romantic Streets'],
    isFavorite: false,
    category: 'Romantic', // Added category
  ),
  DestinationModel(
    name: 'Tokyo, Japan',
    imageUrl: 'https://via.placeholder.com/400x300',
    images: [
      'https://via.placeholder.com/400x300',
      'https://via.placeholder.com/400x300?text=Image+2',
    ],
    location: 'Tokyo, Japan',
    secondaryLocation: 'Asia',
    rating: 4.9,
    price: 300.0,
    description:
        'Experience the blend of tradition and technology. Tokyo offers temples, sushi, and neon nights.',
    features: ['Temples', 'Sushi', 'Neon Nights'],
    isFavorite: false,
    category: 'Modern', // Added category
  ),
  DestinationModel(
    name: 'New York, USA',
    imageUrl: 'https://via.placeholder.com/400x300',
    images: [
      'https://via.placeholder.com/400x300',
      'https://via.placeholder.com/400x300?text=Image+2',
    ],
    location: 'New York, USA',
    secondaryLocation: 'North America',
    rating: 4.7,
    price: 220.0,
    description:
        'See Times Square and Central Park in the city that never sleeps. New York is always buzzing with energy.',
    features: ['Times Square', 'Central Park', 'Broadway Shows'],
    isFavorite: false,
    category: 'Urban', // Added category
  ),
  DestinationModel(
    name: 'Rome, Italy',
    imageUrl: 'https://via.placeholder.com/400x300',
    images: [
      'https://via.placeholder.com/400x300',
      'https://via.placeholder.com/400x300?text=Image+2',
    ],
    location: 'Rome, Italy',
    secondaryLocation: 'Europe',
    rating: 4.6,
    price: 180.0,
    description:
        'Walk through history in the Eternal City. Rome is famous for its architecture and delicious cuisine.',
    features: ['Colosseum', 'Vatican City', 'Italian Cuisine'],
    isFavorite: false,
    category: 'Cultural', // Added category
  ),
];
