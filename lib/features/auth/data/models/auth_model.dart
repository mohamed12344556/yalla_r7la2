class AuthResponse {
  final String token;
  final String? expiration;
  final String? userId;
  final String? email;
  final String? fullName;

  AuthResponse({
    required this.token,
    this.expiration,
    this.userId,
    this.email,
    this.fullName,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'] ?? '',
      expiration: json['expiration'],
      userId: json['userId'],
      email: json['email'],
      fullName: json['fullName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'expiration': expiration,
      'userId': userId,
      'email': email,
      'fullName': fullName,
    };
  }
}
