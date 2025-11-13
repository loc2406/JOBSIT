import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobsit_mobile/features/auth/cubit/candidate_cubit.dart';
import 'package:jobsit_mobile/features/auth/cubit/candidate_state.dart';
import 'package:jobsit_mobile/core/constants/color_constants.dart';
import 'package:jobsit_mobile/core/constants/convert_constants.dart';
import 'package:jobsit_mobile/core/constants/text_constants.dart';
import 'package:jobsit_mobile/core/constants/validate_constants.dart';
import 'package:jobsit_mobile/core/constants/value_constants.dart';
import 'package:jobsit_mobile/core/utils/widget_constants.dart';
import 'package:jobsit_mobile/shared/widgets/input_field_async.dart';

class ActiveAccountScreen extends StatefulWidget {
  const ActiveAccountScreen({super.key});

  @override
  State<ActiveAccountScreen> createState() => _ActiveAccountScreenState();
}

class _ActiveAccountScreenState extends State<ActiveAccountScreen> {
  late final CandidateCubit _cubit;
  String? _email;
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cubit = context.read<CandidateCubit>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _email ??= ModalRoute.of(context)!.settings.arguments.toString();
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
            vertical: ValueConstants.screenHeight * 0.02,
            horizontal: ValueConstants.screenWidth * 0.03),
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
            SizedBox(
              height: ValueConstants.screenHeight * 0.01,
            ),
            const Text(
              TextConstants.pleaseInputOTPInEmail,

              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 13),
            ),
            SizedBox(
              height: ValueConstants.screenHeight * 0.01,
            ),
            Form(
              key: _formKey,
              child: InputFieldAsync(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  validateMethod: ValidateConstants.validateOtp),
            ),
            SizedBox(
              height: ValueConstants.screenHeight * 0.02,
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
                          padding: WidgetStatePropertyAll(EdgeInsets.symmetric(
                              vertical: 12, horizontal: 32)),
                          backgroundColor:
                              WidgetStatePropertyAll(ColorConstants.main),
                          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4))))),
                      onPressed: () async {
                        await verifyEmail();
                      },
                      child: const Text(
                        TextConstants.VERIFY_EMAIL,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700),
                      )));
            }, listener: (context, state) {
              if (state is AuthActiveSuccessState) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(TextConstants.activeAccountSuccess)));
                  Navigator.pop(context);
              } else if (state is AuthErrorState) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(ConvertConstants.getMessageFromException(state.errMessage))));
              }
            }),
            SizedBox(
              height: ValueConstants.screenHeight * 0.02,
            ),
            GestureDetector(
              onTap: sendOtpAgain,
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

  Future<void> verifyEmail() async {
    if ((_formKey.currentState as FormState).validate()) {
      await _cubit.sendOtpToActiveAccount(_otpController.text);
    }
  }

  Future<void> sendOtpAgain() async {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text(TextConstants.sentOtpMess)));
    await _cubit.sendActiveEmail(_email!);
  }
}
