class OrderResponse {
  final bool success;
  final String message;
  final OrderData? data;

  OrderResponse({required this.success, required this.message, this.data});

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    return OrderResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null ? OrderData.fromJson(json['data']) : null,
    );
  }
}

class OrderData {
  final String status;
  final String totalAmount;
  final String currency;
  final int userId;
  final String updatedAt;
  final String createdAt;
  final int id;

  OrderData({
    required this.status,
    required this.totalAmount,
    required this.currency,
    required this.userId,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      status: json['status'] as String? ?? '',
      totalAmount: json['total_amount'] as String? ?? '0.00',
      currency: json['currency'] as String? ?? 'KES',
      userId: json['user_id'] as int? ?? 0,
      updatedAt: json['updated_at'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
      id: json['id'] as int? ?? 0,
    );
  }
}

enum PaymentMethod {
  mpesa,
  card;

  String get value => name.toLowerCase();
}

class CardPaymentDetails {
  final String cardNumber;
  final String cvv;
  final String expiryMonth;
  final String expiryYear;

  CardPaymentDetails({
    required this.cardNumber,
    required this.cvv,
    required this.expiryMonth,
    required this.expiryYear,
  });

  Map<String, String> toJson() {
    return {
      'card_number': cardNumber,
      'cvv': cvv,
      'expiry_month': expiryMonth,
      'expiry_year': expiryYear,
    };
  }
}
