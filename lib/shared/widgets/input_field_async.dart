import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jobsit_mobile/core/constants/color_constants.dart';
import 'package:jobsit_mobile/core/constants/widget_constants.dart';

class InputFieldAsync extends StatefulWidget {
  final String? label;
  final IconData? suffixIcon;
  final void Function()? suffixIconClicked;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool isObscure;
  final Future<String?> Function(String?)? validateMethod; // ✅ Đổi thành Future<String?>

  const InputFieldAsync({
    super.key,
    this.label,
    required this.controller,
    required this.keyboardType,
    required this.validateMethod,
    this.isObscure = false,
    this.suffixIcon,
    this.suffixIconClicked,
  });

  @override
  State<InputFieldAsync> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputFieldAsync> {
  String? errorText;
  Timer? _debounce;

  void _onChanged(String value) {
    if (widget.validateMethod == null) return;

    // Hủy bỏ debounce trước đó (nếu có)
    _debounce?.cancel();

    // Tạo một debounce mới (0.5s)
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      final error = await widget.validateMethod!(value);
      if (mounted) {
        setState(() {
          errorText = error;
        });
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        hintText: widget.label,
        hintStyle: const TextStyle(color: Colors.grey),
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        suffixIcon: widget.suffixIcon != null
            ? GestureDetector(
          onTap: widget.suffixIconClicked,
          child: Icon(widget.suffixIcon, color: ColorConstants.main),
        )
            : null,
        enabledBorder: WidgetConstants.inputFieldBorder,
        focusedBorder: WidgetConstants.inputFieldBorder,
        errorStyle: const TextStyle(
            color: Colors.grey, fontSize: 13, fontStyle: FontStyle.italic),
        errorText: errorText, // ✅ Hiển thị lỗi từ validate async
        errorBorder: WidgetConstants.inputFieldBorder,
        focusedErrorBorder: WidgetConstants.inputFieldBorder,
      ),
      onChanged: _onChanged, // ✅ Gọi validate mỗi khi nhập
      keyboardType: widget.keyboardType,
      obscureText: widget.isObscure,
    );
  }
}
