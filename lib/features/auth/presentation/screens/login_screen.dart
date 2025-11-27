import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:jobsit_mobile/app/router.dart';
import 'package:jobsit_mobile/core/constants/asset_constants.dart';
import 'package:jobsit_mobile/core/utils/logger/app_logger.dart';
import 'package:jobsit_mobile/data/datasources/auth_storage.dart';
import 'package:jobsit_mobile/features/auth/presentation/cubit/candidate_cubit.dart';
import 'package:jobsit_mobile/features/auth/presentation/cubit/candidate_state.dart';
import 'package:jobsit_mobile/core/constants/color_constants.dart';
import 'package:jobsit_mobile/core/constants/validate_constants.dart';
import 'package:jobsit_mobile/core/constants/value_constants.dart';
import 'package:jobsit_mobile/core/constants/widget_constants.dart';
import 'package:jobsit_mobile/shared/extensions/context_exts.dart';
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

    AppLogger.i('_loadSavedCredentials() ----- credentials: $credentials');

    if (credentials['email'] != null && credentials['password'] != null) {
      setState(() {
        _emailController.text = credentials['email']!;
        _passwordController.text = credentials['password']!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                            label: 'screen.login.email'.tr(),
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            validateMethod:
                                ValidateConstants.validateEmailLogin),
                        const SizedBox(
                          height: 20,
                        ),
                        InputField(
                          label: 'screen.login.password'.tr(),
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
                Center(
                  child: Text(
                    'screen.login.forgot_password'.tr(),
                    style: _theme.textTheme.displaySmall,
                  ),
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
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ));
                }, listener: (context, state) {
                  if (state is AuthLoginSuccessState) {
                    context.showNotification(
                        'notification.login.login_successful'.tr());

                    context.pop();
                  } else if (state is AuthErrorState) {
                    context.showNotification(state.errMessage, isError: true);
                  }
                }),
                SizedBox(
                  height: ValueConstants.deviceHeightValue(uiValue: 20),
                ),
                Text(
                  'screen.login.or_login_by'.tr(),
                  style:
                      _theme.textTheme.labelSmall?.copyWith(color: Colors.grey),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: ColorConstants.btnLoginGoogle,
                          shape: BoxShape.circle,
                          border: Border.all(color: _theme.primaryColor)),
                      child: SvgPicture.asset(AssetConstants.iconGgLogin),
                    ),
                    const SizedBox(
                      width: 25,
                    ),
                    Container(
                      width: 60,
                      height: 60,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: ColorConstants.btnLoginFb,
                          shape: BoxShape.circle,
                          border: Border.all(color: _theme.primaryColor)),
                      child: SvgPicture.asset(AssetConstants.iconFbLogin),
                    )
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('screen.login.dont_have_account'.tr(),
                        style: _theme.textTheme.labelLarge?.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.normal)),
                    const SizedBox(
                      width: 8,
                    ),
                    GestureDetector(
                      onTap: _navigateRegisterScreen,
                      child: Text(
                        'screen.register.title'.tr(),
                        style: _theme.textTheme.labelLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
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
      await _cubit.login(
          email: _emailController.text, password: _passwordController.text);
    }
  }

  void _navigateRegisterScreen() {
    context.pushNamed(AppRouter.registerName);
  }
}
