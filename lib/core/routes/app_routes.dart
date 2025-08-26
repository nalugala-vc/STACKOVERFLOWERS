import 'package:get/get.dart';
import 'package:kenic/features/onboarding/routes/onboarding_routes.dart';
import 'package:kenic/features/domain_core/routes/domain_routes.dart';

class AppRoutes {
  static List<GetPage> routes = [
    ...OnboardingRoutes.routes,
    ...DomainRoutes.routes,
  ];
}
