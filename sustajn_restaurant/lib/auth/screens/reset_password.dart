import 'package:flutter/material.dart';
import 'package:sustajn_restaurant/auth/screens/login_screen.dart';
import 'package:sustajn_restaurant/auth/screens/verify_email_screen.dart';

import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../../utils/theme_utils.dart';
import '../../utils/utility.dart';


class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    var theme = CustomTheme.getTheme(true);

    return Scaffold(

      backgroundColor: theme!.scaffoldBackgroundColor,
      body: WillPopScope(
        onWillPop: () async {
          final shouldGoBack = await Utils.displayDialog(
            context,
            Icons.warning_amber,
            Strings.LEAVE_RESET_PASSWORD,
            Strings.GO_BACK_RESET_PASSWORD,
            Strings.STAY_THIS_PAGE,
          );

          if (shouldGoBack) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context)=> VerifyEmailScreen(previousScreen: '')));
          }

          return false;
        },
        child: Padding(
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
                    Strings.RESET_PASSWORD,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontSize: Constant.LABEL_TEXT_SIZE_20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white
                    ),
                  ),

                  SizedBox(height: Constant.CONTAINER_SIZE_10),
                  Text(
                    Strings.SET_NEW_PASSWORD,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontSize: Constant.LABEL_TEXT_SIZE_15,
                    ),
                  ),

                  SizedBox(height: Constant.CONTAINER_SIZE_40),
                  TextFormField(
                    controller: _passwordController,
                    style: TextStyle(color: Colors.white70),
                    cursorColor: Colors.white70,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      hintText: Strings.PASSWORD,
                      hintStyle: TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: theme.primaryColor,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                        enabledBorder: CustomTheme.roundedBorder(Constant.grey),
                        focusedBorder: CustomTheme.roundedBorder(Constant.grey)
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'Enter your password';
                      }
                      if (v.length < 8) {
                        return 'Password must be at least 8 characters';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: height * 0.02),

                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: !_isConfirmPasswordVisible,
                    style: TextStyle(color: Colors.white70),
                    cursorColor: Colors.white70,
                    decoration: InputDecoration(
                      hintText: Strings.CONFIRM_PASSWORD,
                      hintStyle: TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: theme.primaryColor,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                        enabledBorder: CustomTheme.roundedBorder(Constant.grey),
                        focusedBorder: CustomTheme.roundedBorder(Constant.grey)
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'Confirm your password';
                      }
                      if (v != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: height * 0.02),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFD0A52C),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                        padding:  EdgeInsets.symmetric(vertical: Constant.CONTAINER_SIZE_12),
                      ),
                      onPressed: (){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context)=>LoginScreen()));
                      },
                      child: Text(
                        Strings.RESET,
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
      ),
    );
  }
}