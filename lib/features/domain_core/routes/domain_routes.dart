import 'package:get/get.dart';
import 'package:kenic/features/domain_core/views/home_dashboard.dart';
import 'package:kenic/features/domain_core/views/domain_search_results.dart';
import 'package:kenic/features/domain_core/views/domain_details.dart';
import 'package:kenic/features/domain_core/views/cart_checkout.dart';
import 'package:kenic/features/domain_core/views/payment_confirmation.dart';

class DomainRoutes {
  static const String home = '/home';
  static const String searchResults = '/search-results';
  static const String domainDetails = '/domain-details';
  static const String cart = '/cart';
  static const String paymentConfirmation = '/payment-confirmation';

  static List<GetPage> routes = [
    GetPage(
      name: home,
      page: () => const HomeDashboard(),
    ),
    GetPage(
      name: searchResults,
      page: () => const DomainSearchResults(),
    ),
    GetPage(
      name: domainDetails,
      page: () => const DomainDetails(),
    ),
    GetPage(
      name: cart,
      page: () => const CartCheckout(),
    ),
    GetPage(
      name: paymentConfirmation,
      page: () => const PaymentConfirmation(),
    ),
  ];
}