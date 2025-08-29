import 'package:get/get.dart';
import 'package:kenic/core/middleware/auth_middleware.dart';
import 'package:kenic/features/onboarding/views/signin.dart';
import 'package:kenic/features/onboarding/views/signup.dart';
import 'package:kenic/features/onboarding/views/forgot_password.dart';
import 'package:kenic/features/domain_core/views/home_dashboard.dart';
import 'package:kenic/features/domain_core/views/domain_search_results.dart';
import 'package:kenic/features/domain_core/views/domain_details.dart';
import 'package:kenic/features/domain_core/views/cart_checkout.dart';
import 'package:kenic/features/domain_core/views/checkout_page.dart';
import 'package:kenic/features/domain_core/views/payment_confirmation.dart';
import 'package:kenic/features/navigation/views/main_navigation.dart';
import 'package:kenic/features/orders/views/orders_page.dart';
import 'package:kenic/features/profile/views/profile_page.dart';
import 'package:kenic/features/profile/views/personal_information_page.dart';
import 'package:kenic/features/profile/views/contact_info_page.dart';
import 'package:kenic/features/profile/views/help_center_page.dart';
import 'package:kenic/features/profile/routes/profile_routes.dart';
import 'package:kenic/features/onboarding/routes/onboarding_routes.dart';
import 'package:kenic/features/onboarding/views/change_password.dart';
import 'package:kenic/features/onboarding/views/verify_otp.dart';
import 'package:kenic/features/onboarding/views/verify_phone.dart';
import 'package:kenic/features/onboarding/views/verify_email.dart';
import 'package:kenic/features/onboarding/views/reset_password.dart';

class AppRoutes {
  static final authMiddleware = AuthMiddleware();

  static List<GetPage> routes = [
    // Public routes (no middleware)
    GetPage(
      name: '/signin',
      page: () => const Signin(),
      middlewares: [authMiddleware],
    ),
    GetPage(
      name: '/signup',
      page: () => const Signup(),
      middlewares: [authMiddleware],
    ),
    GetPage(
      name: '/forgot-password',
      page: () => const ForgotPassword(),
      middlewares: [authMiddleware],
    ),

    // Protected routes (with middleware)
    GetPage(
      name: '/main',
      page: () => const MainNavigation(),
      middlewares: [authMiddleware],
    ),
    GetPage(
      name: '/home',
      page: () => const HomeDashboard(),
      middlewares: [authMiddleware],
    ),
    GetPage(
      name: '/orders',
      page: () => const OrdersPage(),
      middlewares: [authMiddleware],
    ),
    GetPage(
      name: '/profile',
      page: () => const ProfilePage(),
      middlewares: [authMiddleware],
    ),
    GetPage(
      name: ProfileRoutes.personalInformation,
      page: () => const PersonalInformationPage(),
      middlewares: [authMiddleware],
    ),
    GetPage(
      name: ProfileRoutes.contactInfo,
      page: () => const ContactInfoPage(),
      middlewares: [authMiddleware],
    ),
    GetPage(
      name: ProfileRoutes.helpCenter,
      page: () => const HelpCenterPage(),
      middlewares: [authMiddleware],
    ),
    GetPage(
      name: '/search-results',
      page: () => const DomainSearchResults(),
      middlewares: [authMiddleware],
    ),
    GetPage(
      name: '/domain-details',
      page: () => const DomainDetails(),
      middlewares: [authMiddleware],
    ),
    GetPage(
      name: '/cart',
      page: () => const CartCheckout(),
      middlewares: [authMiddleware],
    ),
    GetPage(
      name: '/checkout-page',
      page: () => const CheckoutPage(),
      middlewares: [authMiddleware],
    ),
    GetPage(
      name: '/payment-confirmation',
      page: () => const PaymentConfirmation(),
      middlewares: [authMiddleware],
    ),
    GetPage(
      name: OnboardingRoutes.changePassword,
      page: () => const ChangePasswordPage(),
      middlewares: [authMiddleware],
    ),
    GetPage(
      name: OnboardingRoutes.verifyOtp,
      page: () => const VerifyOtp(),
      middlewares: [authMiddleware],
    ),
    GetPage(
      name: OnboardingRoutes.verifyPhone,
      page: () => const VerifyPhone(),
      middlewares: [authMiddleware],
    ),
    GetPage(
      name: OnboardingRoutes.verifyEmail,
      page: () => const VerifyEmail(),
      middlewares: [authMiddleware],
    ),
    GetPage(
      name: OnboardingRoutes.resetPassword,
      page: () => const ResetPassword(),
      middlewares: [authMiddleware],
    ),
  ];
}
