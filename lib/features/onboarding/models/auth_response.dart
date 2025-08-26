import 'package:kenic/features/onboarding/models/user.dart';

class AuthResponse {
  final User? data;
  final String message;
  final String? token;

  AuthResponse({this.data, required this.message, this.token});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      data: json['data'] != null ? User.fromJson(json['data']) : null,
      message: json['message'] as String,
      token: json['token'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'data': data?.toJson(), 'message': message, 'token': token};
  }

  @override
  String toString() {
    return 'AuthResponse(data: $data, message: $message, token: $token)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthResponse &&
        other.data == data &&
        other.message == message &&
        other.token == token;
  }

  @override
  int get hashCode {
    return data.hashCode ^ message.hashCode ^ token.hashCode;
  }
}
