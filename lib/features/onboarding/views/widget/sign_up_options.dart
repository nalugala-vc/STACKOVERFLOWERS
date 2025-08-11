import 'package:flutter/material.dart';
import 'package:kenic/core/utils/fonts/inter.dart';
import 'package:kenic/core/utils/spacers/spacers.dart';
import 'package:kenic/core/utils/theme/app_pallete.dart';

class SignUpOptions extends StatelessWidget {
  final String text;
  const SignUpOptions({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 100.0,
          child: Divider(thickness: 1.0, color: AppPallete.greyColor),
        ),
        spaceW10,
        Inter(
          text: text,
          fontSize: 16,
          fontWeight: FontWeight.normal,
          textColor: AppPallete.greyColor,
        ),
        spaceW10,
        SizedBox(
          width: 100.0,
          child: Divider(thickness: 1.0, color: AppPallete.greyColor),
        ),
      ],
    );
  }
}
