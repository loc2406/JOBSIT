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
    {"id": 3, "name": "Remote"},
    {"id": 4, "name": "Hybrid"}
  ];

  static final positions = [
    {"id": 1, "name": "Front-end Developer"},
    {"id": 2, "name": "Back-end Developer"},
    {"id": 3, "name": "Full Stack Developer"},
    {"id": 4, "name": "Mobile Developer"},
    {"id": 5, "name": "Embedded Developer"},
    {"id": 6, "name": "QA Tester"},
    {"id": 7, "name": "DevOps Engineer"},
    {"id": 8, "name": "UI/UX Designer"},
    {"id": 9, "name": "Data Analyst"},
    {"id": 10, "name": "AI Engineer"},
    {"id": 11, "name": "Project Manager"},
    {"id": 12, "name": "Content Creator"},
    {"id": 13, "name": "Digital Marketer"},
    {"id": 14, "name": "Sales Executive"},
    {"id": 15, "name": "HR Generalist"},
    {"id": 16, "name": "Blockchain Developer"},
    {"id": 17, "name": "System Administrator"},
    {"id": 18, "name": "Business Analyst"},
    {"id": 19, "name": "Game Developer"},
    {"id": 20, "name": "Customer Support"},
    {"id": 21, "name": "Product Manager"},
    {"id": 22, "name": "Graphic Designer"},
    {"id": 23, "name": "Support Engineer (L2)"},
    {"id": 24, "name": "Cybersecurity Engineer"},
    {"id": 25, "name": "Technical Writer"},
    {"id": 26, "name": "Game Artist"},
    {"id": 27, "name": "Cloud Engineer"},
    {"id": 28, "name": "Technical Recruiter"},
    {"id": 29, "name": "AI Research Scientist"},
    {"id": 30, "name": "AR/VR Developer"},
    {"id": 31, "name": "IT Trainer"},
    {"id": 32, "name": "QA Automation Engineer"},
    {"id": 33, "name": "SEO Specialist"},
    {"id": 34, "name": "Embedded Software Engineer"},
    {"id": 35, "name": "Customer Success Manager"},
    {"id": 36, "name": "IT Support"},
    {"id": 37, "name": "Scrum Master"},
    {"id": 38, "name": "IT Compliance Officer"}
  ];

  static final majors = [
    {"id": 1, "name": "Computer Science"},
    {"id": 2, "name": "Software Engineering"},
    {"id": 3, "name": "Computer Engineering"},
    {"id": 4, "name": "Artificial Intelligence"},
    {"id": 5, "name": "Network Engineering"},
    {"id": 6, "name": "Information Systems Management"}
  ];
}