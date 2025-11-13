import 'package:flutter/material.dart';
import 'package:jobsit_mobile/core/constants/text_constants.dart';
import 'package:jobsit_mobile/core/constants/value_constants.dart';

import '../constants/color_constants.dart';

class WidgetConstants {
  static const inputFieldBorder = OutlineInputBorder(borderSide: BorderSide(color: ColorConstants.main), borderRadius: BorderRadius.all(Radius.circular(10)));
  static const circularProgress = CircularProgressIndicator(color: ColorConstants.main,);
  static const searchBorder = OutlineInputBorder(borderSide: BorderSide(color: ColorConstants.main), borderRadius: BorderRadius.all(Radius.circular(10)));

  // Text style - Normal
  static const main11Style = TextStyle(color: ColorConstants.main, fontSize: 11, fontWeight: FontWeight.w500);
  static const main12Style = TextStyle(color: ColorConstants.main, fontSize: 12, fontWeight: FontWeight.w500);
  static const main13Style = TextStyle(color: ColorConstants.main, fontSize: 13, fontWeight: FontWeight.w500);
  static const main22Style = TextStyle(color: ColorConstants.main, fontSize: 22, fontWeight: FontWeight.w500);
  static const black12Style = TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w500);
  static const black11Style = TextStyle(color: Colors.black, fontSize: 11, fontWeight: FontWeight.w500);
  static const black14Style = TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500);
  static const black16Style = TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500);
  static const white12Style = TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500);
  static const grey12Style = TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w500);

  // Text style - Bold
  static const mainBold16Style = TextStyle(color: ColorConstants.main, fontSize: 16, fontWeight: FontWeight.w700);
  static const blackBold16Style = TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w700);
  static const whiteBold16Style = TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700);
  static const blackBold12Style = TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w700);

  // Text style - Italic
  static const redItalic16Style = TextStyle(color: Colors.red, fontSize: 13, fontStyle: FontStyle.italic);

  static const userNameStyle = TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.w500);
  static const inputFieldErrStyle = TextStyle(
      color: Colors.red, fontSize: 13, fontStyle: FontStyle.italic);

  static Widget buildDefaultCandidateAvatar() {
    return Icon(Icons.image_outlined,
        color: ColorConstants.main, size: ValueConstants.screenWidth * 0.1);
  }

  static showSnackBar({required BuildContext context, required String message, int durationSeconds = 3}){
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    scaffoldMessenger.showSnackBar(
        SnackBar(content: Text(message), duration: Duration(seconds: durationSeconds),));
  }
}
