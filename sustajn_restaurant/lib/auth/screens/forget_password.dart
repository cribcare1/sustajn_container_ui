import 'package:flutter/material.dart';
import 'package:sustajn_restaurant/auth/screens/verify_email_screen.dart';

import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../../utils/theme_utils.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    var theme = CustomTheme.getTheme(true);

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
                    fontSize: Constant.LABEL_TEXT_SIZE_20,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                SizedBox(height: Constant.CONTAINER_SIZE_10),
                Text(
                  Strings.ENTER_EMAIL_TORCV_CODE,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.textTheme.bodyMedium?.color!
                        .withOpacity(Constant.SIZE_065),
                    fontSize: Constant.LABEL_TEXT_SIZE_15,
                  ),
                ),

                SizedBox(height: Constant.CONTAINER_SIZE_40),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: Strings.EMAIL,
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
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
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context)=>VerifyEmailScreen(previousScreen: 'forgotPassword',)));
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
        ),
      ),
    );
  }
}