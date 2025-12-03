import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:jobsit_mobile/core/constants/asset_constants.dart';
import 'package:jobsit_mobile/features/auth/presentation/cubit/candidate_cubit.dart';
import 'package:jobsit_mobile/features/auth/presentation/screens/active_account_screen.dart';
import 'package:jobsit_mobile/core/constants/convert_constants.dart';
import 'package:jobsit_mobile/shared/extensions/context_exts.dart';

import '../cubit/candidate_state.dart';
import '../../../../core/constants/color_constants.dart';
import '../../../../core/constants/text_constants.dart';
import '../../../../core/constants/validate_constants.dart';
import '../../../../core/constants/value_constants.dart';
import '../../../../core/constants/widget_constants.dart';
import '../../../../shared/widgets/input_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late final CandidateCubit _cubit;
  final _formKey = GlobalKey<FormState>();
  bool _isShowPass = false;
  bool _isShowConfirmPass = false;
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();

  ThemeData get _theme => Theme.of(context);

  @override
  void initState() {
    super.initState();
    _cubit = context.read<CandidateCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 50,
              ),
              Text('screen.register.create_new_account'.tr(),
                  style: _theme.textTheme.titleMedium),
              Column(
                children: [
                  Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 50,
                          ),
                          InputField(
                            label: 'screen.register.email'.tr(),
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            validateMethod:
                                ValidateConstants.validateEmailRegister,
                          ),
                          _distanceBetweenField(),
                          InputField(
                            label: 'screen.register.password'.tr(),
                            controller: _passController,
                            keyboardType: TextInputType.visiblePassword,
                            validateMethod:
                                ValidateConstants.validatePasswordRegister,
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
                          _distanceBetweenField(),
                          InputField(
                            label: 'screen.register.confirm_password'.tr(),
                            controller: _confirmPassController,
                            keyboardType: TextInputType.visiblePassword,
                            validateMethod: (confirmPass) =>
                                ValidateConstants.validateConfirmPassword(
                                    _passController.text, confirmPass),
                            suffixIcon: _isShowConfirmPass
                                ? Icons.visibility
                                : Icons.visibility_off,
                            suffixIconClicked: () {
                              setState(() {
                                _isShowConfirmPass = !_isShowConfirmPass;
                              });
                            },
                            isObscure: _isShowConfirmPass ? false : true,
                          ),
                          _distanceBetweenField(),
                          InputField(
                            label: 'screen.register.first_name'.tr(),
                            controller: _firstNameController,
                            keyboardType: TextInputType.text,
                            validateMethod: ValidateConstants.validateFirstName,
                          ),
                          _distanceBetweenField(),
                          InputField(
                            label: 'screen.register.last_name'.tr(),
                            controller: _lastNameController,
                            keyboardType: TextInputType.name,
                            validateMethod: ValidateConstants.validateLastName,
                          ),
                          _distanceBetweenField(),
                          InputField(
                            label: 'screen.register.phone'.tr(),
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            validateMethod: ValidateConstants.validatePhone,
                          ),
                        ],
                      )),
                  _distanceBetweenField(),
                  Text(
                    'screen.register.rule'.tr(),
                    style: _theme.textTheme.labelLarge,
                    textAlign: TextAlign.center,
                  ),
                  _distanceBetweenField(),
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
                                backgroundColor:
                                    WidgetStatePropertyAll(ColorConstants.main),
                                shape: WidgetStatePropertyAll(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(16))))),
                            onPressed: _handleBtnRegisterClicked,
                            child: Text('screen.register.title'.tr(),
                                style: _theme.textTheme.labelLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold))));
                  }, listener: (context, state) {
                    if (state is AuthRegisterSuccessState) {
                      context.showNotification(
                          'notification.register.register.successful'.tr());

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ActiveAccountScreen(),
                            settings: RouteSettings(arguments: state.email)),
                      );
                    } else if (state is AuthErrorState) {
                      context.showNotification(state.errMessage);
                    }
                  }),
                  _distanceBetweenField(),
                  Text(
                    'screen.register.or_register_by'.tr(),
                    style: _theme.textTheme.labelSmall
                        ?.copyWith(color: Colors.grey),
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
                            border: Border.all(color: ColorConstants.main)),
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
                            border: Border.all(color: ColorConstants.main)),
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
                      Text('screen.register.have_account_before'.tr(),
                          style: _theme.textTheme.labelLarge
                              ?.copyWith(color: Colors.black)),
                      const SizedBox(
                        width: 8,
                      ),
                      GestureDetector(
                        onTap: _navigateLoginScreen,
                        child: Text(
                          'screen.login.title'.tr(),
                          style: _theme.textTheme.labelLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox _distanceBetweenField() => const SizedBox(
        height: 25,
      );

  Future<void> _handleBtnRegisterClicked() async {
    if ((_formKey.currentState as FormState).validate()) {
      await _cubit.register(
        email: _emailController.text,
        password: _passController.text,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        phone: _phoneController.text,
      );
    }
  }

  void _navigateLoginScreen() {
    context.pop();
  }
}
