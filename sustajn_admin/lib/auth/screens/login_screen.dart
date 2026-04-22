import 'package:container_tracking/auth/auth_provider.dart';
import 'package:container_tracking/common_widgets/submit_button.dart';
import 'package:container_tracking/constants/number_constants.dart';
import 'package:container_tracking/utils/theme_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common_provider/network_provider.dart';
import '../../constants/assets_utils.dart';
import '../../constants/string_utils.dart';
import '../../utils/nav_utils.dart';
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
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Image.asset(
                    AppAssets.sustajnAppLogo,
                    height: height * 0.17,
                    fit: BoxFit.contain,
                  ),
                ),
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
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color: Colors.white70),
                  cursorColor: Colors.white70,
                  decoration: InputDecoration(
                    hintText: Strings.EMAIL,
                    filled: true,
                    fillColor: themeData!.primaryColor,
                    hintStyle: TextStyle(color: Colors.white70),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_20),
                      borderSide: BorderSide(color: Constant.grey),
                    ),
                  enabledBorder: CustomTheme.roundedBorder(Constant.grey),
                  focusedBorder: CustomTheme.roundedBorder(Constant.grey),
                  ),
                  onChanged: (value) {
                    if (_formKey.currentState != null) {
                      _formKey.currentState!.validate();
                    }
                  },
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
                  style: TextStyle(color: Colors.white70),
                  cursorColor: Colors.white70,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    hintText: Strings.PASSWORD,
                    filled: true,
                    fillColor: themeData!.primaryColor,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 12),
                    hintStyle: TextStyle(color: Colors.white70),
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
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
                    ),
                  enabledBorder: CustomTheme.roundedBorder(Constant.grey),
                  focusedBorder: CustomTheme.roundedBorder(Constant.grey),
                  ),
                  onChanged: (value) {
                    if (_formKey.currentState != null) {
                      _formKey.currentState!.validate();
                    }
                  },
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
                      NavUtil.navigateToPushScreen(context, ForgetPasswordScreen());
                    },
                      child: Text(
                      Strings.FORGOT_PASSWORD,
                      style: themeData.textTheme.titleSmall!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: height * 0.02),

               authState.isLoading?Center(child: CircularProgressIndicator(),): SizedBox(
                  width: double.infinity,
                  child:SubmitButton(onRightTap: (){
                    if (_formKey.currentState!.validate()) {
                      _getNetworkData(authState);
                    }
                  },rightText: Strings.LOGIN)
                ),
                SizedBox(height: height * 0.02),
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }
  _getNetworkData(var registrationState) async {
    try {
      registrationState.setIsLoading(true);
      ref.read(authNotifierProvider).loginData(
          context, _emailController.text, _passwordController.text);
      if (registrationState.isValid) {
        await ref
            .read(networkProvider.notifier)
            .isNetworkAvailable()
            .then((isNetworkAvailable) async {
          Utils.printLog("isNetworkAvailable::$isNetworkAvailable");
          try {
            if (isNetworkAvailable) {
              registrationState.setIsLoading(true);
              ref.read(loginDetailProvider({"userName":_emailController.text,"password":_passwordController.text,"role":"ADMIN"}));
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