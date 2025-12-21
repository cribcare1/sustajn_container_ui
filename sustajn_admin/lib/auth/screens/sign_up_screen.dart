import 'dart:convert';
import 'dart:io';

import 'package:container_tracking/auth/screens/login_screen.dart';
import 'package:container_tracking/auth/screens/verify_email_screen.dart';
import 'package:container_tracking/common_widgets/submit_button.dart';
import 'package:container_tracking/constants/number_constants.dart';
import 'package:container_tracking/utils/SharedPreferenceUtils.dart';
import 'package:container_tracking/utils/theme_utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common_provider/network_provider.dart';
import '../../constants/string_utils.dart';
import '../../utils/utility.dart';
import '../auth_provider.dart';

enum UserType { user, restaurant, admin }

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    var themeData = CustomTheme.getTheme(true);
    final authState = ref.watch(authNotifierProvider);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
        child: Center(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Strings.SIGN_UP,
                    style: themeData!.textTheme.titleLarge,
                  ),
                  SizedBox(height: height * 0.005),
                  Text(
                    Strings.FILL_DETAILS,
                    style: themeData.textTheme.bodyMedium,
                  ),
                  SizedBox(height: height * 0.02),

                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: Strings.NAME,
                      filled: true,
                      fillColor: themeData.primaryColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Enter your name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: height * 0.02),

                  TextFormField(
                    controller: _mobileController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(10)
                    ],
                    decoration: InputDecoration(
                      labelText: Strings.MOBILE_NUMBER,
                      filled: true,
                      fillColor: themeData.primaryColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Enter your mobile number';
                      }
                      if (v.length != 10) {
                        return 'Enter a valid 10-digit number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: height * 0.02),

                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText:Strings.EMAIL,
                      filled: true,
                      fillColor:themeData.primaryColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Enter your email';
                      }
                      if (!v.contains('@')) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),



                  SizedBox(height: height * 0.02),

                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: Strings.PASSWORD,
                      filled: true,
                      fillColor: themeData.primaryColor,
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
                        borderRadius: BorderRadius.circular(10),
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
                  SizedBox(height: height * 0.02),

                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: !_isConfirmPasswordVisible,
                    decoration: InputDecoration(
                      labelText: Strings.CONFIRM_PASSWORD,
                      filled: true,
                      fillColor: themeData.primaryColor,
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
                        borderRadius: BorderRadius.circular(10),
                      ),
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
                  //TODO :- Required for google map
                  // SizedBox(height: height * 0.02),
                  // TextFormField(
                  //   controller: _locationController,
                  //   readOnly: true,
                  //   decoration: InputDecoration(
                  //     labelText:Strings.LOCATION,
                  //     filled: true,
                  //     fillColor: Colors.white,
                  //     suffixIcon: IconButton(
                  //       icon: const Icon(Icons.location_on, color: Colors.grey,),
                  //       onPressed: _navigateToMap,
                  //     ),
                  //     border: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(10),
                  //     ),
                  //   ),
                  //   validator: (v) {
                  //     if (v == null || v.trim().isEmpty) {
                  //       return 'Please select your location';
                  //     }
                  //     return null;
                  //   },
                  //   onTap: _navigateToMap,
                  // ),
                  SizedBox(height: height * 0.02),
                authState.isLoading?Center(child: CircularProgressIndicator(),):  SizedBox(
                    width: double.infinity,
                    child: SubmitButton(onRightTap: (){
                      if(_formKey.currentState!.validate()){
                        _getNetworkData(authState);
                      }
                    },rightText:  Strings.CONTINUE_VERIFICATION,)
                  ),
                  SizedBox(height: height * 0.02),
                  Center(
                    child: Text.rich(
                      TextSpan(
                        text: Strings.ALREADY_HAVE_ACC,
                        style: themeData.textTheme.bodyMedium,
                        children: [
                          TextSpan(
                            text: Strings.LOGIN,
                            style: TextStyle(
                              color: themeData.secondaryHeaderColor,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context)=> LoginScreen()));

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
      ),
    );
  }

  Future<void> _getNetworkData(var registrationState) async {
    try {
      FocusScope.of(context).unfocus();
      ref.read(authNotifierProvider).loginData(
        context,
        _emailController.text,
        _passwordController.text,
      );

      if (!registrationState.isValid) return;

      registrationState.setIsLoading(true);
      final isNetworkAvailable =
      await ref.read(networkProvider.notifier).isNetworkAvailable();
      if (!isNetworkAvailable) {
        if (!mounted) return;
        showCustomSnackBar(
          context: context,
          message: Strings.NO_INTERNET_CONNECTION,
          color: Colors.red,
        );
        return;
      }
      Map<String, dynamic> mapData = {
        "fullName": _nameController.text,
        "userType": "ADMIN",
        "email": _emailController.text,
        "phoneNumber": _mobileController.text,
        "userName": _emailController.text,
        "deviceOs": Platform.isAndroid ? "ANDROID" : "IOS",
        "password": _passwordController.text,
      };
      await SharedPreferenceUtils.saveDataInSF(
        "signUp",
        jsonEncode(mapData),
      );
      ref.read(
        validateEmail({
          "email": _emailController.text,
          "previous": "signUp",
        }),
      );
    } catch (e) {
      Utils.printLog('Error in Login button: $e');
    } finally {
      registrationState.setIsLoading(false);
    }
  }


  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}