import 'package:kenic/features/domain_core/models/domain.dart';

class CartItem {
  final Domain domain;
  final int quantity;
  final int registrationYears;
  final double totalPrice;
  final int? itemId; // API item ID for cart operations

  CartItem({
    required this.domain,
    this.quantity = 1,
    this.registrationYears = 1,
    this.itemId,
  }) : totalPrice = domain.price * registrationYears;

  CartItem copyWith({
    Domain? domain,
    int? quantity,
    int? registrationYears,
    int? itemId,
  }) {
    return CartItem(
      domain: domain ?? this.domain,
      quantity: quantity ?? this.quantity,
      registrationYears: registrationYears ?? this.registrationYears,
      itemId: itemId ?? this.itemId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'domain': domain.toJson(),
      'quantity': quantity,
      'registrationYears': registrationYears,
      'totalPrice': totalPrice,
      'itemId': itemId,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      domain: Domain.fromJson(json['domain']),
      quantity: json['quantity'] ?? 1,
      registrationYears: json['registrationYears'] ?? 1,
      itemId: json['itemId'],
    );
  }
}

class Cart {
  final List<CartItem> items;
  final double subtotal;
  final double tax;
  final double discount;
  final double total;
  final String? promoCode;

  Cart({
    required this.items,
    this.tax = 0.0,
    this.discount = 0.0,
    this.promoCode,
  }) : subtotal = items.fold(0.0, (sum, item) => sum + item.totalPrice),
       total =
           items.fold(0.0, (sum, item) => sum + item.totalPrice) +
           tax -
           discount;

  Cart copyWith({
    List<CartItem>? items,
    double? tax,
    double? discount,
    String? promoCode,
  }) {
    return Cart(
      items: items ?? this.items,
      tax: tax ?? this.tax,
      discount: discount ?? this.discount,
      promoCode: promoCode ?? this.promoCode,
    );
  }

  int get itemCount => items.length;

  bool get isEmpty => items.isEmpty;

  bool get isNotEmpty => items.isNotEmpty;

  CartItem? findItem(String domainName) {
    try {
      return items.firstWhere(
        (item) => item.domain.fullDomainName == domainName,
      );
    } catch (e) {
      return null;
    }
  }

  bool containsDomain(String domainName) {
    return findItem(domainName) != null;
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
      'subtotal': subtotal,
      'tax': tax,
      'discount': discount,
      'total': total,
      'promoCode': promoCode,
    };
  }

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      items:
          (json['items'] as List<dynamic>?)
              ?.map((item) => CartItem.fromJson(item))
              .toList() ??
          [],
      tax: (json['tax'] ?? 0.0).toDouble(),
      discount: (json['discount'] ?? 0.0).toDouble(),
      promoCode: json['promoCode'],
    );
  }

  factory Cart.empty() {
    return Cart(items: []);
  }
}
