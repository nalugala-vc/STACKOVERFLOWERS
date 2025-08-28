import 'package:kenic/features/domain_core/models/models.dart';

class DomainConverter {
  /// Converts DomainInfo to a simplified format for cart operations
  static Map<String, dynamic> domainInfoToCartFormat(DomainInfo domainInfo) {
    // Extract the first year registration price from pricing
    double price = 0.0;
    if (domainInfo.pricing.isNotEmpty) {
      final firstYearPricing = domainInfo.pricing['1'];
      if (firstYearPricing != null && firstYearPricing.register.isNotEmpty) {
        price = firstYearPricing.register.first.price.toDouble();
      }
    }

    // If no pricing found in the first year, try to get from kePricing
    if (price == 0.0 && domainInfo.kePricing != null) {
      try {
        price = double.parse(domainInfo.kePricing!.registrationPrice);
      } catch (e) {
        // If parsing fails, set a default price
        price = 999.0; // Default price in KES
      }
    }

    return {
      'domain_name': domainInfo.domainName,
      'price': price,
      'is_available': domainInfo.isAvailable,
      'tld': domainInfo.tld,
      'status': domainInfo.status,
    };
  }

  /// Gets the first year registration price from DomainInfo
  static double getFirstYearPrice(DomainInfo domainInfo) {
    // Try to get price from pricing map first
    if (domainInfo.pricing.isNotEmpty) {
      final firstYearPricing = domainInfo.pricing['1'];
      if (firstYearPricing != null && firstYearPricing.register.isNotEmpty) {
        return firstYearPricing.register.first.price.toDouble();
      }
    }

    // Fallback to kePricing
    if (domainInfo.kePricing != null) {
      try {
        return double.parse(domainInfo.kePricing!.registrationPrice);
      } catch (e) {
        // If parsing fails, return default price
        return 999.0; // Default price in KES
      }
    }

    // Final fallback
    return 999.0;
  }

  /// Converts DomainInfo to Domain model for cart compatibility
  static Domain domainInfoToDomain(DomainInfo domainInfo) {
    final price = getFirstYearPrice(domainInfo);

    // Split the domain name to get SLD and TLD consistently
    final domainParts = domainInfo.domainName.split('.');
    final sld = domainParts.first;
    final tld =
        domainParts.length > 1 ? '.${domainParts.sublist(1).join('.')}' : '';

    return Domain(
      name: sld,
      extension: tld,
      isAvailable: domainInfo.isAvailable,
      price: price,
      description: 'Domain registration for ${domainInfo.domainName}',
    );
  }
}
