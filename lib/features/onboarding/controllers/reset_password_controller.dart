import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kenic/core/controller/base_controller.dart';

class ResetPasswordController extends BaseController {
  static ResetPasswordController get instance => Get.find();

  final newPassword = TextEditingController();
  final confirmPassword = TextEditingController();

  @override
  void onClose() {
    newPassword.dispose();
    confirmPassword.dispose();
    super.onClose();
  }

  final errorMessage = ''.obs;

  String? validateNewPassword(String password) {
    if (password.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    if (!RegExp(r'(?=.*?[#?!@$%^&*-])').hasMatch(password)) {
      return 'Password must contain at least one special character';
    }
    if (!RegExp(r'(?=.*?[0-9])').hasMatch(password)) {
      return 'Password must contain at least one number';
    }
    return null;
  }

  String? validateConfirmPassword(String password, String confirmPassword) {
    if (password != confirmPassword) {
      return 'Passwords do not match';
    }
    return null;
  }
}
