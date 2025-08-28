class PaymentResponse {
  final bool success;
  final String message;
  final PaymentData? data;

  PaymentResponse({required this.success, required this.message, this.data});

  factory PaymentResponse.fromJson(Map<String, dynamic> json) {
    return PaymentResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null ? PaymentData.fromJson(json['data']) : null,
    );
  }
}

class PaymentData {
  final int orderId;
  final int userId;
  final double amount;
  final String currency;
  final String status;
  final String paymentMethod;
  final String? paymentReference;
  final int? transactionId;
  final String updatedAt;
  final String createdAt;
  final int id;

  PaymentData({
    required this.orderId,
    required this.userId,
    required this.amount,
    required this.currency,
    required this.status,
    required this.paymentMethod,
    this.paymentReference,
    this.transactionId,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory PaymentData.fromJson(Map<String, dynamic> json) {
    return PaymentData(
      orderId: json['order_id'] as int? ?? 0,
      userId: json['user_id'] as int? ?? 0,
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
      currency: json['currency'] as String? ?? 'KES',
      status: json['status'] as String? ?? '',
      paymentMethod: json['payment_method'] as String? ?? '',
      paymentReference: json['payment_reference'] as String?,
      transactionId: json['transaction_id'] as int?,
      updatedAt: json['updated_at'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
      id: json['id'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'user_id': userId,
      'amount': amount,
      'currency': currency,
      'status': status,
      'payment_method': paymentMethod,
      'payment_reference': paymentReference,
      'transaction_id': transactionId,
      'updated_at': updatedAt,
      'created_at': createdAt,
      'id': id,
    };
  }
}
