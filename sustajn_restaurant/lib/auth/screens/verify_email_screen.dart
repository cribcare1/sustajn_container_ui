import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import 'package:pinput/pinput.dart';

import '../../models/login_model.dart';
import '../../network_provider/network_provider.dart';
import '../../provider/login_provider.dart';
import '../../utils/sharedpreference_utils.dart';
import '../../utils/utility.dart';

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

  int seconds = 60;

  @override
  void initState() {
    super.initState();
    _getUserData();
    _startTimer();
  }
  LoginModel? loginModel;
  _getUserData()async{
    String? jsonString = await SharedPreferenceUtils.getStringValuesSF(Strings.PROFILE_DATA);

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
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      body: SafeArea(
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
                      ),
                    ),

                    SizedBox(height: Constant.CONTAINER_SIZE_10),

                    Text(
                      Strings.SEND_CODE,
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

                    SizedBox(
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
                        onPressed: ()async {
                          await  _getNetworkData(authState);
                          if (widget.previousScreen == "forgotPassword") {
                            _getNetworkData(authState);
                          } else {
                            _getNetworkDataVerify(authState);
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: Constant.SIZE_08,
                          ),
                          child: Text(
                            Strings.VERIFY,
                            style: theme.textTheme.titleMedium?.copyWith(
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
                        "Resend Code in 0:${seconds.toString().padLeft(2, '0')}",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: Constant.LABEL_TEXT_SIZE_15,
                          color: Colors.black,
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
                                color: Colors.black,
                                fontSize: Constant.LABEL_TEXT_SIZE_16,
                              ),
                            ),
                            Text(
                              Strings.RESEND,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.primaryColor,
                                decoration: TextDecoration.underline,
                                fontSize: Constant.LABEL_TEXT_SIZE_16,
                                fontWeight: FontWeight.bold,
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
        border: Border.all(color: theme.primaryColor, width: 1),
      ),
    );

    return Pinput(
      length: 4,
      // Change to 6 if needed
      controller: controller,
      keyboardType: TextInputType.number,

      defaultPinTheme: defaultPinTheme,

      focusedPinTheme: defaultPinTheme.copyWith(
        decoration: defaultPinTheme.decoration!.copyWith(
          border: Border.all(color: theme.primaryColor, width: 2),
        ),
      ),

      submittedPinTheme: defaultPinTheme.copyWith(
        decoration: defaultPinTheme.decoration!.copyWith(
          border: Border.all(color: theme.primaryColor, width: 1.2),
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

  _getNetworkData(var registrationState) async {
    try {
      if (registrationState.isValid) {
        await ref
            .read(networkProvider.notifier)
            .isNetworkAvailable()
            .then((isNetworkAvailable) async {
          try {
            if (isNetworkAvailable) {
              registrationState.setIsLoading(true);
              ref.read(forgotPasswordProvider({"email":loginModel!.userName,"token":_otpController.text}));
            } else {
              registrationState.setIsLoading(false);
              if(!mounted) return;
              showCustomSnackBar(context: context, message: Strings.NO_INTERNET_CONNECTION, color: Colors.red);
            }
          } catch (e) {
            Utils.printLog('Error on button onPressed: $e');
            registrationState.setIsLoading(false);
          }
          if(!mounted) return;
          FocusScope.of(context).unfocus();
        });
      }
    } catch (e) {
      Utils.printLog('Error in Login button onPressed: $e');
      registrationState.setIsLoading(false);
    }
  }
  _getNetworkDataVerify(var registrationState) async {
    try {
      if (registrationState.isValid) {
        await ref
            .read(networkProvider.notifier)
            .isNetworkAvailable()
            .then((isNetworkAvailable) async {
          try {
            if (isNetworkAvailable) {
              registrationState.setIsLoading(true);
              ref.read(verifyOtpProvider({"email":loginModel!.userName,"token":_otpController.text}));
            } else {
              registrationState.setIsLoading(false);
              if(!mounted) return;
              showCustomSnackBar(context: context, message: Strings.NO_INTERNET_CONNECTION, color: Colors.red);
            }
          } catch (e) {
            Utils.printLog('Error on button onPressed: $e');
            registrationState.setIsLoading(false);
          }
          if(!mounted) return;
          FocusScope.of(context).unfocus();
        });
      }
    } catch (e) {
      Utils.printLog('Error in Login button onPressed: $e');
      registrationState.setIsLoading(false);
    }
  }
}
