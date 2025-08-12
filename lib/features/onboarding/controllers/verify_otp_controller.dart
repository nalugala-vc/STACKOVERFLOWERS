import 'package:get/get.dart';
import 'package:kenic/core/controller/base_controller.dart';

class VerifyOtpController extends BaseController {
  static VerifyOtpController get instance => Get.find();

  String otp = '';

  final errorMessage = ''.obs;

  String? validateOtp(String otp) {
    if (otp.isEmpty) {
      return 'OTP is required';
    }
    if (otp.length != 6) {
      return 'OTP must be 6 digits';
    }
    return null;
  }
}
