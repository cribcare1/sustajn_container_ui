import 'package:container_tracking/auth/screens/reset_password_screen.dart';
import 'package:flutter/material.dart';
import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

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
        
        
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(4, (index) {
                        return _otpBox(context, controllers[index]);
                      }),
                    ),
        
                    SizedBox(height: Constant.CONTAINER_SIZE_40),
        
        
                    SizedBox(
                      width: double.infinity,
                      height: Constant.CONTAINER_SIZE_50,
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
                          Navigator.push(context,
                          MaterialPageRoute(builder: (context)=>ResetPasswordScreen()));
                        },
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

  Widget _otpBox(BuildContext context, TextEditingController controller) {
    final theme = Theme.of(context);

    return Container(
      width: Constant.CONTAINER_SIZE_55,
      height: Constant.CONTAINER_SIZE_55,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
        border: Border.all(
          color: theme.primaryColor,
          width: Constant.SIZE_01,
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          inputDecorationTheme: const InputDecorationTheme(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            counterStyle: TextStyle(height: 0),
          ),
        ),
        child: TextField(
          controller: controller,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          cursorColor: theme.primaryColor,
          style: theme.textTheme.titleLarge?.copyWith(
            fontSize: Constant.LABEL_TEXT_SIZE_18,
            color: theme.textTheme.bodyLarge?.color,
          ),
          decoration: const InputDecoration(
            counterText: "",
          ),
        ),
      ),
    );
  }

}
