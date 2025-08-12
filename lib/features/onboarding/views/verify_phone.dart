import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kenic/core/utils/fonts/inter.dart';
import 'package:kenic/core/utils/spacers/spacers.dart';
import 'package:kenic/core/utils/widgets/rounded_button.dart';
import 'package:kenic/core/utils/theme/app_pallete.dart';
import 'package:kenic/features/onboarding/controllers/verify_phone_controller.dart';
import 'package:country_code_picker/country_code_picker.dart';

class VerifyPhone extends StatefulWidget {
  const VerifyPhone({super.key});

  @override
  State<VerifyPhone> createState() => _VerifyPhoneState();
}

class _VerifyPhoneState extends State<VerifyPhone> {
  final controller = Get.put(VerifyPhoneController());
  CountryCode? _selectedCountryCode = CountryCode(
    code: 'US',
    dialCode: '+1',
    name: 'United States',
  );

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
                Inter(text: 'Verify Phone', fontSize: 25),
                spaceH5,
                Inter(
                  text: 'Enter your phone number to receive OTP',
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                ),
                spaceH50,
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
                                right: BorderSide(color: Colors.grey.shade300),
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
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                spaceH40,
                RoundedButton(
                  onPressed: () {
                    // Send OTP to phone
                    Get.toNamed('/verify-otp');
                  },
                  label: 'Send OTP',
                  fontsize: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
