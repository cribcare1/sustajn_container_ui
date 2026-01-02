import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sustajn_customer/auth/screens/verify_email_screen.dart';

import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../../network_provider/network_provider.dart';
import '../../provider/signup_provider.dart';
import '../../utils/theme_utils.dart';
import '../../utils/utils.dart';

class ForgetPasswordScreen extends ConsumerStatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  ConsumerState<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends ConsumerState<ForgetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    var theme = CustomTheme.getTheme(true);
    final registrationState = ref.watch(signUpNotifier);
    return Scaffold(

      backgroundColor: theme!.scaffoldBackgroundColor,
      body: Padding(
        padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
        child: Form(
          key: _formKey,
          child: Stack(children: [SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: Constant.CONTAINER_SIZE_140),
                Text(
                  Strings.FORGOT_PASSWORD_TXT,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontSize: Constant.LABEL_TEXT_SIZE_20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white
                  ),
                ),

                SizedBox(height: Constant.CONTAINER_SIZE_10),
                Text(
                  Strings.ENTER_EMAIL_TORCV_CODE,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontSize: Constant.LABEL_TEXT_SIZE_15,
                  ),
                ),

                SizedBox(height: Constant.CONTAINER_SIZE_40),
                TextFormField(
                  controller: _emailController,
                  cursorColor: Colors.white,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color: Colors.white70),
                  decoration: InputDecoration(
                    hintText: Strings.EMAIL,
                    hintStyle: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
                      fontSize: Constant.LABEL_TEXT_SIZE_15,
                    ),
                    filled: true,
                    fillColor: theme.primaryColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
                        borderSide: BorderSide(color: Constant.grey),
                      ),
                      enabledBorder: CustomTheme.roundedBorder(Constant.grey),
                      focusedBorder: CustomTheme.roundedBorder(Constant.grey),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Enter your email ID';
                    }
                    if (!v.contains('@gmail.com')) {
                      return 'Enter a valid Gmail ID';
                    }
                    return null;
                  },
                ),
                SizedBox(height: height * 0.02),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFD0A52C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: (){
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context)=>VerifyEmailScreen(previousScreen: '',
                      //       email: _emailController.text,
                      //       )));
                      _getNetworkData();
                    },
                    child: Text(
                      Strings.CONTINUE_VERIFICATION,
                      style: theme.textTheme.titleMedium!
                          .copyWith(color: theme.primaryColor),
                    ),
                  ),
                ),
                SizedBox(height: height * 0.03),

              ],
            ),
          ),
            if(registrationState.isLoading)
              Center(
                child: CircularProgressIndicator(),
              )
          ],
          ),
        ),
      ),
    );
  }

  _getNetworkData() async {
      final registrationState = ref.watch(signUpNotifier);
    try {
      if (registrationState.isValid) {
        await ref
            .read(networkProvider.notifier)
            .isNetworkAvailable()
            .then((isNetworkAvailable) async {
          try {
            if (isNetworkAvailable) {
              registrationState.setIsLoading(true);
              registrationState.setContext(context);
              registrationState.setIsForgotPassword(true);
              registrationState.setEmail(_emailController.text);
              ref.read(getOtpToVerifyProvider({"email":_emailController.text}));
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