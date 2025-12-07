import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

extension UIHelperExtension on BuildContext {
  void showNotification(String message, {bool isError = false}) {
    showTopSnackBar(
        Overlay.of(this),
        displayDuration: const Duration(seconds: 2),
        isError
            ? CustomSnackBar.error(message: message)
            : CustomSnackBar.success(message: message));
  }

  double screenWidth() => MediaQuery.sizeOf(this).width;
  double screenHeight() => MediaQuery.sizeOf(this).height;
}
