import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../../network_provider/network_provider.dart';
import '../../provider/login_provider.dart';
import '../../utils/theme_utils.dart';
import '../../utils/utility.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    var theme = CustomTheme.getTheme(true);
    final signUpState = ref.watch(authNotifierProvider);
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
            Navigator.pop(context);
          }

          return false;
        },
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
              child: Form(
                key: _formKey,
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
                        color: Colors.white,
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

                    _buildPasswordField(
                      context,
                      controller: _passwordController,
                      hint: Strings.PASSWORD,
                      visible: !_isPasswordVisible,
                      toggleVisibility: () {
                        setState(
                          () => _isPasswordVisible = !_isPasswordVisible,
                        );
                      },
                      validator: (v) {
                        if (v!.isEmpty) return "Password required";
                        if (!RegExp(
                          r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&]).{8,}$',
                        ).hasMatch(v)) {
                          return "Password must be 8+ chars with letters, numbers & special char";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: height * 0.02),

                    _buildPasswordField(
                      context,
                      controller: _confirmPasswordController,
                      hint: Strings.CONFIRM_PASSWORD,
                      visible: !_isConfirmPasswordVisible,
                      toggleVisibility: () {
                        setState(
                          () => _isConfirmPasswordVisible =
                              !_isConfirmPasswordVisible,
                        );
                      },
                      validator: (v) {
                        if (v!.isEmpty) return "Confirm password required";
                        if (v != _passwordController.text)
                          return "Passwords do not match";
                        return null;
                      },
                    ),
                    SizedBox(height: height * 0.03),
                    SizedBox(
                      width: double.infinity,
                      height: Constant.CONTAINER_SIZE_45,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFD0A52C),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _getNetworkDataVerify(signUpState);
                          }
                        },
                        child: Text(
                          Strings.RESET,
                          style: theme.textTheme.titleMedium!.copyWith(
                            color: theme.primaryColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.03),
                  ],
                ),
              ),
            ),
            if (signUpState.isLoading)
              Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField(
    BuildContext context, {
    required TextEditingController controller,
    required String hint,
    required bool visible,
    required VoidCallback toggleVisibility,
    String? Function(String?)? validator,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: Constant.SIZE_15),
      child: TextFormField(
        controller: controller,
        obscureText: !visible,
        validator: validator,
        style: TextStyle(color: Colors.white70),
        cursorColor: Colors.white70,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white70),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
            borderSide: BorderSide(color: Constant.grey),
          ),
          enabledBorder: CustomTheme.roundedBorder(Constant.grey),
          focusedBorder: CustomTheme.roundedBorder(Constant.grey),
          contentPadding: EdgeInsets.symmetric(
            horizontal: Constant.SIZE_15,
            vertical: Constant.SIZE_15,
          ),
          filled: true,
          fillColor: theme.primaryColor,
          suffixIcon: IconButton(
            icon: Icon(
              visible ? Icons.visibility : Icons.visibility_off,
              color: Colors.white70,
            ),
            onPressed: toggleVisibility,
          ),
        ),
      ),
    );
  }

  _getNetworkDataVerify(var registrationState) async {
    try {
      if (registrationState.isValid) {
        await ref.read(networkProvider.notifier).isNetworkAvailable().then((
          isNetworkAvailable,
        ) async {
          try {
            if (isNetworkAvailable) {
              registrationState.setIsLoading(true);
              registrationState.setResend(true);
              ref.read(
                resetPasswordProvider({
                  "email": registrationState?.email,
                  "newPassword": _confirmPasswordController.text,
                }),
              );
            } else {
              registrationState.setIsLoading(false);
              if (!mounted) return;
              showCustomSnackBar(
                context: context,
                message: Strings.NO_INTERNET_CONNECTION,
                color: Colors.red,
              );
            }
          } catch (e) {
            Utils.printLog('Error on button onPressed: $e');
            registrationState.setIsLoading(false);
          }
          if (!mounted) return;
          FocusScope.of(context).unfocus();
        });
      }
    } catch (e) {
      Utils.printLog('Error in Login button onPressed: $e');
      registrationState.setIsLoading(false);
    }
  }
}
