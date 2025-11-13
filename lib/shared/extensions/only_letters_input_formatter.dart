import 'package:flutter/services.dart';

class OnlyLettersInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final RegExp regExp = RegExp(r"^[A-Za-zÀ-Ỹà-ỹ\s]*$");
    if (newValue.text.isEmpty || regExp.hasMatch(newValue.text)) {
      return newValue;
    }
    return oldValue;
  }
}
