import 'package:container_tracking/auth/screens/login_screen.dart';
import 'package:container_tracking/auth/screens/verify_email_screen.dart';
import 'package:container_tracking/constants/number_constants.dart';
import 'package:container_tracking/utils/theme_utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../constants/string_utils.dart';
import 'map_selection_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _locationController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  void _revalidate() {
    if (_formKey.currentState != null) {
      _formKey.currentState!.validate();
    }
  }

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
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(Strings.SIGN_UP,
                      style: themeData!.textTheme.titleLarge),
                  SizedBox(height: height * 0.005),
                  Text(Strings.FILL_DETAILS,
                      style: themeData.textTheme.bodyMedium),
                  SizedBox(height: height * 0.02),

                  // NAME
                  TextFormField(
                    controller: _nameController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: (_) => _revalidate(),
                    decoration: _inputDecoration(Strings.NAME),
                    validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Enter your name' : null,
                  ),
                  SizedBox(height: height * 0.02),

                  TextFormField(
                    controller: _mobileController,
                    keyboardType: TextInputType.number,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: (v) {
                      if (v.length > 10) {
                        _mobileController.text = v.substring(0, 10);
                        _mobileController.selection = TextSelection.fromPosition(
                          TextPosition(offset: 10),
                        );
                      }
                      _revalidate();
                    },
                    decoration: _inputDecoration(Strings.MOBILE_NUMBER),
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
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: (_) => _revalidate(),
                    decoration: _inputDecoration(Strings.EMAIL),
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
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: (_) => _revalidate(),
                    decoration: _inputDecoration(Strings.PASSWORD).copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
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
                      if (v == null || v.isEmpty) return 'Enter your password';
                      if (v.length < 8) return 'Password must be at least 8 characters';
                      return null;
                    },
                  ),
                  SizedBox(height: height * 0.02),

                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: !_isConfirmPasswordVisible,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: (_) => _revalidate(),
                    decoration:
                    _inputDecoration(Strings.CONFIRM_PASSWORD).copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isConfirmPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _isConfirmPasswordVisible =
                            !_isConfirmPasswordVisible;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Confirm your password';
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
                  SizedBox(height: height * 0.03),
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
                        if (_formKey.currentState!.validate()) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => VerifyEmailScreen(),
                            ),
                          );
                        }
                      },
                      child: Text(
                        Strings.CONTINUE_VERIFICATION,
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
                        text: Strings.ALREADY_HAVE_ACC,
                        style: themeData.textTheme.bodyMedium,
                        children: [
                          TextSpan(
                            text: Strings.LOGIN,
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
                                    builder: (_) => const LoginScreen(),
                                  ),
                                );
                              },
                          ),
                        ],
                      ),
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

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }


  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _locationController.dispose();
    super.dispose();
  }
}