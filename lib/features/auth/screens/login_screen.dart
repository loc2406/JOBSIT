import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jobsit_mobile/features/auth/cubit/candidate_cubit.dart';
import 'package:jobsit_mobile/features/auth/cubit/candidate_state.dart';
import 'package:jobsit_mobile/features/auth/screens/register_screen.dart';
import 'package:jobsit_mobile/core/constants/color_constants.dart';
import 'package:jobsit_mobile/core/constants/convert_constants.dart';
import 'package:jobsit_mobile/core/constants/text_constants.dart';
import 'package:jobsit_mobile/core/constants/validate_constants.dart';
import 'package:jobsit_mobile/core/constants/value_constants.dart';
import 'package:jobsit_mobile/core/utils/widget_constants.dart';
import 'package:jobsit_mobile/shared/widgets/input_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final CandidateCubit _cubit;
  final _formKey = GlobalKey<FormState>();
  bool _isShowPass = false;
  bool _isSaveLoginState = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cubit = context.read<CandidateCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: ValueConstants.deviceHeightValue(uiValue: 150),
                ),
                Image.asset(
                  color: ColorConstants.main,
                  TextConstants.logoLoginAsset,
                  width: ValueConstants.deviceWidthValue(uiValue: 100),
                ),
                SizedBox(
                  height: ValueConstants.deviceHeightValue(uiValue: 150),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InputField(
                                label: TextConstants.email,
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                validateMethod:
                                    ValidateConstants.validateEmailLogin),
                            SizedBox(
                              height:
                                  ValueConstants.deviceHeightValue(uiValue: 20),
                            ),
                            InputField(
                              label: TextConstants.password,
                              controller: _passwordController,
                              keyboardType: TextInputType.visiblePassword,
                              validateMethod:
                                  ValidateConstants.validatePasswordLogin,
                              suffixIcon: _isShowPass
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              suffixIconClicked: () {
                                setState(() {
                                  _isShowPass = !_isShowPass;
                                });
                              },
                              isObscure: _isShowPass ? false : true,
                            ),
                          ],
                        )),
                    SizedBox(
                      height: ValueConstants.deviceHeightValue(uiValue: 20),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: _isSaveLoginState,
                              onChanged: (value) {
                                setState(() {
                                  _isSaveLoginState = !_isSaveLoginState;
                                });
                              },
                              checkColor: Colors.white,
                              activeColor: ColorConstants.main,
                              side: const BorderSide(
                                  color: ColorConstants.main, width: 2),
                            ),
                            const Text(
                              TextConstants.saveLoginState,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400),
                            )
                          ],
                        ),
                        const Text(
                          TextConstants.forgotPassword,
                          style: TextStyle(
                              color: ColorConstants.main,
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              decorationColor: ColorConstants.main),
                        )
                      ],
                    ),
                    SizedBox(
                      height: ValueConstants.deviceHeightValue(uiValue: 30),
                    ),
                    BlocConsumer<CandidateCubit, CandidateState>(
                        builder: (context, state) {
                      if (state is AuthLoadingState) {
                        return WidgetConstants.circularProgress;
                      }

                      return SizedBox(
                          width: double.infinity,
                          child: TextButton(
                              style: const ButtonStyle(
                                  padding: WidgetStatePropertyAll(
                                      EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 32)),
                                  backgroundColor: WidgetStatePropertyAll(
                                      ColorConstants.main),
                                  shape: WidgetStatePropertyAll(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(16))))),
                              onPressed: handleLogin,
                              child: const Text(
                                TextConstants.login,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700),
                              )));
                    }, listener: (context, state) {
                      if (state is AuthLoginSuccessState) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(TextConstants.loginSuccessful)));

                        Navigator.pop(context);
                      } else if (state is AuthErrorState) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(ConvertConstants.getMessageFromException(state.errMessage))));
                      }
                    }),
                    SizedBox(
                      height: ValueConstants.deviceHeightValue(uiValue: 20),
                    ),
                    const Text(
                      TextConstants.orLoginWith,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: ColorConstants.grey,
                      ),
                    ),
                    SizedBox(
                      height: ValueConstants.deviceHeightValue(uiValue: 14),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: ValueConstants.deviceWidthValue(uiValue: 60),
                          height: ValueConstants.deviceHeightValue(uiValue: 60),
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              color: ColorConstants.btnLoginGoogle,
                              borderRadius: BorderRadius.circular(200),
                              border: const Border.fromBorderSide(
                                  BorderSide(color: ColorConstants.main))),
                          child:
                              SvgPicture.asset(TextConstants.iconGgLoginAsset),
                        ),
                        SizedBox(
                          width: ValueConstants.deviceHeightValue(uiValue: 26),
                        ),
                        Container(
                          width: ValueConstants.deviceWidthValue(uiValue: 60),
                          height: ValueConstants.deviceHeightValue(uiValue: 60),
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              color: ColorConstants.btnLoginFb,
                              borderRadius: BorderRadius.circular(200),
                              border: const Border.fromBorderSide(
                                  BorderSide(color: ColorConstants.main))),
                          child:
                              SvgPicture.asset(TextConstants.iconFbLoginAsset),
                        )
                      ],
                    ),
                    SizedBox(
                      height: ValueConstants.deviceHeightValue(uiValue: 30),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(TextConstants.dontHaveAccount,
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Colors.black)),
                        SizedBox(
                          width: ValueConstants.deviceHeightValue(uiValue: 8),
                        ),
                        GestureDetector(
                          onTap: navigateRegisterScreen,
                          child: const Text(
                            TextConstants.register,
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: ColorConstants.main),
                          ),
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }

  Future<void> handleLogin() async {
    if ((_formKey.currentState as FormState).validate()) {
      await _cubit.loginAccount(
          email: _emailController.text, password: _passwordController.text);
    }
  }

  void navigateRegisterScreen() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const RegisterScreen()));
  }
}
