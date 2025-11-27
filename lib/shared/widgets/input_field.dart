import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jobsit_mobile/core/constants/color_constants.dart';
import 'package:jobsit_mobile/core/constants/widget_constants.dart';

class InputField extends StatelessWidget {
  final String? label;
  final IconData? suffixIcon;
  final void Function()? suffixIconClicked;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool isObscure;
  final String? Function(String?) validateMethod;

  const InputField(
      {super.key,
      this.label,
      required this.controller,
      required this.keyboardType,
      required this.validateMethod,
      this.isObscure = false,
      this.suffixIcon,
      this.suffixIconClicked});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: label,
        hintStyle: const TextStyle(color: Colors.grey),
        suffixIconConstraints: const BoxConstraints(
          minWidth: 40,
          minHeight: 20,
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        suffixIcon: suffixIcon != null
            ? GestureDetector(
                onTap: suffixIconClicked,
                child: Icon(
                  suffixIcon,
                  color: ColorConstants.main,
                  size: 20,
                ),
              )
            : null,
        enabledBorder: theme.inputDecorationTheme.enabledBorder,
        focusedBorder: theme.inputDecorationTheme.focusedBorder,
        errorStyle: const TextStyle(
            color: Colors.red, fontSize: 13, fontStyle: FontStyle.italic),
        errorBorder: theme.inputDecorationTheme.border,
        focusedErrorBorder: theme.inputDecorationTheme.border,
      ),
      validator: validateMethod,
      keyboardType: keyboardType,
      obscureText: isObscure,
    );
  }
}
