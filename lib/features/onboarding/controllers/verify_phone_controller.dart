import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kenic/core/controller/base_controller.dart';

class VerifyPhoneController extends BaseController {
  static VerifyPhoneController get instance => Get.find();

  final phone = TextEditingController();

  @override
  void onClose() {
    phone.dispose();
    super.onClose();
  }

  final errorMessage = ''.obs;

  String? validatePhone(String phone) {
    if (phone.isEmpty) {
      return 'Phone number is required';
    }
    if (phone.length < 10) {
      return 'Phone number must be at least 10 digits';
    }
    return null;
  }
}
