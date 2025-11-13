import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobsit_mobile/features/auth/cubit/candidate_cubit.dart';
import 'package:jobsit_mobile/features/auth/cubit/candidate_state.dart';
import 'package:jobsit_mobile/features/auth/screens/login_screen.dart';
import 'package:jobsit_mobile/core/constants/color_constants.dart';
import 'package:jobsit_mobile/core/constants/text_constants.dart';
import 'package:jobsit_mobile/core/constants/validate_constants.dart';
import 'package:jobsit_mobile/core/constants/value_constants.dart';
import 'package:jobsit_mobile/core/utils/widget_constants.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  late final CandidateCubit _cubit;
  late final String _otp;
  final _formKey = GlobalKey<FormState>();

  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cubit = context.read<CandidateCubit>();

    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is String) {
      _otp = args;
    } else {
      _otp = ""; // Gán giá trị mặc định nếu args không phải là chuỗi
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.main,
      appBar: AppBar(
        backgroundColor: ColorConstants.main,
        leading: const SizedBox(),
      ),
      body: SizedBox.expand(
          child: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        padding: EdgeInsets.symmetric(
            vertical: ValueConstants.deviceHeightValue(uiValue: 18),
            horizontal: ValueConstants.deviceWidthValue(uiValue: 12)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              TextConstants.resetPassword,

              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 24),
            ),
            SizedBox(height: ValueConstants.deviceHeightValue(uiValue: 8)),
            const Text(
              TextConstants.inputNewPassword,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 13),
            ),
            SizedBox(height: ValueConstants.deviceHeightValue(uiValue: 8)),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                      height: ValueConstants.deviceHeightValue(uiValue: 12)),

                  // New Password Input
                  TextFormField(
                    controller: _newPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: TextConstants.newPassword,
                      border: OutlineInputBorder(),
                    ),
                    validator: ValidateConstants.validatePasswordRegister,
                  ),
                  SizedBox(
                      height: ValueConstants.deviceHeightValue(uiValue: 12)),

                  // Confirm New Password Input
                  TextFormField(
                    controller: _confirmNewPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: TextConstants.confirmNewPassword,
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return TextConstants.pleaseConfirmPassword;
                      }
                      if (value != _newPasswordController.text) {
                        return TextConstants.passwordsDoNotMatch;
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: ValueConstants.deviceHeightValue(uiValue: 16)),
            BlocConsumer<CandidateCubit, CandidateState>(
                builder: (context, state) {
              if (state is AuthLoadingState) {
                return WidgetConstants.circularProgress;
              }

              return SizedBox(
                  width: double.infinity,
                  child: TextButton(
                      style: const ButtonStyle(
                          padding: WidgetStatePropertyAll(EdgeInsets.symmetric(
                              vertical: 12, horizontal: 32)),
                          backgroundColor:
                              WidgetStatePropertyAll(ColorConstants.main),
                          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4))))),
                      onPressed: changePasswordByOtp,
                      child: const Text(
                        TextConstants.reset,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700),
                      )));
            }, listener: (context, state) {
              if (state is AuthActiveSuccessState) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text(TextConstants.changePasswordSuccessful)));

                if (mounted) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                }
              } else if (state is AuthErrorState) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.errMessage)));
              }
            }),
            SizedBox(height: ValueConstants.deviceHeightValue(uiValue: 16)),
            GestureDetector(
              onTap: navigateSignIn, // Gọi hàm điều hướng
              child: const Text(
                TextConstants.returnSignIn,
                style: TextStyle(
                  color: ColorConstants.main,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  // Thêm gạch chân cho rõ hơn
                  decorationColor: ColorConstants.main,
                ),
              ),
            )
          ],
        ),
      )),
    );
  }

  Future<void> changePasswordByOtp() async {
    if ((_formKey.currentState as FormState).validate()) {
      await _cubit.sendOtpToChangePassWord(_otp, _newPasswordController.text);
    }
  }

  void navigateSignIn() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }
}
