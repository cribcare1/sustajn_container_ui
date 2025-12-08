import 'package:flutter/material.dart';
import 'package:sustajn_restaurant/auth/screens/reset_password.dart';
import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import 'package:pinput/pinput.dart';

import 'login_screen.dart';
class VerifyEmailScreen extends StatefulWidget {
  final String previousScreen;
  const VerifyEmailScreen({super.key, required this.previousScreen});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final List<TextEditingController> controllers =
  List.generate(4, (index) => TextEditingController());

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
                minHeight: constraints.maxHeight -
                    Constant.CONTAINER_SIZE_55,
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
                        color: theme.textTheme.bodyMedium?.color!
                            .withOpacity(Constant.SIZE_065),
                        fontSize: Constant.LABEL_TEXT_SIZE_15,
                      ),
                    ),

                    SizedBox(height: Constant.CONTAINER_SIZE_40),

                    Center(child: buildOtp(context,_otpController)),

                    SizedBox(height: Constant.CONTAINER_SIZE_40),


                    SizedBox(
                      width: double.infinity,
                      // height: Constant.CONTAINER_SIZE_50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:Color(0xFFD0A52C),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              Constant.CONTAINER_SIZE_12,
                            ),
                          ),
                        ),
                        onPressed: () {
                          if(widget.previousScreen == "forgotPassword"){
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context)=>ResetPasswordScreen()));
                          }else{
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context)=>LoginScreen()));
                          }

                        },
                        child: Padding(
                          padding:  EdgeInsets.symmetric(vertical: Constant.SIZE_08),
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
                          color:Colors.black,
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
                        child:
                        Row(
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
                                  fontWeight: FontWeight.bold
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
        border: Border.all(
          color: theme.primaryColor,
          width: 1,
        ),
      ),
    );

    return Pinput(
      length: 4, // Change to 6 if needed
      controller: controller,
      keyboardType: TextInputType.number,

      defaultPinTheme: defaultPinTheme,

      focusedPinTheme: defaultPinTheme.copyWith(
        decoration: defaultPinTheme.decoration!.copyWith(
          border: Border.all(
            color: theme.primaryColor,
            width: 2,
          ),
        ),
      ),

      submittedPinTheme: defaultPinTheme.copyWith(
        decoration: defaultPinTheme.decoration!.copyWith(
          border: Border.all(
            color: theme.primaryColor,
            width: 1.2,
          ),
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
}
