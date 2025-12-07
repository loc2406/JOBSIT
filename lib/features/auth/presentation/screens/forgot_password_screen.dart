
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobsit_mobile/features/auth/presentation/screens/register_screen.dart';

import 'package:jobsit_mobile/core/constants/asset_constants.dart';
import 'package:jobsit_mobile/shared/widgets/input_field_async.dart';
import '../cubit/candidate_cubit.dart';

import '../../../../core/constants/text_constants.dart';
import '../../../../core/constants/validate_constants.dart';
import '../../../../shared/widgets/input_field.dart';
import 'change_password_by_otp_screen.dart';
import 'login_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  late final CandidateCubit _cubit;
  final _formKey = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cubit = context.read<CandidateCubit>();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        title: Row(
          children: [
            Image.asset(
              TextConstants.splashLogoAsset,
              height: 20,
            ),
            const Spacer(),
            Row(
              children: [
                Image.asset(AssetConstants.viFlag, width: 14),
                const Icon(Icons.arrow_drop_down, color: Colors.black),
              ],
            ),

            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RegisterScreen(),

                  ),
                );
              },
              child:
                  const Text(TextConstants.register, style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),

                  ),
                );
              },
              child: const Text(TextConstants.login,
                  style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
      body: Center(
        child: Container(
          width: screenWidth * 0.9,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 5,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
               const Text(
                TextConstants.forgotPassword,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                TextConstants.pleaseInputEmail,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 5),
              const Text(
                TextConstants.sendALinkToResetYourPassword,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 20),



              Form( key: _formKey,
                  child: InputFieldAsync(
                label: TextConstants.email,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validateMethod: (email) async => ValidateConstants.validateEmailRegister(email),
              )),

              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: handleBtnForgotPasswordClicked,
                  child: const Text(TextConstants.send,
                      style: TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),

                  ),
                );},
                child: const Text(
                  TextConstants.returnToSignIn,
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



  Future<void> handleBtnForgotPasswordClicked() async {
     // Nếu đang xử lý, không cho bấm tiếp
    final error = ValidateConstants.validateEmailRegister(_emailController.text);
    if (((_formKey.currentState as FormState).validate())
        && (error  == null)
    ) {
      await _cubit.sendEmailForgotPassWord(_emailController.text);


      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${TextConstants.passwordResetRequestSentToEmail} ${_emailController.text}"),

        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ChangePasswordByOtpScreen(
            email: _emailController.text,
          ),
        ),
      );
    }








  }
}
