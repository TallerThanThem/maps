import 'package:flutter/material.dart';

class TextFormWidget extends StatelessWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String? hintText;
  final Widget? prefixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;

  TextFormWidget(
      { this.validator,
        this.controller,
        @required this.hintText,
        @required this.prefixIcon,
        required this.obscureText,
        this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
    );
  }
}