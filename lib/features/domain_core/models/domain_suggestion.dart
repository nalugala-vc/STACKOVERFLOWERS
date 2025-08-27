import 'package:kenic/features/domain_core/models/domain_shared.dart';

class DomainSuggestionResponse {
  final String domainName;
  final String idnDomainName;
  final String tld;
  final String tldNoDots;
  final String sld;
  final String idnSld;
  final String status;
  final String legacyStatus;
  final int score;
  final bool isRegistered;
  final bool isAvailable;
  final bool isValidDomain;
  final String domainErrorMessage;
  final Map<String, PeriodPricing> pricing;
  final ShortestPeriod shortestPeriod;
  final String group;
  final int minLength;
  final int maxLength;
  final bool isPremium;
  final List<dynamic> premiumCostPricing;

  DomainSuggestionResponse({
    required this.domainName,
    required this.idnDomainName,
    required this.tld,
    required this.tldNoDots,
    required this.sld,
    required this.idnSld,
    required this.status,
    required this.legacyStatus,
    required this.score,
    required this.isRegistered,
    required this.isAvailable,
    required this.isValidDomain,
    required this.domainErrorMessage,
    required this.pricing,
    required this.shortestPeriod,
    required this.group,
    required this.minLength,
    required this.maxLength,
    required this.isPremium,
    required this.premiumCostPricing,
  });

  factory DomainSuggestionResponse.fromJson(Map<String, dynamic> json) {
    // Safe parsing for pricing similar to DomainInfo
    Map<String, PeriodPricing> pricingMap = {};
    final pricing = json['pricing'];
    if (pricing is Map) {
      pricing.forEach((key, value) {
        try {
          if (value is Map) {
            pricingMap[key.toString()] = PeriodPricing.fromJson(
              Map<String, dynamic>.from(value),
            );
          } else {
            print('Warning: Pricing value for key $key is not a Map: $value');
          }
        } catch (e) {
          print('Error parsing pricing for key $key: $e');
        }
      });
    } else {
      print('Warning: Pricing field is not a Map: $pricing');
    }

    return DomainSuggestionResponse(
      domainName: json['domainName'] as String,
      idnDomainName: json['idnDomainName'] as String,
      tld: json['tld'] as String,
      tldNoDots: json['tldNoDots'] as String,
      sld: json['sld'] as String,
      idnSld: json['idnSld'] as String,
      status: json['status'] as String,
      legacyStatus: json['legacyStatus'] as String,
      score: json['score'] as int,
      isRegistered: json['isRegistered'] as bool,
      isAvailable: json['isAvailable'] as bool,
      isValidDomain: json['isValidDomain'] as bool,
      domainErrorMessage: json['domainErrorMessage'] as String,
      pricing: pricingMap,
      shortestPeriod:
          json['shortestPeriod'] != null
              ? ShortestPeriod.fromJson(json['shortestPeriod'])
              : ShortestPeriod(
                period: 1,
                register: [],
                transfer: [],
                renew: [],
              ),
      group: json['group'] as String,
      minLength: json['minLength'] as int,
      maxLength: json['maxLength'] as int,
      isPremium: json['isPremium'] as bool,
      premiumCostPricing:
          json['premiumCostPricing'] is List<dynamic>
              ? json['premiumCostPricing'] as List<dynamic>
              : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'domainName': domainName,
      'idnDomainName': idnDomainName,
      'tld': tld,
      'tldNoDots': tldNoDots,
      'sld': sld,
      'idnSld': idnSld,
      'status': status,
      'legacyStatus': legacyStatus,
      'score': score,
      'isRegistered': isRegistered,
      'isAvailable': isAvailable,
      'isValidDomain': isValidDomain,
      'domainErrorMessage': domainErrorMessage,
      'pricing': pricing.map((key, value) => MapEntry(key, value.toJson())),
      'shortestPeriod': shortestPeriod.toJson(),
      'group': group,
      'minLength': minLength,
      'maxLength': maxLength,
      'isPremium': isPremium,
      'premiumCostPricing': premiumCostPricing,
    };
  }

  // Helper method to get the best price for registration
  String? get bestRegistrationPrice {
    if (pricing.isEmpty) return null;

    // Find the first period with registration pricing
    for (int i = 1; i <= 10; i++) {
      final periodKey = i.toString();
      if (pricing.containsKey(periodKey) &&
          pricing[periodKey]!.register.isNotEmpty) {
        final price = pricing[periodKey]!.register.first.price;
        final currency = pricing[periodKey]!.register.first.currency;
        return '$price $currency';
      }
    }
    return null;
  }

  @override
  String toString() {
    return 'DomainSuggestionResponse(domainName: $domainName, status: $status, isAvailable: $isAvailable)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DomainSuggestionResponse &&
        other.domainName == domainName &&
        other.status == status &&
        other.isAvailable == isAvailable;
  }

  @override
  int get hashCode {
    return domainName.hashCode ^ status.hashCode ^ isAvailable.hashCode;
  }
}
