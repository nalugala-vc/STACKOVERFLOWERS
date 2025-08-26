import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kenic/core/utils/fonts/inter.dart';
import 'package:kenic/core/utils/spacers/spacers.dart';
import 'package:kenic/core/utils/widgets/rounded_button.dart';
import 'package:kenic/core/utils/theme/app_pallete.dart';
import 'package:kenic/features/onboarding/controllers/onboarding_controller.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

class VerifyOtp extends StatefulWidget {
  const VerifyOtp({super.key});

  @override
  State<VerifyOtp> createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  final controller = Get.put(OnboardingController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppPallete.kenicBlack),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: SafeArea(
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 100,
                    width: 160,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/logo.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  spaceH40,
                  Inter(text: 'Verify OTP', fontSize: 25),
                  spaceH5,
                  Inter(
                    text: 'Enter the 6-digit code sent to your phone',
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  ),
                  spaceH50,
                  OtpTextField(
                    numberOfFields: 6,
                    borderColor: AppPallete.kenicGrey,
                    focusedBorderColor: AppPallete.kenicRed,
                    showFieldAsBox: true,
                    borderRadius: BorderRadius.circular(8),
                    fieldWidth: 45,
                    fieldHeight: 50,
                    keyboardType: TextInputType.number,
                    autoFocus: true,
                    onCodeChanged: (String code) {
                      controller.otp.text = code;
                    },
                    onSubmit: (String verificationCode) {
                      controller.otp.text = verificationCode;
                      _verifyOTP();
                    },
                  ),
                  spaceH40,
                  Obx(
                    () => RoundedButton(
                      onPressed:
                          controller.isLoading.value ? () {} : _verifyOTP,
                      label:
                          controller.isLoading.value
                              ? 'Verifying...'
                              : 'Verify OTP',
                      fontsize: 18,
                    ),
                  ),
                  spaceH30,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Inter(
                        text: "Didn't receive the code? ",
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                      GestureDetector(
                        onTap: _resendOTP,
                        child: Inter(
                          text: 'Resend',
                          fontSize: 14,
                          textColor: AppPallete.kenicRed,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _verifyOTP() async {
    if (controller.otp.text.length != 6) {
      Get.snackbar(
        'Error',
        'Please enter a valid 6-digit OTP',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final result = await controller.verifyOTP(code: controller.otp.text);

    if (result.isRight()) {
      Get.snackbar(
        'Success',
        'OTP verified successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[100],
        colorText: Colors.green[900],
      );
      // Redirect to signin page after successful verification
      Get.offAllNamed('/home');
    } else {
      result.fold(
        (failure) => Get.snackbar(
          'Error',
          failure.message,
          snackPosition: SnackPosition.BOTTOM,
        ),
        (message) => null,
      );
    }
  }

  void _resendOTP() async {
    final currentUser = controller.user;
    if (currentUser == null) {
      Get.snackbar(
        'Error',
        'User information not found. Please try signing up again.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final result = await controller.sendVerification();

    if (result.isRight()) {
      Get.snackbar(
        'Success',
        'OTP resent successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[100],
        colorText: Colors.green[900],
      );
    } else {
      result.fold(
        (failure) => Get.snackbar(
          'Error',
          failure.message,
          snackPosition: SnackPosition.BOTTOM,
        ),
        (message) => null,
      );
    }
  }
}
