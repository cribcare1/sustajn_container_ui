import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinput/pinput.dart';
import 'package:sustajn_restaurant/common_widgets/custom_app_bar.dart';
import 'package:sustajn_restaurant/common_widgets/custom_back_button.dart';
import 'package:sustajn_restaurant/models/registration_data.dart';
import 'package:sustajn_restaurant/notifier/login_notifier.dart';

import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../../models/login_model.dart';
import '../../network_provider/network_provider.dart';
import '../../provider/login_provider.dart';
import '../../utils/sharedpreference_utils.dart';
import '../../utils/utility.dart';

class VerifyEmailScreen extends ConsumerStatefulWidget {
  final String previousScreen;
  final RegistrationData? registrationData;
  final String? email;

  const VerifyEmailScreen({
    super.key,
    required this.previousScreen,
    this.registrationData,
     this.email,
  });

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  final List<TextEditingController> controllers = List.generate(
    4,
    (index) => TextEditingController(),
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = ref.read(authNotifierProvider);

      notifier.setVerifyLoading(false);
      notifier.setResendLoading(false);
      notifier.resetTimer();
      notifier.startTimer();
    });
    _getUserData();
    // _startTimer();
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

  String formatTime(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  final _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final signUpState = ref.watch(authNotifierProvider);
    RegistrationData? registrationData = signUpState.registrationData;
    String? email = signUpState.email;
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: "",
        leading: CustomBackButton(
          onTap: () async {
            final shouldGoBack = await Utils.displayDialog(
              context,
              Icons.warning_amber,
              Strings.GO_BACK,
              Strings.VERIFIED_MAIL,
              Strings.STAY_THIS_PAGE,
            );

            if (shouldGoBack) {
              ref.read(authNotifierProvider).stopTimer();
              Navigator.pop(context);
            }
          },
        ),
      ).getAppBar(context),
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
            signUpState.stopTimer();
            Navigator.pop(context);
          }
          return false;
        },

        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) => Stack(
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: Constant.CONTAINER_SIZE_24,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight:
                          constraints.maxHeight - Constant.CONTAINER_SIZE_55,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: Constant.CONTAINER_SIZE_40),
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
                            "${Strings.SEND_CODE}${Utils.maskEmail(email)}",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white,
                              fontSize: Constant.LABEL_TEXT_SIZE_15,
                            ),
                          ),

                          SizedBox(height: Constant.CONTAINER_SIZE_40),

                          Center(child: buildOtp(context, _otpController)),

                          SizedBox(height: Constant.CONTAINER_SIZE_40),

                          signUpState.isVerifyLoading
                              ? Center(
                                  child: CircularProgressIndicator(
                                    color: Constant.gold,
                                  ),
                                )
                              : SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFFD0A52C),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          Constant.CONTAINER_SIZE_16,
                                        ),
                                        side: BorderSide(color: Colors.white)
                                      ),
                                    ),
                                    onPressed: () async {
                                      if (_otpController.text.isEmpty) {
                                        showCustomSnackBar(
                                          context: context,
                                          message: Strings.ENTER_OTP,
                                          color: Colors.black,
                                        );
                                        return;
                                      }

                                      if (_otpController.text.length != 6) {
                                        showCustomSnackBar(
                                          context: context,
                                          message:
                                              Strings.VALID_OTP,
                                          color: Colors.black,
                                        );
                                        return;
                                      }

                                      await _getNetworkDataVerify(signUpState);
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
                                              fontSize:
                                                  Constant.LABEL_TEXT_SIZE_16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ),
                                  ),
                                ),

                          SizedBox(height: Constant.CONTAINER_SIZE_20),

                          if (signUpState.seconds > 0) ...[
                            Center(
                              child: Text(
                                "${Strings.RESEND_IN}${formatTime(signUpState.seconds)}",
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontSize: Constant.LABEL_TEXT_SIZE_15,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ] else ...[
                            Center(
                              child: signUpState.isResendLoading
                                  ? const CircularProgressIndicator(
                                      color: Constant.gold,
                                    )
                                  : TextButton(
                                      onPressed: () {
                                        _resetOtp(signUpState);
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            Strings.DIDNT_RECV_CODE,
                                            style: theme.textTheme.bodyLarge
                                                ?.copyWith(
                                                  color: Colors.white,
                                                  fontSize: Constant
                                                      .LABEL_TEXT_SIZE_16,
                                                ),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            Strings.RESEND,
                                            style: theme.textTheme.bodyLarge
                                                ?.copyWith(
                                                  color: Constant.gold,
                                                  decoration:
                                                      TextDecoration.underline,
                                                  fontSize: Constant
                                                      .LABEL_TEXT_SIZE_16,
                                                  fontWeight: FontWeight.bold,
                                              decorationColor: Constant.gold
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                            ),
                          ],

                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
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
      autofocus: true,
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
      /// 🔹 Start loader
      registrationState.setIsOTPVerify(true);
      if (registrationState.isValid) {
        await ref.read(networkProvider.notifier).isNetworkAvailable().then((
          isNetworkAvailable,
        ) async {
          try {
            if (isNetworkAvailable) {
              registrationState.setVerifyLoading(true);
              registrationState.setContext(context);
              ref.read(
                verifyOtpProvider({
                  "email": registrationState.email,
                  "token": _otpController.text.trim(),
                  "previous": widget.previousScreen,
                }),
              );
            } else {
              registrationState.setVerifyLoading(false);
              if (!mounted) return;
              showCustomSnackBar(
                context: context,
                message: Strings.NO_INTERNET_CONNECTION,
                color: Colors.red,
              );
            }
          } catch (e) {
            Utils.printLog('Error on button onPressed: $e');
            registrationState.setVerifyLoading(false);
          }
          if (!mounted) return;
          FocusScope.of(context).unfocus();
        });
      }
    } catch (e) {
      Utils.printLog('Error in Login button onPressed: $e');
      registrationState.setVerifyLoading(false);
    }
  }

  _resetOtp(var registrationState) async {
    try {
      await ref.read(networkProvider.notifier).isNetworkAvailable().then((
        isNetworkAvailable,
      ) async {
        try {
          if (isNetworkAvailable) {
            registrationState.setResendLoading(true);
            ref.read(
              validateEmail({
                "email":  registrationState?.email,
                "previous": widget.previousScreen,
              }),
            );
          } else {
            registrationState.setResendLoading(false);
            if (!mounted) return;
            showCustomSnackBar(
              context: context,
              message: Strings.NO_INTERNET_CONNECTION,
              color: Colors.red,
            );
          }
        } catch (e) {
          registrationState.setResendLoading(false);
        }
        if (!mounted) return;
        FocusScope.of(context).unfocus();
      });
    } catch (e) {
      registrationState.setResendLoading(false);
    }
  }

  @override
  void dispose() {
    ref.read(authNotifierProvider).stopTimer();
    _otpController.dispose();
    super.dispose();
  }
}
