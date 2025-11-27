import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobsit_mobile/features/auth/presentation/cubit/candidate_cubit.dart';
import 'package:jobsit_mobile/features/auth/presentation/cubit/candidate_state.dart';
import 'package:jobsit_mobile/features/auth/presentation/screens/reset_password.dart';
import 'package:jobsit_mobile/core/constants/color_constants.dart';
import 'package:jobsit_mobile/core/constants/text_constants.dart';
import 'package:jobsit_mobile/core/constants/validate_constants.dart';
import 'package:jobsit_mobile/core/constants/value_constants.dart';
import 'package:jobsit_mobile/core/constants/widget_constants.dart';
import 'package:jobsit_mobile/shared/widgets/input_field_async.dart';
import 'package:http/http.dart' as http;

import '../../../../core/services/base_services.dart';
import '../../../../core/services/candidate_services.dart';

class ChangePasswordByOtpScreen extends StatefulWidget {
  final String email;

  const ChangePasswordByOtpScreen({super.key, required this.email});

  @override
  State<ChangePasswordByOtpScreen> createState() => _ActiveAccountScreenState();
}

class _ActiveAccountScreenState extends State<ChangePasswordByOtpScreen> {
  late final CandidateCubit _cubit;
  //late final String _email;
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  //String otp = '';
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cubit = context.read<CandidateCubit>();
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
              TextConstants.verifyEmail,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 24),
            ),
            SizedBox(height: ValueConstants.deviceHeightValue(uiValue: 8)),
            const Text(
              TextConstants.pleaseInputOTPInEmail,
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
                  InputFieldAsync(
                      controller: _otpController,
                      keyboardType: TextInputType.number,
                      validateMethod: ValidateConstants.validateOtp),
                  // SizedBox(height: ValueConstants.deviceHeightValue(uiValue: 12)),
                  //
                  // // New Password Input
                  // TextFormField(
                  //   controller: _newPasswordController,
                  //   obscureText: true,
                  //   decoration: InputDecoration(
                  //     labelText: "New Password",
                  //     border: OutlineInputBorder(),
                  //   ),
                  //   validator: ValidateConstants.validatePasswordRegister,
                  // ),
                  // SizedBox(height: ValueConstants.deviceHeightValue(uiValue: 12)),
                  //
                  // // Confirm New Password Input
                  // TextFormField(
                  //   controller: _confirmNewPasswordController,
                  //   obscureText: true,
                  //   decoration: InputDecoration(
                  //     labelText: "Confirm New Password",
                  //     border: OutlineInputBorder(),
                  //   ),
                  //   validator: (value) {
                  //     if (value == null || value.isEmpty) {
                  //       return "Please confirm your password";
                  //     }
                  //     if (value != _newPasswordController.text) {
                  //       return "Passwords do not match";
                  //     }
                  //     return null;
                  //   },
                  // ),
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
                        TextConstants.VERIFY_EMAIL,
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
                      builder: (context) => const ResetPasswordScreen(),
                      settings: RouteSettings(arguments: _otpController.text),
                    ),
                  );
                }
              } else if (state is AuthErrorState) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.errMessage)));
              }
            }),
            SizedBox(height: ValueConstants.deviceHeightValue(uiValue: 16)),
            GestureDetector(
              onTap: sendOtpForgotPasswordAgain,
              child: const Text.rich(TextSpan(
                  text: TextConstants.dontReceiveOTP,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.w400),
                  children: [
                    TextSpan(
                        text: TextConstants.sendOTPAgain,
                        style: TextStyle(
                            color: ColorConstants.main,
                            fontSize: 13,
                            fontWeight: FontWeight.w400))
                  ])),
            )
          ],
        ),
      )),
    );
  }

  // Future<void> changePasswordByOtp() async {
  //   final error = await ValidateConstants.validateOtp(_otpController.text);
  //   if (((_formKey.currentState as FormState).validate()) && (error == null)) {
  //    final otp = await _cubit.verifyOtp(_otpController.text);
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => const ResetPasswordScreen(),
  //         settings: RouteSettings(arguments: otp?['message']),
  //       ),
  //     );
  //   }
  // }
  Future<void> changePasswordByOtp() async {
    // Kiểm tra OTP hợp lệ (chỉ kiểm tra định dạng)
    final error = await ValidateConstants.validateOtp(_otpController.text);
    if (!_formKey.currentState!.validate() || error != null) {
      return;
    }

    // Khi OTP hợp lệ, ta mới gọi API
    final uri = Uri.parse("${CandidateServices.sendVerifyOtp}${_otpController.text}");
    final body = {
      "otp": _otpController.text,
      "newPassword": "Verifyotp1A",
      "confirmPassword": "Verifyotp1A"
    };

    try {
      final response = await http.post(uri, body: jsonEncode(body), headers: BaseServices.headers);
      final data = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 200 && data['message'] != null) {
        final String encryptedOtp = data['message']; // OTP mới đã mã hóa

        // Chuyển sang màn hình reset password
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ResetPasswordScreen(),
            settings: RouteSettings(arguments: encryptedOtp),
          ),
        );
      } else if (response.statusCode == 400) {
        // Nếu OTP sai -> Hiển thị lỗi
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(TextConstants.otpError)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Lỗi không xác định, vui lòng thử lại!")),
        );
      }
    } catch (e) {
      debugPrint('❌ Lỗi khi gọi API verify OTP: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lỗi kết nối, vui lòng thử lại!")),
      );
    }
  }

  Future<void> sendOtpForgotPasswordAgain() async {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text(TextConstants.sentOtpMess)));
    await _cubit.sendEmailForgotPassWord(widget.email);
  }
}
