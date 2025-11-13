import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jobsit_mobile/core/constants/color_constants.dart';
import 'package:jobsit_mobile/core/utils/widget_constants.dart';

class InputField extends StatelessWidget {
  final String? label;
  final IconData? suffixIcon;
  final void Function()? suffixIconClicked;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool isObscure;
  final String? Function(String?) validateMethod;

  const InputField({super.key,
    this.label,
    required this.controller,
    required this.keyboardType,
    required this.validateMethod,
    this.isObscure = false,
    this.suffixIcon,
    this.suffixIconClicked});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: label,
        hintStyle: const TextStyle(color: Colors.grey),
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        suffixIcon: suffixIcon != null ? GestureDetector(onTap: suffixIconClicked,child:  Icon(suffixIcon,
          color: ColorConstants.main,),) : null,
        enabledBorder: WidgetConstants.inputFieldBorder,
        focusedBorder: WidgetConstants.inputFieldBorder,
        errorStyle: const TextStyle(color: Colors.grey, fontSize: 13, fontStyle: FontStyle.italic),
        errorBorder: WidgetConstants.inputFieldBorder,
        focusedErrorBorder: WidgetConstants.inputFieldBorder,
      ),
      validator: validateMethod,
      keyboardType: keyboardType,
      obscureText: isObscure,
    );
  }
}
