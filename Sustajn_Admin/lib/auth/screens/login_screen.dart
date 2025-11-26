import 'package:container_tracking/auth/screens/sign_up_screen.dart';
import 'package:container_tracking/constants/number_constants.dart';
import 'package:container_tracking/utils/theme_utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../common_widgets/card_widget.dart';
import '../../constants/string_utils.dart';
import 'bottom_navigation_bar/bottom_navigation_bar.dart';
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

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    var themeData = CustomTheme.getTheme(true);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
        child: Center(
          child: SummaryCard(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(Strings.LOGIN, style: themeData!.textTheme.titleLarge),
                  SizedBox(height: height * 0.02),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Enter your email';
                      }
                      // very simple email check
                      if (!v.contains('@') || v.trim().length < 5) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: height * 0.02),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
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
                  SizedBox(height: height * 0.01),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: ((_) {
                              return ForgetPasswordScreen();
                            }),
                          ),
                        );
                      },
                      child: Text(
                        'Forgot Password?',
                        style: themeData.textTheme.titleSmall!.copyWith(
                          color: themeData.primaryColor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeData.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
                    },
                    child: Text(
                      'Login',
                      style: themeData.textTheme.titleMedium!.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  Text.rich(
                    TextSpan(
                      text: "New user? ",
                      style: const TextStyle(fontSize: 14),
                      children: [
                        TextSpan(
                          text: "Sign up",
                          style: const TextStyle(
                            color: Colors.indigo,
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
