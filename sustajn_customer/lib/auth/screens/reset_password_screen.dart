import 'package:flutter/material.dart';
import 'package:sustajn_customer/auth/screens/verify_email_screen.dart';

import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../../utils/theme_utils.dart';


class ResetPasswordScreen extends StatefulWidget {
  final String? token;
  const ResetPasswordScreen({super.key,  this.token});

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
          final shouldGoBack = await displayDialog(
            context,
            Icons.warning_amber,
            Strings.LEAVE_RESET_PASSWORD,
            Strings.LEAVE_PASSWORD_TXT,
            Strings.STAY_ON_THIS_PAGE,
          );

          if (shouldGoBack) {
              Navigator.pop(context, widget.token);
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
                    obscureText: !_isPasswordVisible,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: Strings.PASSWORD,
                      hintStyle: theme.textTheme.bodyMedium?.copyWith(
                        color:Colors.white,
                        fontSize: Constant.LABEL_TEXT_SIZE_15,
                      ),
                      filled: true,
                      fillColor:theme.primaryColor,
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
                        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
                        borderSide: BorderSide(color: Constant.grey),
                      ),
                      enabledBorder: CustomTheme.roundedBorder(Constant.grey),
                      focusedBorder: CustomTheme.roundedBorder(Constant.grey),
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
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: Strings.CONFIRM_PASSWORD,
                      hintStyle: theme.textTheme.bodyMedium?.copyWith(
                        color:Colors.white,
                        fontSize: Constant.LABEL_TEXT_SIZE_15,
                      ),
                      filled: true,
                      fillColor:theme.primaryColor,
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
                        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
                        borderSide: BorderSide(color: Constant.grey),
                      ),
                      enabledBorder: CustomTheme.roundedBorder(Constant.grey),
                      focusedBorder: CustomTheme.roundedBorder(Constant.grey),
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
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFD0A52C),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: (){

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
}