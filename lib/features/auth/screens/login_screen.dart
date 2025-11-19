import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jobsit_mobile/core/constants/asset_constants.dart';
import 'package:jobsit_mobile/data/datasources/auth_storage.dart';
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
  final _authStorage = AuthStorage();
  bool _rememberMe = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  ThemeData get _theme => Theme.of(context);

  @override
  void initState() {
    super.initState();
    _cubit = context.read<CandidateCubit>();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    final credentials = await _authStorage.getCredentials();
    if (credentials['email'] != null) {
      setState(() {
        _emailController.text = credentials['email']!;
        _passwordController.text = credentials['password'] ?? '';
        _rememberMe = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          margin: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: ValueConstants.deviceHeightValue(uiValue: 150),
                ),
                Image.asset(
                  color: ColorConstants.main,
                  AssetConstants.logoHome,
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
                              value: _rememberMe,
                              onChanged: (value) {
                                setState(() {
                                  _rememberMe = value!;
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
                        Text(
                          'screen.login.forgot_password'.tr(),
                          style: _theme.textTheme.displaySmall,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    BlocConsumer<CandidateCubit, CandidateState>(
                        builder: (context, state) {
                      if (state is AuthLoadingState) {
                        return WidgetConstants.circularProgress;
                      }

                      return GestureDetector(
                          onTap: () async => await _handleLogin(),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            alignment: Alignment.center,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: _theme.primaryColor,
                                borderRadius: BorderRadius.circular(12)),
                            child: Text(
                              'screen.login.title'.tr(),
                              style: _theme.textTheme.displaySmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ));
                    }, listener: (context, state) {
                      if (state is AuthLoginSuccessState) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(TextConstants.loginSuccessful)));

                        Navigator.pop(context);
                      } else if (state is AuthErrorState) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                ConvertConstants.getMessageFromException(
                                    state.errMessage))));
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
                          child: SvgPicture.asset(AssetConstants.iconGgLogin),
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
                          child: SvgPicture.asset(AssetConstants.iconFbLogin),
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
                          onTap: _navigateRegisterScreen,
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

  Future<void> _handleLogin() async {
    if ((_formKey.currentState as FormState).validate()) {
      await _cubit.loginAccount(
          email: _emailController.text, password: _passwordController.text);
    }
  }

  void _navigateRegisterScreen() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const RegisterScreen()));
  }
}
