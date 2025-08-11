import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isObscureText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  const AuthField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isObscureText = false,
    this.validator,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(hintText: hintText),
      obscureText: isObscureText,
      textCapitalization: TextCapitalization.none,
      keyboardType: keyboardType,
      validator:
          validator ??
          (value) {
            if (value!.isEmpty) {
              return '$hintText is missing';
            }
            return null;
          },
    );
  }
}
