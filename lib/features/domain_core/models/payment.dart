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

class OrderDetails {
  final int id;
  final int userId;
  final String status;
  final String totalAmount;
  final String currency;
  final String? paymentReference;
  final String createdAt;
  final String updatedAt;
  final List<OrderItem> items;
  final UserDetails? user;

  OrderDetails({
    required this.id,
    required this.userId,
    required this.status,
    required this.totalAmount,
    required this.currency,
    this.paymentReference,
    required this.createdAt,
    required this.updatedAt,
    this.items = const [],
    this.user,
  });

  factory OrderDetails.fromJson(Map<String, dynamic> json) {
    return OrderDetails(
      id: json['id'] as int? ?? 0,
      userId: json['user_id'] as int? ?? 0,
      status: json['status'] as String? ?? '',
      totalAmount: json['total_amount'] as String? ?? '0.00',
      currency: json['currency'] as String? ?? 'KES',
      paymentReference: json['payment_reference'] as String?,
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
      items:
          (json['items'] as List<dynamic>?)
              ?.map((item) => OrderItem.fromJson(item))
              .toList() ??
          [],
      user:
          json['user'] != null
              ? UserDetails.fromJson(json['user'] as Map<String, dynamic>)
              : null,
    );
  }
}

class OrderItem {
  final int id;
  final int orderId;
  final String domainName;
  final int numberOfYears;
  final String price;
  final String currency;
  final String status;
  final String? registrarOrderId;
  final String? expiresAt;
  final String createdAt;
  final String updatedAt;

  OrderItem({
    required this.id,
    required this.orderId,
    required this.domainName,
    required this.numberOfYears,
    required this.price,
    required this.currency,
    required this.status,
    this.registrarOrderId,
    this.expiresAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] as int? ?? 0,
      orderId: json['order_id'] as int? ?? 0,
      domainName: json['domain_name'] as String? ?? '',
      numberOfYears: json['number_of_years'] as int? ?? 1,
      price: json['price'] as String? ?? '0.00',
      currency: json['currency'] as String? ?? 'KES',
      status: json['status'] as String? ?? '',
      registrarOrderId: json['registrar_order_id'] as String?,
      expiresAt: json['expires_at'] as String?,
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
    );
  }
}

class UserDetails {
  final int id;
  final String name;
  final String email;
  final String phoneNumber;
  final String? emailVerifiedAt;
  final String createdAt;
  final String updatedAt;

  UserDetails({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phoneNumber: json['phone_number'] as String? ?? '',
      emailVerifiedAt: json['email_verified_at'] as String?,
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
    );
  }
}

class TaxDetails {
  final int id;
  final int userId;
  final int orderId;
  final int taxId;
  final int orderItemId;
  final int paymentId;
  final String currency;
  final String amount;
  final String paymentStatus;
  final String createdAt;
  final String updatedAt;

  TaxDetails({
    required this.id,
    required this.userId,
    required this.orderId,
    required this.taxId,
    required this.orderItemId,
    required this.paymentId,
    required this.currency,
    required this.amount,
    required this.paymentStatus,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TaxDetails.fromJson(Map<String, dynamic> json) {
    return TaxDetails(
      id: json['id'] as int? ?? 0,
      userId: json['user_id'] as int? ?? 0,
      orderId: json['order_id'] as int? ?? 0,
      taxId: json['tax_id'] as int? ?? 0,
      orderItemId: json['order_item_id'] as int? ?? 0,
      paymentId: json['payment_id'] as int? ?? 0,
      currency: json['currency'] as String? ?? 'KES',
      amount: json['amount'] as String? ?? '0.00',
      paymentStatus: json['payment_status'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
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
  final String? paymentUrl;
  final OrderDetails? order;
  final List<TaxDetails> taxes;

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
    this.paymentUrl,
    this.order,
    this.taxes = const [],
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
      paymentUrl: json['payment_url'] as String?,
      order:
          json['order'] != null
              ? OrderDetails.fromJson(json['order'] as Map<String, dynamic>)
              : null,
      taxes:
          (json['taxes'] as List<dynamic>?)
              ?.map((tax) => TaxDetails.fromJson(tax as Map<String, dynamic>))
              .toList() ??
          [],
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
