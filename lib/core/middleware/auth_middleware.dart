import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kenic/features/onboarding/controllers/onboarding_controller.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<OnboardingController>();

    // Public routes that don't require authentication
    final publicRoutes = ['/signin', '/signup', '/forgot-password'];

    // If it's a public route and user is logged in, redirect to home
    if (publicRoutes.contains(route) && authController.isLoggedIn.value) {
      return const RouteSettings(name: '/home');
    }

    // If it's not a public route and user is not logged in, redirect to signin
    if (!publicRoutes.contains(route) && !authController.isLoggedIn.value) {
      return const RouteSettings(name: '/signin');
    }

    return null;
  }
}
