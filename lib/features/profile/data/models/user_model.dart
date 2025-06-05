import 'dart:convert';
import 'dart:typed_data';

class UserModel {
  final String? id;
  final String? name;
  final String? email;
  final String? city;
  final int? age;
  final String? preference;
  final String? imageData;
  final Uint8List? imageBytes;
  final String? phoneNumber;
  final String? password;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.city,
    this.age,
    this.preference,
    this.imageData,
    this.imageBytes,
    this.phoneNumber,
    this.password,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    Uint8List? bytes;
    String? imageDataString;

    // معالجة البيانات المختلفة للصورة
    if (json['imageBase64'] != null) {
      final imageValue = json['imageBase64'];

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
      preference: json['prefrance'],
      imageData: imageDataString,
      imageBytes: bytes,
      phoneNumber: json['phoneNumber'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'city': city,
      'age': age,
      'prefrance': preference,
      'imageBase64': imageData,
      'phoneNumber': phoneNumber,
      'password': password,
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
    String? phoneNumber,
    String? password,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      city: city ?? this.city,
      age: age ?? this.age,
      preference: prefrance ?? preference,
      imageData: imageData ?? this.imageData,
      imageBytes: imageBytes ?? this.imageBytes,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
    );
  }
}
