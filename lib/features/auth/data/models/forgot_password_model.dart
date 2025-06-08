class ForgotPasswordResponse {
  final String message;

  ForgotPasswordResponse({required this.message});

  factory ForgotPasswordResponse.fromJson(String json) {
    return ForgotPasswordResponse(message: json);
  }

  Map<String, dynamic> toJson() {
    return {'message': message};
  }
}
