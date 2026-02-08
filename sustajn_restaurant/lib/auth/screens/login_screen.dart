import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sustajn_restaurant/auth/screens/sign_up_screen.dart';
import 'package:sustajn_restaurant/constants/assets_utils.dart';

import '../../common_widgets/submit_button.dart';
import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../../network_provider/network_provider.dart';
import '../../provider/login_provider.dart';
import '../../utils/theme_utils.dart';
import '../../utils/utility.dart';
import 'forget_password.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showPassword = false;

  @override
  void initState() {
    super.initState();
    getDevice();
  }

  Future<void> getDevice() async {
    await Utils.getDeviceToken();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final themeData = CustomTheme.getTheme(true);
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Center(
                              child: Image.asset(
                                AppAssets.sustajnAppLogo,
                                height: height * 0.17,
                                fit: BoxFit.contain,
                              ),
                            ),
                            SizedBox(height: height * 0.025),
                            Text(
                              Strings.WELCOME,
                              style: themeData?.textTheme.titleLarge!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: height * 0.005),
                            Text(
                              Strings.LOGIN_YOUR_ACC,
                              style: themeData?.textTheme.bodyMedium!.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: height * 0.03),
                            TextFormField(
                              controller: _emailController,
                              autovalidateMode:
                              AutovalidateMode.onUserInteraction,
                              keyboardType: TextInputType.emailAddress,
                              style: const TextStyle(color: Colors.white70),
                              cursorColor: Colors.white70,
                              decoration: InputDecoration(
                                hintText: Strings.EMAIL,
                                filled: true,
                                fillColor: themeData!.primaryColor,
                                hintStyle:
                                const TextStyle(color: Colors.white70),
                                enabledBorder:
                                CustomTheme.roundedBorder(Constant.grey),
                                focusedBorder:
                                CustomTheme.roundedBorder(Constant.grey),
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
                              obscureText: !_showPassword,
                              style: const TextStyle(color: Colors.white70),
                              cursorColor: Colors.white70,
                              autovalidateMode:
                              AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration(
                                hintText: Strings.PASSWORD,
                                filled: true,
                                fillColor: themeData.primaryColor,
                                hintStyle:
                                const TextStyle(color: Colors.white70),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _showPassword
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.white70,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _showPassword = !_showPassword;
                                    });
                                  },
                                ),
                                enabledBorder:
                                CustomTheme.roundedBorder(Constant.grey),
                                focusedBorder:
                                CustomTheme.roundedBorder(Constant.grey),
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
                                      builder: (_) =>
                                      const ForgetPasswordScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  Strings.FORGOT_PASSWORD,
                                  style: themeData.textTheme.titleSmall!
                                      .copyWith(color: Colors.white),
                                ),
                              ),
                            ),
                            SizedBox(height: height * 0.025),
                            authState.isLoading
                                ? const Center(
                              child: CircularProgressIndicator(),
                            )
                                : SubmitButton(
                              onRightTap: () {
                                if (_formKey.currentState!.validate()) {
                                  _getNetworkData(authState);
                                }
                              },
                              rightText: Strings.LOGIN,
                            ),
                            SizedBox(height: height * 0.025),
                            Center(
                              child: Text.rich(
                                TextSpan(
                                  text: Strings.DONT_HAVE_ACC,
                                  style: themeData.textTheme.bodyMedium!
                                      .copyWith(color: Colors.white),
                                  children: [
                                    TextSpan(
                                      text: Strings.SIGN_UP,
                                      style: TextStyle(
                                        color: Constant.gold,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = authState.isLoading
                                            ? null
                                            : () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                              const SignUpScreen(),
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
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _getNetworkData(var registrationState) async {
    try {
      ref.read(authNotifierProvider).loginData(
        context,
        _emailController.text,
        _passwordController.text,
      );

      if (registrationState.isValid) {
        final isNetworkAvailable =
        await ref.read(networkProvider.notifier).isNetworkAvailable();

        if (!mounted) return;

        if (isNetworkAvailable) {
          registrationState.setIsLoading(true);
          ref.read(
            loginDetailProvider({
              "userName": _emailController.text,
              "password": _passwordController.text,
            }),
          );
        } else {
          registrationState.setIsLoading(false);
          showCustomSnackBar(
            context: context,
            message: Strings.NO_INTERNET_CONNECTION,
            color: Colors.red,
          );
        }

        FocusScope.of(context).unfocus();
      }
    } catch (e) {
      Utils.printLog('Login error: $e');
      registrationState.setIsLoading(false);
    }
  }
}
