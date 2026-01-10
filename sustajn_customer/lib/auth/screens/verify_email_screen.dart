import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinput/pinput.dart';

import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../../models/login_model.dart';
import '../../models/register_data.dart';
import '../../network_provider/network_provider.dart';
import '../../provider/signup_provider.dart';
import '../../utils/shared_preference_utils.dart';
import '../../utils/utils.dart';

class VerifyEmailScreen extends ConsumerStatefulWidget {
  final String previousScreen;

  const VerifyEmailScreen({super.key, required this.previousScreen});

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = ref.read(signUpNotifier);

      notifier.setVerifyLoading(false);
      notifier.setResendLoading(false);
      notifier.resetTimer();
      notifier.startTimer();
    });
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
    final signUpState = ref.watch(signUpNotifier);
    RegistrationData? registrationData = signUpState.registrationData;
    String? email = signUpState.email;
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      body: WillPopScope(
        onWillPop: () async {
          final shouldGoBack = await displayDialog(
            context,
            Icons.warning_amber,
            Strings.GO_BACK,
            Strings.VERIFIED_EMAIL,
            Strings.STAY_ON_THIS_PAGE,
          );

          if (shouldGoBack) {
            Navigator.pop(context);
          }
          if (shouldGoBack) {
            if (widget.previousScreen == "signUp") {
              Navigator.pop(context, registrationData);
            } else if (widget.previousScreen == "forgotPassword") {
              Navigator.pop(context, email);
            }
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
                            "${Strings.SEND_CODE}${email}",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white,
                              fontSize: Constant.LABEL_TEXT_SIZE_15,
                            ),
                          ),

                          SizedBox(height: Constant.CONTAINER_SIZE_40),

                          Center(child: buildOtp(context, _otpController)),

                          SizedBox(height: Constant.CONTAINER_SIZE_40),

                          signUpState.isVerifyLoading
                              ? Center(child: CircularProgressIndicator(
                            color: Constant.gold,
                          ))
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
                                      if (_otpController.text.isEmpty) {
                                        showCustomSnackBar(
                                          context: context,
                                          message: "Please enter your OTP",
                                          color: Colors.black,
                                        );
                                        return;
                                      }

                                      if (_otpController.text.length != 6) {
                                        showCustomSnackBar(
                                          context: context,
                                          message:
                                              "Please enter a valid 6-digit OTP",
                                          color: Colors.black,
                                        );
                                        return;
                                      }

                                      await _getNetworkData(signUpState);
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
                                "Resend code in ${formatTime(signUpState.seconds)}",
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
                                        _getNetworkDataVerify(signUpState);
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

  Future<bool> displayDialog(
    BuildContext context,
    IconData icon,
    String title,
    String subTitle,
    String stayButtonText,
  ) async {
    final theme = Theme.of(context);

    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (_) => Dialog(
            backgroundColor: theme.scaffoldBackgroundColor,
            insetPadding: EdgeInsets.symmetric(
              horizontal: Constant.PADDING_HEIGHT_10,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_20),
            ),
            child: Padding(
              padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        Constant.CONTAINER_SIZE_12,
                      ),
                      border: Border.all(color: Constant.grey.withOpacity(0.1)),
                      color: Constant.white.withOpacity(0.1),
                      shape: BoxShape.rectangle,
                    ),
                    child: Icon(
                      icon,
                      size: Constant.CONTAINER_SIZE_40,
                      color: Constant.gold,
                    ),
                  ),
                  SizedBox(height: Constant.CONTAINER_SIZE_12),
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: Constant.SIZE_05),
                  Text(
                    subTitle,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: Constant.CONTAINER_SIZE_12),

                  Row(
                    children: [
                      // GO BACK
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFC8B531)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                Constant.CONTAINER_SIZE_12,
                              ),
                            ),
                          ),
                          child: Text(
                            "Go back",
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: Constant.gold,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(width: Constant.CONTAINER_SIZE_12),

                      // STAY
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Constant.gold,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                Constant.CONTAINER_SIZE_12,
                              ),
                            ),
                          ),
                          child: Text(
                            maxLines: 1,
                            stayButtonText,
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: theme.primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ) ??
        false;
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

  _getNetworkData(var registrationState) async {
    try {
      if (registrationState.isValid) {
        await ref.read(networkProvider.notifier).isNetworkAvailable().then((
          isNetworkAvailable,
        ) async {
          try {
            if (isNetworkAvailable) {
              registrationState.setVerifyLoading(true);
              ref.read(
                verifyOtpProvider({
                  "email": registrationState?.email,
                  "token": _otpController.text,
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

  _getNetworkDataVerify(var registrationState) async {
    try {
      if (registrationState.isValid) {
        await ref.read(networkProvider.notifier).isNetworkAvailable().then((
          isNetworkAvailable,
        ) async {
          try {
            if (isNetworkAvailable) {
              registrationState.setResendLoading(true);
              registrationState.setResend(true);
              ref.read(
                getOtpToVerifyProvider({"email": registrationState?.email}),
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
            Utils.printLog('Error on button onPressed: $e');
            registrationState.setResendLoading(false);
          }
          if (!mounted) return;
          FocusScope.of(context).unfocus();
        });
      }
    } catch (e) {
      Utils.printLog('Error in Login button onPressed: $e');
      registrationState.setResendLoading(false);
    }
  }

  @override
  void dispose() {
    ref.read(signUpNotifier).stopTimer();
    _otpController.dispose();
    super.dispose();
  }


}
