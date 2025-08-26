import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kenic/core/utils/fonts/inter.dart';
import 'package:kenic/core/utils/spacers/spacers.dart';
import 'package:kenic/core/utils/widgets/auth_field.dart';
import 'package:kenic/core/utils/widgets/rounded_button.dart';
import 'package:kenic/core/utils/theme/app_pallete.dart';
import 'package:kenic/features/onboarding/controllers/onboarding_controller.dart';
import 'package:country_code_picker/country_code_picker.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final controller = Get.put(OnboardingController());

  final _formKey = GlobalKey<FormState>();
  CountryCode? _selectedCountryCode = CountryCode(
    code: 'US',
    dialCode: '+1',
    name: 'United States',
  );

  // Method to get full phone number with country code
  String getFullPhoneNumber() {
    final phoneNumber = controller.phone.text.trim();
    if (phoneNumber.isNotEmpty && _selectedCountryCode != null) {
      return '${_selectedCountryCode!.dialCode}$phoneNumber';
    }
    return phoneNumber;
  }

  // Method to handle signup process
  Future<void> _handleSignup() async {
    if (_formKey.currentState!.validate()) {
      final result = await controller.createUser(
        name: controller.name.text.trim(),
        email: controller.email.text.trim(),
        phoneNumber: getFullPhoneNumber(),
        password: controller.password.text,
      );

      if (result.isRight()) {
        // After successful registration, send verification code
        final verificationResult = await controller.sendVerification();

        if (verificationResult.isRight()) {
          // Redirect to OTP verification page
          Get.offAllNamed('/verify-otp');
        } else {
          verificationResult.fold(
            (failure) => Get.snackbar(
              'Verification Error',
              failure.message,
              snackPosition: SnackPosition.BOTTOM,
            ),
            (message) => null,
          );
        }
      } else {
        result.fold(
          (failure) => Get.snackbar(
            'Error',
            failure.message,
            snackPosition: SnackPosition.BOTTOM,
          ),
          (user) => null,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  Inter(text: 'Create Account', fontSize: 25),
                  spaceH5,
                  Inter(
                    text: 'Fill in your details to get started',
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  ),
                  spaceH50,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Inter(
                        text: 'Full Name',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      spaceH10,
                      AuthField(
                        controller: controller.name,
                        hintText: '',
                        validator:
                            (value) => controller.validateName(value ?? ''),
                      ),
                    ],
                  ),
                  spaceH20,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Inter(
                        text: 'Email',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      spaceH10,
                      AuthField(
                        controller: controller.email,
                        hintText: '',
                        validator:
                            (value) => controller.validateEmail(value ?? ''),
                      ),
                    ],
                  ),
                  spaceH20,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Inter(
                        text: 'Phone Number',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      spaceH10,
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                color: AppPallete.kenicGrey,
                              ),
                              child: CountryCodePicker(
                                onChanged: (CountryCode countryCode) {
                                  setState(() {
                                    _selectedCountryCode = countryCode;
                                  });
                                },
                                initialSelection: 'US',
                                favorite: ['+1', '+44', '+91'],
                                showCountryOnly: false,
                                showOnlyCountryWhenClosed: false,
                                alignLeft: false,
                                textStyle: const TextStyle(fontSize: 16),
                                backgroundColor: AppPallete.kenicGrey,

                                searchDecoration: InputDecoration(
                                  hintText: "Search country",
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: controller.phone,
                                decoration: InputDecoration(
                                  hintText: '',
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 16,
                                  ),
                                  filled: true,
                                  fillColor: AppPallete.kenicGrey,
                                ),
                                keyboardType: TextInputType.phone,
                                validator:
                                    (value) =>
                                        controller.validatePhone(value ?? ''),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  spaceH20,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Inter(
                        text: 'Password',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      spaceH10,
                      AuthField(
                        controller: controller.password,
                        isObscureText: true,
                        hintText: '',
                        validator:
                            (value) => controller.validatePassword(value ?? ''),
                      ),
                    ],
                  ),
                  spaceH20,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Inter(
                        text: 'Confirm Password',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      spaceH10,
                      AuthField(
                        controller: controller.confirmPassword,
                        isObscureText: true,
                        hintText: '',
                        validator:
                            (value) => controller.validateConfirmPassword(
                              controller.password.text,
                              value ?? '',
                            ),
                      ),
                    ],
                  ),
                  spaceH40,
                  Obx(
                    () => RoundedButton(
                      onPressed:
                          controller.isLoading.value ? () {} : _handleSignup,
                      label:
                          controller.isLoading.value
                              ? 'Processing...'
                              : 'Sign Up',
                      fontsize: 18,
                    ),
                  ),

                  spaceH50,

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Inter(
                        text: "Already have an account? ",
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                      GestureDetector(
                        onTap: () => Get.toNamed('/signin'),
                        child: Inter(
                          text: 'Sign In',
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
}
