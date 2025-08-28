class OrderListResponse {
  final bool success;
  final String message;
  final OrderListData data;

  OrderListResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory OrderListResponse.fromJson(Map<String, dynamic> json) {
    return OrderListResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: OrderListData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data.toJson()};
  }
}

class OrderListData {
  final int currentPage;
  final List<OrderItem> orders;
  final String? firstPageUrl;
  final int? from;
  final int lastPage;
  final String? lastPageUrl;
  final List<PageLink> links;
  final String? nextPageUrl;
  final String path;
  final int perPage;
  final String? prevPageUrl;
  final int? to;
  final int total;

  OrderListData({
    required this.currentPage,
    required this.orders,
    this.firstPageUrl,
    this.from,
    required this.lastPage,
    this.lastPageUrl,
    required this.links,
    this.nextPageUrl,
    required this.path,
    required this.perPage,
    this.prevPageUrl,
    this.to,
    required this.total,
  });

  factory OrderListData.fromJson(Map<String, dynamic> json) {
    return OrderListData(
      currentPage: json['current_page'] ?? 1,
      orders:
          (json['data'] as List<dynamic>?)
              ?.map((item) => OrderItem.fromJson(item))
              .toList() ??
          [],
      firstPageUrl: json['first_page_url'],
      from: json['from'],
      lastPage: json['last_page'] ?? 1,
      lastPageUrl: json['last_page_url'],
      links:
          (json['links'] as List<dynamic>?)
              ?.map((item) => PageLink.fromJson(item))
              .toList() ??
          [],
      nextPageUrl: json['next_page_url'],
      path: json['path'] ?? '',
      perPage: json['per_page'] ?? 10,
      prevPageUrl: json['prev_page_url'],
      to: json['to'],
      total: json['total'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'data': orders.map((order) => order.toJson()).toList(),
      'first_page_url': firstPageUrl,
      'from': from,
      'last_page': lastPage,
      'last_page_url': lastPageUrl,
      'links': links.map((link) => link.toJson()).toList(),
      'next_page_url': nextPageUrl,
      'path': path,
      'per_page': perPage,
      'prev_page_url': prevPageUrl,
      'to': to,
      'total': total,
    };
  }
}

class OrderItem {
  final int id;
  final int userId;
  final OrderStatus status;
  final String totalAmount;
  final String currency;
  final String? paymentReference;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<OrderDomainItem> items;

  OrderItem({
    required this.id,
    required this.userId,
    required this.status,
    required this.totalAmount,
    required this.currency,
    this.paymentReference,
    required this.createdAt,
    required this.updatedAt,
    required this.items,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      status: OrderStatus.fromString(json['status'] ?? 'pending'),
      totalAmount: json['total_amount'] ?? '0.00',
      currency: json['currency'] ?? 'KES',
      paymentReference: json['payment_reference'],
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
      items:
          (json['items'] as List<dynamic>?)
              ?.map((item) => OrderDomainItem.fromJson(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'status': status.value,
      'total_amount': totalAmount,
      'currency': currency,
      'payment_reference': paymentReference,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'items': items.map((item) => item.toJson()).toList(),
    };
  }

  double get totalAmountAsDouble => double.tryParse(totalAmount) ?? 0.0;
  bool get isPaid => status == OrderStatus.paid;
  bool get isPendingPayment => status == OrderStatus.pendingPayment;
}

class OrderDomainItem {
  final int id;
  final int orderId;
  final String domainName;
  final int numberOfYears;
  final String price;
  final String currency;
  final DomainStatus status;
  final String? registrarOrderId;
  final DateTime? expiresAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  OrderDomainItem({
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

  factory OrderDomainItem.fromJson(Map<String, dynamic> json) {
    return OrderDomainItem(
      id: json['id'] ?? 0,
      orderId: json['order_id'] ?? 0,
      domainName: json['domain_name'] ?? '',
      numberOfYears: json['number_of_years'] ?? 1,
      price: json['price'] ?? '0.00',
      currency: json['currency'] ?? 'KES',
      status: DomainStatus.fromString(json['status'] ?? 'pending'),
      registrarOrderId: json['registrar_order_id'],
      expiresAt:
          json['expires_at'] != null
              ? DateTime.tryParse(json['expires_at'])
              : null,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'domain_name': domainName,
      'number_of_years': numberOfYears,
      'price': price,
      'currency': currency,
      'status': status.value,
      'registrar_order_id': registrarOrderId,
      'expires_at': expiresAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  double get priceAsDouble => double.tryParse(price) ?? 0.0;
}

class PageLink {
  final String? url;
  final String label;
  final bool active;

  PageLink({this.url, required this.label, required this.active});

  factory PageLink.fromJson(Map<String, dynamic> json) {
    return PageLink(
      url: json['url'],
      label: json['label'] ?? '',
      active: json['active'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {'url': url, 'label': label, 'active': active};
  }
}

enum OrderStatus {
  pending('pending'),
  active('active'),
  expired('expired'),
  paid('paid'),
  cancelled('cancelled'),
  pendingPayment('pending_payment');

  const OrderStatus(this.value);
  final String value;

  static OrderStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'pending':
        return OrderStatus.pending;
      case 'active':
        return OrderStatus.active;
      case 'expired':
        return OrderStatus.expired;
      case 'paid':
        return OrderStatus.paid;
      case 'cancelled':
        return OrderStatus.cancelled;
      case 'pending_payment':
        return OrderStatus.pendingPayment;
      default:
        return OrderStatus.pending;
    }
  }

  String get displayName {
    switch (this) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.active:
        return 'Active';
      case OrderStatus.expired:
        return 'Expired';
      case OrderStatus.paid:
        return 'Paid';
      case OrderStatus.cancelled:
        return 'Cancelled';
      case OrderStatus.pendingPayment:
        return 'Pending Payment';
    }
  }
}

enum DomainStatus {
  pending('pending'),
  active('active'),
  expired('expired'),
  cancelled('cancelled');

  const DomainStatus(this.value);
  final String value;

  static DomainStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'pending':
        return DomainStatus.pending;
      case 'active':
        return DomainStatus.active;
      case 'expired':
        return DomainStatus.expired;
      case 'cancelled':
        return DomainStatus.cancelled;
      default:
        return DomainStatus.pending;
    }
  }

  String get displayName {
    switch (this) {
      case DomainStatus.pending:
        return 'Pending';
      case DomainStatus.active:
        return 'Active';
      case DomainStatus.expired:
        return 'Expired';
      case DomainStatus.cancelled:
        return 'Cancelled';
    }
  }
}
