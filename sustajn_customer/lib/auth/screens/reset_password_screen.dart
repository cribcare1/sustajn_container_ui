import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sustajn_customer/auth/screens/verify_email_screen.dart';

import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../../network_provider/network_provider.dart';
import '../../provider/signup_provider.dart';
import '../../utils/theme_utils.dart';
import '../../utils/utils.dart';

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
  void initState() {
    super.initState();
    _passwordController.addListener(() {
      if (_formKey.currentState != null) {
        _formKey.currentState!.validate();
      }
    });

    _confirmPasswordController.addListener(() {
      if (_formKey.currentState != null) {
        _formKey.currentState!.validate();
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    var theme = CustomTheme.getTheme(true);
    final signUpState = ref.watch(signUpNotifier);

    return WillPopScope(
      onWillPop: () async {
        final shouldGoBack = await displayDialog(
          context,
          Icons.warning_amber,
          Strings.LEAVE_RESET_PASSWORD,
          Strings.LEAVE_PASSWORD_TXT,
          Strings.STAY_ON_THIS_PAGE,
        );

        if (shouldGoBack) {
          Navigator.pop(context);
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: theme!.scaffoldBackgroundColor,
        body: Stack(children: [SingleChildScrollView(
          padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
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
                    setState(() => _isPasswordVisible = !_isPasswordVisible);
                  },
                  validator: (v) {
                    if (v!.isEmpty) return "Password required";
                    if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&]).{8,}$').hasMatch(v)) {
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
                    setState(() =>
                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible);
                  },
                  validator: (v) {
                    if (v!.isEmpty) return "Confirm password required";
                    if (v != _passwordController.text) return "Passwords do not match";
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
                    onPressed: signUpState.isLoading
                        ? null
                        : () {
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
          ),),
          if(signUpState.isLoading)
            Center(
              child: CircularProgressIndicator(
                color: Constant.gold,
              ),
            )
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
            ),     onPressed: toggleVisibility,
          ),
        ),
      ),
    );
  }

  Future<bool> displayDialog(
      BuildContext context,
      IconData icon,
      String title,
      String subTitle,
      String stayButtonText,
      ) async {
    final theme = Theme.of(context);

    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: theme.scaffoldBackgroundColor,
        insetPadding: EdgeInsets.symmetric(
          horizontal: Constant.PADDING_HEIGHT_10,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_20),
        ),
        child: Padding(
          padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
                  border: Border.all(
                      color: Constant.grey.withOpacity(0.1)
                  ),
                  color: Constant.white.withOpacity(0.1),
                  shape: BoxShape.rectangle,
                ),
                child: Icon(
                  icon,
                  size: Constant.CONTAINER_SIZE_40,
                  color: Constant.gold,
                ),
              ),
              SizedBox(height: Constant.CONTAINER_SIZE_12),
              Text(title, style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white
              )),
              SizedBox(height: Constant.SIZE_05),
              Text(
                subTitle,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white
                ),
              ),
              SizedBox(height: Constant.CONTAINER_SIZE_12),

              Row(
                children: [
                  // GO BACK
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFC8B531)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            Constant.CONTAINER_SIZE_12,
                          ),
                        ),
                      ),
                      child: Text(
                        "Go back",
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: Constant.gold,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: Constant.CONTAINER_SIZE_12),

                  // STAY
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Constant.gold,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            Constant.CONTAINER_SIZE_12,
                          ),
                        ),
                      ),
                      child: Text(
                        maxLines: 1,
                        stayButtonText,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ) ?? false;
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
                resetPasswordProvider({"email": registrationState?.email, "newPassword": _confirmPasswordController.text}),
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