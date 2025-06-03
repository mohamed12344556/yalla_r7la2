import 'dart:convert';
import 'dart:typed_data';

class UserModel {
  final String? id;
  final String? name;
  final String? email;
  final String? city;
  final int? age;
  final String? prefrance;
  final String? imageData; // Base64 string or URL
  final Uint8List? imageBytes; // Raw byte data
  final String? phoneNumber; // Added phone Stringber
  final String? password; // Added password

  UserModel({
    this.id,
    this.name,
    this.email,
    this.city,
    this.age,
    this.prefrance,
    this.imageData,
    this.imageBytes,
    this.phoneNumber, // Added phone Stringber
    this.password, // Added password
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    Uint8List? bytes;
    String? imageDataString;

    // معالجة البيانات المختلفة للصورة
    if (json['imageData'] != null) {
      final imageValue = json['imageData'];

      if (imageValue is String) {
        imageDataString = imageValue;
        // إذا كانت البيانات Base64، قم بتحويلها إلى bytes
        if (imageValue.startsWith('data:image') ||
            !imageValue.startsWith('http')) {
          try {
            // إزالة prefix إذا كان موجود
            String base64String = imageValue;
            if (imageValue.contains(',')) {
              base64String = imageValue.split(',')[1];
            }
            bytes = base64Decode(base64String);
          } catch (e) {
            print('Error decoding base64 image: $e');
          }
        }
      } else if (imageValue is List) {
        // إذا كانت البيانات array من الأرقام
        bytes = Uint8List.fromList(imageValue.cast<int>());
      }
    }

    return UserModel(
      id: json['id']?.toString(),
      name: json['name'],
      email: json['email'],
      city: json['city'],
      age: json['age'],
      prefrance: json['prefrance'],
      imageData: imageDataString,
      imageBytes: bytes,
      phoneNumber: json['phoneNumber'], // Added phone Stringber
      password: json['password'], // Added password
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'city': city,
      'age': age,
      'prefrance': prefrance,
      'imageData': imageData,
      'phoneNumber': phoneNumber, // Added phone Stringber
      'password': password, // Added password
      // لا نرسل imageBytes في JSON
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? city,
    int? age,
    String? prefrance,
    String? imageData,
    Uint8List? imageBytes,
    String? phoneNumber, // Added phone Stringber
    String? password, // Added password
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      city: city ?? this.city,
      age: age ?? this.age,
      prefrance: prefrance ?? this.prefrance,
      imageData: imageData ?? this.imageData,
      imageBytes: imageBytes ?? this.imageBytes,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
    );
  }
}
