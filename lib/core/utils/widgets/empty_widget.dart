import 'package:flutter/material.dart';
import 'package:kenic/core/utils/fonts/inter.dart';
import 'package:kenic/core/utils/spacers/spacers.dart';
import 'package:kenic/core/utils/theme/app_pallete.dart';

class EmptyWidget extends StatelessWidget {
  final String title;
  final String description;
  const EmptyWidget({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 150,
          width: 150,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/empty-box.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        spaceH10,
        Inter(
          text: title,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          textColor: AppPallete.kenicBlack,
        ),

        Inter(
          text: description,
          fontSize: 16,
          fontWeight: FontWeight.normal,
          textColor: AppPallete.greyColor,
          textAlignment: TextAlign.center,
        ),
      ],
    );
  }
}
