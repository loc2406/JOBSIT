import 'package:flutter/cupertino.dart';

class ValueConstants {
  static double screenWidth = 0;
  static double screenHeight = 0;
  static double exchangeRateFromUSDToVND = 24.500;

  static void initScreenSize(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
  }

  static double deviceWidthValue(
      {required double uiValue, double uiScreen = 414}) {
    return screenWidth * (uiValue / uiScreen);
  }

  static double deviceHeightValue(
      {required double uiValue, double uiScreen = 896}) {
    return screenHeight * (uiValue / uiScreen);
  }

  static final schedules = [
    {"id": 1, "name": "Full time"},
    {"id": 2, "name": "Part time"},
    {"id": 3, "name": "Remote"}
  ];

  static final positions = [
    {"id": 1, "name": "Front-end Developer"},
    {"id": 2, "name": "Back-end Developer"},
    {"id": 3, "name": "Full Stack Developer"},
    {"id": 4, "name": "Mobile Developer"},
    {"id": 5, "name": "Embedded Developer"},
    {"id": 6, "name": "QA Tester"},
    {"id": 7, "name": "DevOps Engineer"}
  ];

  static final majors = [
    {"id": 1, "name": "Computer Science"},
    {"id": 2, "name": "Software Engineering"},
    {"id": 3, "name": "Computer Engineering"},
    {"id": 4, "name": "Artificial Intelligence"},
    {"id": 5, "name": "	Network Engineering"},
    {"id": 6, "name": "	Information Systems Management"}
  ];
}