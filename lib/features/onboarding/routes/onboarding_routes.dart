import 'package:get/get.dart';
import 'package:kenic/features/onboarding/views/signin.dart';
import 'package:kenic/features/onboarding/views/signup.dart';
import 'package:kenic/features/onboarding/views/forgot_password.dart';
import 'package:kenic/features/onboarding/views/reset_password.dart';
import 'package:kenic/features/onboarding/views/verify_email.dart';
import 'package:kenic/features/onboarding/views/verify_otp.dart';
import 'package:kenic/features/onboarding/views/verify_phone.dart';

class OnboardingRoutes {
  static const String signin = '/signin';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String verifyEmail = '/verify-email';
  static const String verifyOtp = '/verify-otp';
  static const String verifyPhone = '/verify-phone';

  static List<GetPage> routes = [
    GetPage(name: signin, page: () => const Signin()),
    GetPage(name: signup, page: () => const Signup()),
    GetPage(name: forgotPassword, page: () => const ForgotPassword()),
    GetPage(name: resetPassword, page: () => const ResetPassword()),
    GetPage(name: verifyEmail, page: () => const VerifyEmail()),
    GetPage(name: verifyOtp, page: () => const VerifyOtp()),
    GetPage(name: verifyPhone, page: () => const VerifyPhone()),
  ];
}
