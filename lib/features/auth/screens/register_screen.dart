import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jobsit_mobile/core/constants/asset_constants.dart';
import 'package:jobsit_mobile/features/auth/cubit/candidate_cubit.dart';
import 'package:jobsit_mobile/features/auth/screens/active_account_screen.dart';
import 'package:jobsit_mobile/core/constants/convert_constants.dart';

import '../cubit/candidate_state.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/text_constants.dart';
import '../../../core/constants/validate_constants.dart';
import '../../../core/constants/value_constants.dart';
import '../../../core/utils/widget_constants.dart';
import '../../../shared/widgets/input_field.dart';

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cubit = context.read<CandidateCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: ValueConstants.deviceHeightValue(uiValue: 30),),
              const Text(TextConstants.register,
                  style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w700,
                      color: ColorConstants.main)),
              Column(
                children: [
                  Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: ValueConstants.deviceHeightValue(uiValue: 50),),
                          InputField(
                            label: TextConstants.email,
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            validateMethod: ValidateConstants.validateEmailRegister,
                          ),
                          SizedBox(height: ValueConstants.deviceHeightValue(uiValue: 25),),
                          InputField(
                            label: TextConstants.password,
                            controller: _passController,
                            keyboardType: TextInputType.visiblePassword,
                            validateMethod: ValidateConstants.validatePasswordRegister,
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
                          SizedBox(height: ValueConstants.deviceHeightValue(uiValue: 25),),
                          InputField(
                            label: TextConstants.confirmPassword,
                            controller: _confirmPassController,
                            keyboardType: TextInputType.visiblePassword,
                            validateMethod: (confirmPass) => ValidateConstants.validateConfirmPassword(_passController.text, confirmPass),
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
                          SizedBox(height: ValueConstants.deviceHeightValue(uiValue: 25),),
                          InputField(
                            label: TextConstants.firstName,
                            controller: _firstNameController,
                            keyboardType: TextInputType.text,
                            validateMethod: ValidateConstants.validateFirstName,
                          ),
                          SizedBox(height: ValueConstants.deviceHeightValue(uiValue: 25),),
                          InputField(
                            label: TextConstants.lastName,
                            controller: _lastNameController,
                            keyboardType: TextInputType.name,
                            validateMethod: ValidateConstants.validateLastName,
                          ),
                          SizedBox(height: ValueConstants.deviceHeightValue(uiValue: 25),),
                          InputField(
                            label: TextConstants.phone,
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            validateMethod: ValidateConstants.validatePhone,
                          ),
                        ],
                      )),
                  SizedBox(height: ValueConstants.deviceHeightValue(uiValue: 25),),
                  const Text(
                    TextConstants.registerNote,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.w400),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                      height: ValueConstants.deviceHeightValue(uiValue: 32)
                  ),
                  BlocConsumer<CandidateCubit, CandidateState>(builder: (context, state){
                    if (state is AuthLoadingState){
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
                            onPressed: handleBtnRegisterClicked,
                            child: const Text(
                              TextConstants.register,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700),
                            )));
                  }, listener: (context, state){
                    if (state is AuthRegisterSuccessState){
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(TextConstants.registerSuccessful)));

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const ActiveAccountScreen(), settings: RouteSettings(arguments: state.email)),
                      );
                    }else if (state is AuthErrorState){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ConvertConstants.getMessageFromException(state.errMessage))));
                    }
                  }),
                  SizedBox(
                    height: ValueConstants.deviceHeightValue(uiValue: 20),
                  ),
                  const Text(
                    TextConstants.orContinueWith,
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
                      const Text(TextConstants.alreadyHaveAccount,
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: Colors.black)),
                      GestureDetector(onTap: navigateLoginScreen,child: const Text(
                        TextConstants.login,
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: ColorConstants.main),
                      ),)
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> handleBtnRegisterClicked() async {
    if ((_formKey.currentState as FormState).validate()){
      await _cubit.createCandidate(
        email: _emailController.text,
        password: _passController.text,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        phone: _phoneController.text,
      );
    }
  }

  void navigateLoginScreen() {
    Navigator.pop(context);
  }
}
