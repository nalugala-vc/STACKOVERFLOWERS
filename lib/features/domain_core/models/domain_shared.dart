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
    return PeriodPricing(
      register:
          (json['register'] as List<dynamic>?)
              ?.map((item) => PricingItem.fromJson(item))
              .toList() ??
          [],
      renew:
          (json['renew'] as List<dynamic>?)
              ?.map((item) => PricingItem.fromJson(item))
              .toList() ??
          [],
      transfer:
          (json['transfer'] as List<dynamic>?)
              ?.map((item) => PricingItem.fromJson(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'register': register.map((item) => item.toJson()).toList(),
      'renew': renew.map((item) => item.toJson()).toList(),
      'transfer': transfer.map((item) => item.toJson()).toList(),
    };
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
    return PricingItem(
      price: json['price'] as int,
      currency: json['currency'] as String,
      period: json['period'] as int,
      type: json['type'] as String,
    );
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
    return ShortestPeriod(
      period: json['period'] as int,
      register:
          (json['register'] as List<dynamic>?)
              ?.map((item) => PricingItem.fromJson(item))
              .toList() ??
          [],
      transfer:
          (json['transfer'] as List<dynamic>?)
              ?.map((item) => PricingItem.fromJson(item))
              .toList() ??
          [],
      renew:
          (json['renew'] as List<dynamic>?)
              ?.map((item) => PricingItem.fromJson(item))
              .toList() ??
          [],
    );
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
