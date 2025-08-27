import 'package:kenic/features/domain_core/models/domain_shared.dart';

class DomainSearch {
  final DomainInfo domain;
  final List<DomainInfo> suggestions;

  DomainSearch({required this.domain, required this.suggestions});

  factory DomainSearch.fromJson(Map<String, dynamic> json) {
    return DomainSearch(
      domain: DomainInfo.fromJson(json['domain']),
      suggestions:
          (json['suggestions'] as List<dynamic>)
              .map((suggestion) => DomainInfo.fromJson(suggestion))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'domain': domain.toJson(),
      'suggestions': suggestions.map((s) => s.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'DomainSearch(domain: $domain, suggestions: $suggestions)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DomainSearch &&
        other.domain == domain &&
        other.suggestions == suggestions;
  }

  @override
  int get hashCode {
    return domain.hashCode ^ suggestions.hashCode;
  }
}

class DomainInfo {
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
  final KePricing? kePricing;

  DomainInfo({
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
    this.kePricing,
  });

  factory DomainInfo.fromJson(Map<String, dynamic> json) {
    // Debug logging
    print('Parsing DomainInfo: ${json.keys}');
    print('Pricing field type: ${json['pricing'].runtimeType}');
    print('Pricing content: ${json['pricing']}');

    // Safe parsing for pricing
    Map<String, PeriodPricing> pricingMap = {};
    if (json['pricing'] is Map<String, dynamic>) {
      final pricingJson = json['pricing'] as Map<String, dynamic>;
      pricingJson.forEach((key, value) {
        try {
          if (value is Map<String, dynamic>) {
            pricingMap[key] = PeriodPricing.fromJson(value);
          } else {
            print('Warning: Pricing value for key $key is not a Map: $value');
          }
        } catch (e) {
          print('Error parsing pricing for key $key: $e');
        }
      });
    } else {
      print('Warning: Pricing field is not a Map: ${json['pricing']}');
    }

    return DomainInfo(
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
      kePricing:
          json['ke_pricing'] != null
              ? KePricing.fromJson(json['ke_pricing'])
              : null,
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
      'ke_pricing': kePricing?.toJson(),
    };
  }

  @override
  String toString() {
    return 'DomainInfo(domainName: $domainName, status: $status, isAvailable: $isAvailable)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DomainInfo &&
        other.domainName == domainName &&
        other.status == status &&
        other.isAvailable == isAvailable;
  }

  @override
  int get hashCode {
    return domainName.hashCode ^ status.hashCode ^ isAvailable.hashCode;
  }
}
