import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sustajn_restaurant/auth/screens/sign_up_screen.dart';

import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../../utils/theme_utils.dart';
import '../bottom_navigation_bar/bottom_navigation_bar.dart';
import 'dashboard_screen.dart';
import 'forget_password.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showPassword = false;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    var themeData = CustomTheme.getTheme(true);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  Strings.WELCOME,
                  style: themeData?.textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: height * 0.005),
                Text(
                  Strings.LOGIN_YOUR_ACC,
                  style: themeData?.textTheme.bodyMedium,
                ),
                SizedBox(height: height * 0.03),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: Strings.EMAIL,
                    filled: true,
                    fillColor: Colors.white,
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Enter your email';
                    }
                    if (!v.contains('@') || v.trim().length < 5) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: height * 0.02),
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_showPassword,
                  decoration: InputDecoration(
                    hintText: Strings.PASSWORD,
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 12),
                    hintStyle: TextStyle(color: Colors.grey),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _showPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _showPassword = !_showPassword;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter your password";
                    }
                    if (value.length < 8) {
                      return "Password must be at least 8 characters";
                    }
                    return null;
                  },
                ),

                SizedBox(height: height * 0.01),

                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ForgetPasswordScreen(),
                        ),
                      );
                    },
                    child: Text(
                      Strings.FORGOT_PASSWORD,
                      style: themeData!.textTheme.titleSmall!.copyWith(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: height * 0.02),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD0A52C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(context,
                      MaterialPageRoute(builder: (context)=> DashboardScreen()));
                    },
                    child: Text(
                      Strings.LOGIN,
                      style: themeData.textTheme.titleMedium!.copyWith(
                        color: themeData.primaryColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: height * 0.02),
                Center(
                  child: Text.rich(
                    TextSpan(
                      text:Strings.DONT_HAVE_ACC ,
                      style: themeData.textTheme.bodyMedium,
                      children: [
                        TextSpan(
                          text: Strings.SIGN_UP,
                          style: TextStyle(
                            color: themeData.primaryColor,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const SignUpScreen(),
                                ),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}