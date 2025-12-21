import 'package:container_tracking/auth/screens/reset_password_screen.dart';
import 'package:container_tracking/common_widgets/submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinput/pinput.dart';
import 'package:riverpod/src/framework.dart';

import '../../common_provider/network_provider.dart';
import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../../utils/SharedPreferenceUtils.dart';
import '../../utils/utility.dart';
import '../auth_provider.dart';
import 'login_screen.dart';

class VerifyEmailScreen extends ConsumerStatefulWidget {
  final String previousScreen;
  final String email;

  const VerifyEmailScreen({
    super.key,
    required this.previousScreen,
    required this.email,
  });

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  final List<TextEditingController> controllers = List.generate(
    4,
    (index) => TextEditingController(),
  );

  int seconds = 60;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      if (seconds > 0) {
        setState(() => seconds--);
        return true;
      }
      return false;
    });
  }

  final _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authNotifierProvider);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: Constant.CONTAINER_SIZE_24,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - Constant.CONTAINER_SIZE_55,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: Constant.CONTAINER_SIZE_140),
                        Text(
                          Strings.VERIFY_EMAIL,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontSize: Constant.LABEL_TEXT_SIZE_20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: Constant.CONTAINER_SIZE_10),
                        Text(
                          "${Strings.SEND_CODE}${widget.email}",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.textTheme.bodyMedium?.color!.withOpacity(
                              Constant.SIZE_065,
                            ),
                            fontSize: Constant.LABEL_TEXT_SIZE_15,
                          ),
                        ),

                        SizedBox(height: Constant.CONTAINER_SIZE_40),

                        Center(child: buildOtp(context, _otpController)),

                        SizedBox(height: Constant.CONTAINER_SIZE_40),

                        authState.isVerifying
                            ? Center(child: CircularProgressIndicator())
                            : SizedBox(
                                width: double.infinity,
                                child: SubmitButton(
                                    rightText:  Strings.VERIFY,
                                    onRightTap: (){_getNetworkDataVerify(authState);})
                              ),

                        SizedBox(height: Constant.CONTAINER_SIZE_40),

                        Center(
                          child: Text(
                            "Resend Code in 0:${seconds.toString().padLeft(2, '0')}",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: Constant.LABEL_TEXT_SIZE_15,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        SizedBox(height: Constant.CONTAINER_SIZE_20),

                        Center(
                          child: TextButton(
                            onPressed: seconds == 0
                                ? () {
                                    setState(() {
                                      seconds = 60;
                                      _startTimer();
                                    });
                                  }
                                : null,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  Strings.DIDNT_RECV_CODE,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: Colors.white,
                                    fontSize: Constant.LABEL_TEXT_SIZE_16,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    _resetOtp(authState);
                                  },
                                  child: Text(
                                    Strings.RESEND,
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      color: theme.secondaryHeaderColor,
                                      decoration: TextDecoration.underline,
                                      fontSize: Constant.LABEL_TEXT_SIZE_16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if(authState.isLoading)...[
              Center(child: CircularProgressIndicator()),
            ]
          ],
        ),
      ),
    );
  }

  Widget buildOtp(BuildContext context, TextEditingController controller) {
    final theme = Theme.of(context);

    final defaultPinTheme = PinTheme(
      width: 55,
      height: 55,
      textStyle: theme.textTheme.titleLarge?.copyWith(
        fontSize: 18,
        color: theme.textTheme.bodyLarge?.color,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white, width: 1),
      ),
    );

    return Pinput(
      length: 6,
      controller: controller,
      keyboardType: TextInputType.number,

      defaultPinTheme: defaultPinTheme,

      focusedPinTheme: defaultPinTheme.copyWith(
        decoration: defaultPinTheme.decoration!.copyWith(
          border: Border.all(color: theme.secondaryHeaderColor, width: 2),
        ),
      ),

      submittedPinTheme: defaultPinTheme.copyWith(
        decoration: defaultPinTheme.decoration!.copyWith(
          border: Border.all(color: theme.secondaryHeaderColor, width: 1.2),
        ),
      ),
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      showCursor: true,
      cursor: Container(
        width: 2,
        height: 18,
        margin: const EdgeInsets.only(bottom: 4),
        color: theme.primaryColor,
      ),

      onCompleted: (value) {
        print("OTP Entered: $value");
      },
    );
  }

  Future<void> _getNetworkDataVerify(var registrationState) async {
    try {
      registrationState.setIsOTPVerify(true);

      final isNetworkAvailable =
      await ref.read(networkProvider.notifier).isNetworkAvailable();

      if (!isNetworkAvailable) {
        registrationState.setIsOTPVerify(false);
        if (!mounted) return;

        showCustomSnackBar(
          context: context,
          message: Strings.NO_INTERNET_CONNECTION,
          color: Colors.red,
        );
        return;
      }

      final result = await ref.read(
        verifyOtpProvider({
          "email": widget.email,
          "token": _otpController.text,
          "previous": widget.previousScreen,
        }).future,
      );

      final response = result["response"];
      final previous = result["previous"];

      if (response["status"] == Strings.SUCCESS) {
        if (!mounted) return;

        showCustomSnackBar(
          context: context,
          message: "Email Verification Successful",
          color: Colors.green,
        );

        if (previous == "forgotPassword") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const ResetPasswordScreen()),
          );
        } else {
          final Map<String, dynamic>? data =
          await SharedPreferenceUtils.getMapFromSF("signUp");

          if (data != null) {
            ref.read(registerDetailProvider(data).future).then((value){
              if(value.isNotEmpty){
                showCustomSnackBar(context: context, message: value['message'], color: Colors.green);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
              }
            });
          }
        }
      } else {
        if (!mounted) return;

        showCustomSnackBar(
          context: context,
          message: response["message"],
          color: Colors.red,
        );
      }
    } catch (e) {
      Utils.printLog("OTP Verify Error: $e");
    }finally{
      registrationState.setIsOTPVerify(false);
    }
  }



  _resetOtp(var registrationState) async {
    try {
      registrationState.setIsLoading(true);
      await ref.read(networkProvider.notifier).isNetworkAvailable().then((
        isNetworkAvailable,
      ) async {
        try {
          if (isNetworkAvailable) {
            registrationState.setIsLoading(true);
            ref.read(
              validateEmail({
                "email": widget.email,
                "previous": widget.previousScreen,
              }),
            );
          } else {
            registrationState.setIsLoading(false);
            if (!mounted) return;
            showCustomSnackBar(
              context: context,
              message: Strings.NO_INTERNET_CONNECTION,
              color: Colors.red,
            );
          }
        } catch (e) {
          Utils.printLog('Error on button onPressed: $e');
          registrationState.setIsLoading(false);
        }
        if (!mounted) return;
        FocusScope.of(context).unfocus();
      });
    } catch (e) {
      Utils.printLog('Error in Login button onPressed: $e');
      registrationState.setIsLoading(false);
    }
  }
}
