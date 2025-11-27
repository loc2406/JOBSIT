import 'package:flutter/material.dart';
import 'package:jobsit_mobile/features/auth/presentation/screens/active_account_screen.dart';
import 'package:jobsit_mobile/features/auth/presentation/screens/login_screen.dart';
import 'package:jobsit_mobile/features/auth/presentation/screens/register_screen.dart';
import 'package:jobsit_mobile/core/constants/color_constants.dart';
import 'package:jobsit_mobile/core/constants/text_constants.dart';

import 'core/constants/value_constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
                child: Image.asset(
                  color: ColorConstants.main,
              TextConstants.splashLogoAsset,
              width: ValueConstants.deviceWidthValue(uiValue: 351),
            )),
            const Text(
              TextConstants.splashTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: ColorConstants.main,
                  fontSize: 24,
                  fontWeight: FontWeight.w700),
            ),
            SizedBox(height: ValueConstants.deviceHeightValue(uiValue: 40)),
            const Text(
              textAlign: TextAlign.center,
              TextConstants.splashContent,
              style: TextStyle(
                  color: ColorConstants.main,
                  fontSize: 18,
                  fontWeight: FontWeight.w400),
            ),
            SizedBox(
              height: ValueConstants.deviceHeightValue(uiValue: 40),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: navigateLoginScreen,
                    child: Container(
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                          color: ColorConstants.main,
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          border: Border.fromBorderSide(
                              BorderSide(color: ColorConstants.main))),
                      padding: EdgeInsets.symmetric(
                          vertical:
                              ValueConstants.deviceHeightValue(uiValue: 16)),
                      child: const Text(
                        TextConstants.login,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: ValueConstants.deviceWidthValue(uiValue: 20),
                ),
                Expanded(
                    child: GestureDetector(
                  onTap: navigateRegisterScreen,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        border: Border.fromBorderSide(
                            BorderSide(color: ColorConstants.main))),
                    padding: EdgeInsets.symmetric(
                        vertical:
                            ValueConstants.deviceHeightValue(uiValue: 16)),
                    child: const Text(
                      TextConstants.register,
                      style: TextStyle(
                          color: ColorConstants.main,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                )),
              ],
            )
          ],
        ),
      ),
    );
  }

  void navigateLoginScreen() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  void navigateRegisterScreen() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const RegisterScreen()));
  }
}
