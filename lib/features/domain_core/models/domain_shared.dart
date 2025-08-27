class PeriodPricing {
  final List<PricingItem> register;
  final List<PricingItem> renew;
  final List<PricingItem> transfer;

  PeriodPricing({
    required this.register,
    required this.renew,
    required this.transfer,
  });

  factory PeriodPricing.fromJson(Map<String, dynamic> json) {
    try {
      // Convert the input json to ensure proper types
      final Map<String, dynamic> safeJson = Map<String, dynamic>.from(json);
      return PeriodPricing(
        register: _parsePricingList(safeJson['register']),
        renew: _parsePricingList(safeJson['renew']),
        transfer: _parsePricingList(safeJson['transfer']),
      );
    } catch (e) {
      print('Error parsing PeriodPricing: $e');
      print('JSON content: $json');
      return PeriodPricing(register: [], renew: [], transfer: []);
    }
  }

  static List<PricingItem> _parsePricingList(dynamic value) {
    if (value == null) return [];
    if (value is! List) return [];

    return value
        .map((item) {
          if (item is! Map<String, dynamic>) return null;
          try {
            return PricingItem.fromJson(item);
          } catch (e) {
            print('Error parsing PricingItem: $e');
            return null;
          }
        })
        .whereType<PricingItem>()
        .toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'register': register.map((item) => item.toJson()).toList(),
      'renew': renew.map((item) => item.toJson()).toList(),
      'transfer': transfer.map((item) => item.toJson()).toList(),
    };
  }

  // Helper method to get the best registration price
  String? get bestRegistrationPrice {
    if (register.isEmpty) return null;
    final firstPrice = register.first;
    return '${firstPrice.price} ${firstPrice.currency}';
  }
}

class PricingItem {
  final int price;
  final String currency;
  final int period;
  final String type;

  PricingItem({
    required this.price,
    required this.currency,
    required this.period,
    required this.type,
  });

  factory PricingItem.fromJson(Map<String, dynamic> json) {
    try {
      final Map<String, dynamic> safeJson = Map<String, dynamic>.from(json);
      return PricingItem(
        price:
            safeJson['price'] is int
                ? safeJson['price']
                : int.parse(safeJson['price'].toString()),
        currency: safeJson['currency'].toString(),
        period:
            safeJson['period'] is int
                ? safeJson['period']
                : int.parse(safeJson['period'].toString()),
        type: safeJson['type'].toString(),
      );
    } catch (e) {
      print('Error parsing PricingItem: $e');
      print('JSON content: $json');
      throw FormatException('Invalid PricingItem format: $e');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'price': price,
      'currency': currency,
      'period': period,
      'type': type,
    };
  }
}

class ShortestPeriod {
  final int period;
  final List<PricingItem> register;
  final List<PricingItem> transfer;
  final List<PricingItem> renew;

  ShortestPeriod({
    required this.period,
    required this.register,
    required this.transfer,
    required this.renew,
  });

  factory ShortestPeriod.fromJson(Map<String, dynamic> json) {
    try {
      return ShortestPeriod(
        period: json['period'] as int? ?? 1,
        register: PeriodPricing._parsePricingList(json['register']),
        transfer: PeriodPricing._parsePricingList(json['transfer']),
        renew: PeriodPricing._parsePricingList(json['renew']),
      );
    } catch (e) {
      print('Error parsing ShortestPeriod: $e');
      print('JSON content: $json');
      return ShortestPeriod(period: 1, register: [], transfer: [], renew: []);
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'period': period,
      'register': register.map((item) => item.toJson()).toList(),
      'transfer': transfer.map((item) => item.toJson()).toList(),
      'renew': renew.map((item) => item.toJson()).toList(),
    };
  }
}

class KePricing {
  final String registrationPrice;
  final String renewalPrice;
  final String transferPrice;
  final String graceFee;
  final int graceDays;
  final int redemptionDays;
  final String redemptionFee;
  final List<int> availableYears;
  final String currency;

  KePricing({
    required this.registrationPrice,
    required this.renewalPrice,
    required this.transferPrice,
    required this.graceFee,
    required this.graceDays,
    required this.redemptionDays,
    required this.redemptionFee,
    required this.availableYears,
    required this.currency,
  });

  factory KePricing.fromJson(Map<String, dynamic> json) {
    return KePricing(
      registrationPrice: json['registration_price'] as String,
      renewalPrice: json['renewal_price'] as String,
      transferPrice: json['transfer_price'] as String,
      graceFee: json['grace_fee'] as String,
      graceDays: json['grace_days'] as int,
      redemptionDays: json['redemption_days'] as int,
      redemptionFee: json['redemption_fee'] as String,
      availableYears: List<int>.from(json['available_years']),
      currency: json['currency'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'registration_price': registrationPrice,
      'renewal_price': renewalPrice,
      'transfer_price': transferPrice,
      'grace_fee': graceFee,
      'grace_days': graceDays,
      'redemption_days': redemptionDays,
      'redemption_fee': redemptionFee,
      'available_years': availableYears,
      'currency': currency,
    };
  }
}
