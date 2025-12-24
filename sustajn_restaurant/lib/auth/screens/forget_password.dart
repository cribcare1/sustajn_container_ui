import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sustajn_restaurant/auth/screens/verify_email_screen.dart';

import '../../common_widgets/submit_button.dart';
import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../../network_provider/network_provider.dart';
import '../../provider/login_provider.dart';
import '../../utils/theme_utils.dart';
import '../../utils/utility.dart';

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
    final authState = ref.watch(authNotifierProvider);
    return Scaffold(

      backgroundColor: theme!.scaffoldBackgroundColor,
      body: Padding(
        padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: Constant.CONTAINER_SIZE_140),
                Text(
                  Strings.FORGOT_PASSWORD_TXT,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontSize: Constant.LABEL_TEXT_SIZE_20,
                    fontWeight: FontWeight.w600,
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
                  style: TextStyle(color: Colors.white70),
                  cursorColor: Colors.white70,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: Strings.EMAIL,
                    hintStyle: TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: theme.primaryColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    enabledBorder: CustomTheme.roundedBorder(
                      Constant.grey,
                    ),
                    focusedBorder: CustomTheme.roundedBorder(
                      Constant.grey,
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Enter your email ID';
                    }
                    if (!v.contains('@')) {
                      return 'Enter a valid Gmail ID';
                    }
                    return null;
                  },
                ),
                SizedBox(height: height * 0.02),
                // authState.isLoading?Center(child: CircularProgressIndicator(),):
                SizedBox(
                    width: double.infinity,
                    child: SubmitButton(onRightTap: (){if(_formKey.currentState!.validate()){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context)=>VerifyEmailScreen(previousScreen: 'forgotPassword', email: '',)));
                      // _getNetworkData(authState);
                    }},rightText: Strings.CONTINUE_VERIFICATION,)
                ),
              ],
            ),
          ),
        ),
      ),
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
              ref.read(forgotPasswordProvider({"email":_emailController.text}));
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