import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinput/pinput.dart';
import 'package:sustajn_restaurant/auth/screens/reset_password.dart';
import 'package:sustajn_restaurant/models/registration_data.dart';
import 'package:sustajn_restaurant/notifier/login_notifier.dart';

import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../../models/login_model.dart';
import '../../network_provider/network_provider.dart';
import '../../provider/login_provider.dart';
import '../../utils/sharedpreference_utils.dart';
import '../../utils/utility.dart';
import 'business_information_screen.dart';

class VerifyEmailScreen extends ConsumerStatefulWidget {
  final String previousScreen;
  final RegistrationData? registrationData;
  final String email;

  const VerifyEmailScreen({
    super.key,
    required this.previousScreen,
    this.registrationData,
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

  int seconds = 120;

  @override
  void initState() {
    super.initState();
    _getUserData();
    _startTimer();
  }

  LoginModel? loginModel;

  _getUserData() async {
    String? jsonString = await SharedPreferenceUtils.getStringValuesSF(
      Strings.PROFILE_DATA,
    );

    if (jsonString != null && jsonString.isNotEmpty) {
      loginModel = LoginModel.fromJson(jsonDecode(jsonString));
    }
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
    final emailToShow = widget.registrationData?.email ?? widget.email;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      body: WillPopScope(
        onWillPop: () async {
          final shouldGoBack = await Utils.displayDialog(
            context,
            Icons.warning_amber,
            Strings.GO_BACK,
            Strings.VERIFIED_MAIL,
            Strings.STAY_THIS_PAGE,
          );

          if (shouldGoBack) {
            Navigator.pop(context);
          }

          return false;
        },
        child: SafeArea(
          child: LayoutBuilder(
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
                          color: Colors.white,
                        ),
                      ),

                      SizedBox(height: Constant.CONTAINER_SIZE_10),

                      Text(
                        "We've sent you a code to verify your email id on\n$emailToShow",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
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
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFD0A52C),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      Constant.CONTAINER_SIZE_12,
                                    ),
                                  ),
                                ),
                                onPressed: () async {
                                  final otp = _otpController.text.trim();

                                  if (otp.isEmpty) {
                                    showCustomSnackBar(
                                      context: context,
                                      message: "Please enter OTP",
                                      color: Colors.red,
                                    );
                                    return;
                                  }

                                  if (otp.length < 6) {
                                    showCustomSnackBar(
                                      context: context,
                                      message:
                                          "Please enter a valid 6-digit OTP",
                                      color: Colors.red,
                                    );
                                    return;
                                  }

                                  await _getNetworkDataVerify(authState);
                                },

                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: Constant.SIZE_08,
                                  ),
                                  child: Text(
                                    Strings.VERIFY,
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                          color: theme.primaryColor,
                                          fontSize: Constant.LABEL_TEXT_SIZE_16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ),
                              ),
                            ),

                      SizedBox(height: Constant.CONTAINER_SIZE_40),

                      Center(
                        child: Text(
                          "Resend Code in ${seconds ~/ 60}:${(seconds % 60).toString().padLeft(2, '0')}",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: Constant.LABEL_TEXT_SIZE_15,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      SizedBox(height: Constant.CONTAINER_SIZE_20),

                      if (seconds == 0)
                        Center(
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                seconds = 120;
                                _startTimer();
                              });
                            },
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
                                      color: Constant.gold,
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
        color: Colors.white70,
      ),
      decoration: BoxDecoration(
        color: theme.primaryColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Constant.grey, width: 1),
      ),
    );

    return Pinput(
      length: 6,
      // Change to 6 if needed
      controller: controller,
      keyboardType: TextInputType.number,

      defaultPinTheme: defaultPinTheme,

      focusedPinTheme: defaultPinTheme.copyWith(
        decoration: defaultPinTheme.decoration!.copyWith(
          border: Border.all(color: Constant.grey, width: 2),
        ),
      ),

      submittedPinTheme: defaultPinTheme.copyWith(
        decoration: defaultPinTheme.decoration!.copyWith(
          border: Border.all(color: Constant.grey, width: 1.2),
        ),
      ),
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      showCursor: true,
      cursor: Container(
        width: 2,
        height: 18,
        margin: const EdgeInsets.only(bottom: 4),
        color: Colors.white70,
      ),

      onCompleted: (value) {
        print("OTP Entered: $value");
      },
    );
  }

  Future<void> _getNetworkDataVerify(AuthState registrationState) async {
    try {
      registrationState.setIsOTPVerify(true);

      /// 1️⃣ Network check
      final isNetworkAvailable = await ref
          .read(networkProvider.notifier)
          .isNetworkAvailable();

      if (!isNetworkAvailable) {
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
          "email": widget.registrationData?.email ?? widget.email,
          "token": _otpController.text,
          "previous": widget.previousScreen,
        }).future,
      );

      print("OTP VERIFY RESULT =====> $result");

      final Map<String, dynamic> response =
          result["response"] as Map<String, dynamic>;
      final String previous = result["previous"] as String;

      /// 3️⃣ OTP SUCCESS
      if (response["status"] == Strings.SUCCESS) {
        if (!mounted) return;

        showCustomSnackBar(
          context: context,
          message: "Email Verification Successful",
          color: Colors.green,
        );

        /// 🔹 Forgot Password Flow
        if (previous == "forgotPassword") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const ResetPasswordScreen()),
          );
          return;
        } else {
          Utils.navigateToPushScreen(
            context,
            BusinessInformationDetails(authState: registrationState),
          );
        }
      }
      /// 4️⃣ OTP FAILED
      else {
        if (!mounted) return;

        showCustomSnackBar(
          context: context,
          message: response["message"] ?? "OTP verification failed",
          color: Colors.red,
        );
      }
    } catch (e) {
      Utils.printLog("OTP Verify Error: $e");
    } finally {
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
                "token": _otpController.text,
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
