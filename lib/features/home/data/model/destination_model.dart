class DestinationModel {
  final String destinationId;
  final String name;
  final String? description;
  final String? location;
  final String? category;
  final double? averageRating;
  final double? discount;
  final double? cost;
  final int? availableNumber;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool? isAvailable;
  final String? businessOwnerId;
  final List<DestinationImage>? images;

  DestinationModel({
    required this.destinationId,
    required this.name,
    this.description,
    this.location,
    this.category,
    this.averageRating,
    this.discount,
    this.cost,
    this.availableNumber,
    this.startDate,
    this.endDate,
    this.isAvailable,
    this.businessOwnerId,
    this.images,
  });

  String get imageUrl {
    if (images != null && images!.isNotEmpty) {
      return images!.first.imageUrl;
    }
    return 'https://via.placeholder.com/400x300?text=No+Image';
  }

  List<String> get imageUrls {
    if (images != null && images!.isNotEmpty) {
      return images!.map((img) => img.imageUrl).toList();
    }
    return ['https://via.placeholder.com/400x300?text=No+Image'];
  }

  double get rating => averageRating ?? 4.5;
  double get price => cost ?? 0.0;

  String get displayCategory {
    if (category == null) return 'Tourism';

    switch (category!.toLowerCase()) {
      case 'medicine':
        return 'Medical Tourism';
      case 'leisure tourism':
        return 'Leisure Tourism';
      case 'cultural & historical tourism':
        return 'Cultural & Historical Tourism';
      case 'adventure & eco tourism':
        return 'Adventure & Eco Tourism';
      case 'shopping tourism':
        return 'Shopping Tourism';
      case 'religious tourism':
        return 'Religious Tourism';
      case 'business & mice tourism':
        return 'Business & MICE Tourism';
      default:
        return category!;
    }
  }

  List<String>? get features {
    List<String> featuresList = [];

    if (isAvailable == true) {
      featuresList.add('Available Now');
    }

    if (discount != null && discount! > 0) {
      featuresList.add('${discount!.toStringAsFixed(0)}% Discount');
    }

    if (availableNumber != null && availableNumber! > 0) {
      featuresList.add('$availableNumber Spots Available');
    }

    if (startDate != null && endDate != null) {
      featuresList.add('Duration: ${_formatDateRange()}');
    }

    return featuresList.isNotEmpty ? featuresList : null;
  }

  String _formatDateRange() {
    if (startDate == null || endDate == null) return '';

    final duration = endDate!.difference(startDate!).inDays;
    if (duration == 0) {
      return 'Same Day';
    } else if (duration == 1) {
      return '1 Day';
    } else {
      return '$duration Days';
    }
  }

  factory DestinationModel.fromJson(Map<String, dynamic> json) {
    return DestinationModel(
      destinationId: json['destinationId'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      location: json['location'],
      category: json['category'],
      averageRating: json['averageRating']?.toDouble(),
      discount: json['discount']?.toDouble(),
      cost: json['cost']?.toDouble(),
      availableNumber: json['availableNumber'],
      startDate:
          json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      isAvailable: json['isAvailable'],
      businessOwnerId: json['businessOwnerId'],
      images:
          json['images'] != null
              ? (json['images'] as List)
                  .map((img) => DestinationImage.fromJson(img))
                  .toList()
              : null,
    );
  }

  factory DestinationModel.fromListJson(Map<String, dynamic> json) {
    return DestinationModel(
      destinationId: json['destinationId'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      location: json['location'],
      category: json['category'],
      averageRating: json['averageRating']?.toDouble(),
      discount: json['discount']?.toDouble(),
      cost: json['cost']?.toDouble(),
      images:
          json['images'] != null
              ? (json['images'] as List)
                  .map((img) => DestinationImage.fromListJson(img))
                  .toList()
              : null,
    );
  }

  factory DestinationModel.fromCategoryJson(Map<String, dynamic> json) {
    return DestinationModel(
      destinationId: json['destinationId'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      location: json['location'],
      category: json['category'],
      averageRating: json['averageRating']?.toDouble(),
      discount: json['discount']?.toDouble(),
      cost: json['cost']?.toDouble(),
      images:
          json['images'] != null
              ? (json['images'] as List)
                  .map((img) => DestinationImage.fromJson(img))
                  .toList()
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'destinationId': destinationId,
      'name': name,
      'description': description,
      'location': location,
      'category': category,
      'averageRating': averageRating,
      'discount': discount,
      'cost': cost,
      'availableNumber': availableNumber,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'isAvailable': isAvailable,
      'businessOwnerId': businessOwnerId,
      'images': images?.map((img) => img.toJson()).toList(),
    };
  }

  DestinationModel copyWith({
    String? destinationId,
    String? name,
    String? description,
    String? location,
    String? category,
    double? averageRating,
    double? discount,
    double? cost,
    int? availableNumber,
    DateTime? startDate,
    DateTime? endDate,
    bool? isAvailable,
    String? businessOwnerId,
    List<DestinationImage>? images,
  }) {
    return DestinationModel(
      destinationId: destinationId ?? this.destinationId,
      name: name ?? this.name,
      description: description ?? this.description,
      location: location ?? this.location,
      category: category ?? this.category,
      averageRating: averageRating ?? this.averageRating,
      discount: discount ?? this.discount,
      cost: cost ?? this.cost,
      availableNumber: availableNumber ?? this.availableNumber,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isAvailable: isAvailable ?? this.isAvailable,
      businessOwnerId: businessOwnerId ?? this.businessOwnerId,
      images: images ?? this.images,
    );
  }
}

class DestinationImage {
  final String imageId;
  final String imageUrl;

  DestinationImage({required this.imageId, required this.imageUrl});

  factory DestinationImage.fromJson(Map<String, dynamic> json) {
    return DestinationImage(
      imageId: json['imageId'] ?? '',
      imageUrl: json['imagePath'] ?? '',
    );
  }

  factory DestinationImage.fromListJson(Map<String, dynamic> json) {
    return DestinationImage(
      imageId: json['imageId'] ?? '',
      imageUrl: json['imagePath'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'imageId': imageId, 'imagePath': imageUrl};
  }
}
