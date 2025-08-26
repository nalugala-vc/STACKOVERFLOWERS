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
                    // Verify OTP
                    Get.offAllNamed('/signin');
                  },
                ),
                spaceH40,
                RoundedButton(
                  onPressed: () {
                    // Verify OTP
                    Get.offAllNamed('/signin');
                  },
                  label: 'Verify OTP',
                  fontsize: 18,
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
                      onTap: () {
                        // Resend code
                      },
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
    );
  }
}
