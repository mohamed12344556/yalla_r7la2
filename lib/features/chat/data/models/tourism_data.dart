class TourismData {
  final String destination;
  final List<String> attractions;
  final List<String> hotels;
  final List<String> food;
  final String bestTime;
  final String language;
  final String currency;
  final List<String> transportation;
  final String context;

  TourismData({
    required this.destination,
    required this.attractions,
    required this.hotels,
    required this.food,
    required this.bestTime,
    required this.language,
    required this.currency,
    required this.transportation,
    required this.context,
  });

  factory TourismData.fromJson(Map<String, dynamic> json) {
    return TourismData(
      destination: json['destination'],
      attractions: List<String>.from(json['attractions']),
      hotels: List<String>.from(json['hotels']),
      food: List<String>.from(json['food']),
      bestTime: json['best_time'],
      language: json['language'],
      currency: json['currency'],
      transportation: List<String>.from(json['transportation']),
      context: json['context'],
    );
  }
}
