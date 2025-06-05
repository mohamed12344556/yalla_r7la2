class DestinationModel {
  final String destinationId;
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
    required this.destinationId,
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
    destinationId: '1',
    name: 'Cairo, Egypt',
    imageUrl:
        'https://media.istockphoto.com/id/2149992523/photo/female-tourist-walks-between-pillars-of-the-great-hypostyle-hall-from-karnak-temple-and.jpg?s=612x612&w=0&k=20&c=JM_cvsp7Fj0eSyC6eeIMxifTC_qiJ-9jGklURN8wh6I=',
    images: [
      'https://media.istockphoto.com/id/1307368749/photo/woman-watches-sunset-at-the-giza-pyramids-she-looks-across-the-sahara-desert.jpg?s=612x612&w=0&k=20&c=QDI8Et6gnibfWzY7XC1q5TZqd9Ayn0ApLTCxSFn7qxg=',
      'https://media.istockphoto.com/id/1327507461/photo/traditional-nile-sailboats-near-the-banks-of-aswan-egypt.jpg?s=612x612&w=0&k=20&c=V_rKmNg0bq1hoU2joWZ_Ov_taWpCYzQ7MbL1f4wIEwA=',
    ],
    location: 'Cairo, Egypt',
    secondaryLocation: 'Africa',
    rating: 4.5,
    price: 100.0,
    description:
        'Explore ancient pyramids and the rich history of the Nile. Cairo is a vibrant city full of culture and life.',
    features: ['Pyramids', 'Nile River', 'Rich History'],
    isFavorite: false,
    category: 'Historical',
  ),
  DestinationModel(
    destinationId: '2',
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
    category: 'Romantic',
  ),
  DestinationModel(
    destinationId: '3',
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
    category: 'Modern',
  ),
  DestinationModel(
    destinationId: '4',
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
    category: 'Urban',
  ),
  DestinationModel(
    destinationId: '5',
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
    category: 'Cultural',
  ),
];
