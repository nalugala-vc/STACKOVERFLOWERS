import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kenic/core/controller/base_controller.dart';

class ForgotPasswordController extends BaseController {
  static ForgotPasswordController get instance => Get.find();

  final email = TextEditingController();

  @override
  void onClose() {
    email.dispose();
    super.onClose();
  }

  final errorMessage = ''.obs;

  String? validateEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (email.isEmpty) {
      return 'Email is required';
    }
    if (!emailRegex.hasMatch(email)) {
      return 'Enter a valid email address';
    }
    return null;
  }
}
