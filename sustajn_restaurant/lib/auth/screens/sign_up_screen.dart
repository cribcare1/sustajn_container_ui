import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sustajn_restaurant/auth/screens/login_screen.dart';
import 'package:sustajn_restaurant/auth/screens/verify_email_screen.dart';
import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';

class SignUpScreen extends StatefulWidget {
  final int currentStep;
  const SignUpScreen({super.key, this.currentStep=0});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool passwordVisible = false;


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(Constant.SIZE_15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).padding.top + Constant.CONTAINER_SIZE_70),
              Row(
                children: List.generate(4, (index) {
                  bool active = index <= widget.currentStep;
                  return Expanded(
                    child: Container(
                      height: Constant.SIZE_05,
                      margin: EdgeInsets.only(right: index == 3 ? 0 : Constant.SIZE_10),
                      decoration: BoxDecoration(
                        color: active
                            ? theme.primaryColor
                            : theme.primaryColor.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(Constant.SIZE_10),
                      ),
                    ),
                  );
                }),
              ),

              SizedBox(height: Constant.CONTAINER_SIZE_20),

              Text(
                Strings.SIGN_UP,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontSize: Constant.LABEL_TEXT_SIZE_22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: Constant.SIZE_05),

              Text(
                Strings.PROVE_DETAILS,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.hintColor,
                  fontSize: Constant.LABEL_TEXT_SIZE_14,
                ),
              ),

              SizedBox(height: Constant.CONTAINER_SIZE_20),

              _buildTextField(context, Strings.RESTURANT_NAME),
              _buildTextField(context, Strings.EMAIL),
              _buildTextField(context, Strings.MOBILE_NUMBER, keyboard: TextInputType.phone),

              _buildPasswordField(context, Strings.PASSWORD),

              _buildTextField(context,Strings.CONFIRM_PASSWORD, obscure: true),

              SizedBox(height: Constant.CONTAINER_SIZE_20),

              SizedBox(
                width: double.infinity,
                height: Constant.CONTAINER_SIZE_50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFD0A52C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Constant.SIZE_10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                    MaterialPageRoute(builder: (context)=>VerifyEmailScreen()));
                  },
                  child: Text(
                    Strings.CONTINUE_VERIFICATION,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.primaryColor,
                      fontSize: Constant.LABEL_TEXT_SIZE_16,
                    ),
                  ),
                ),
              ),

              SizedBox(height: Constant.CONTAINER_SIZE_20),

              Center(
                child: RichText(
                  text: TextSpan(
                    text:Strings.ALREADY_HAVE_ACC,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.hintColor,
                      fontSize: Constant.LABEL_TEXT_SIZE_14,
                    ),
                    children: [
                      TextSpan(
                        text: Strings.LOGIN,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.primaryColor,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                         ..onTap = (){
                          Navigator.push(context,
                          MaterialPageRoute(builder: (context)=>LoginScreen()));
                         }
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      BuildContext context,
      String hint, {
        bool obscure = false,
        TextInputType keyboard = TextInputType.text,
      }) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: Constant.SIZE_15),
      child: TextField(
        obscureText: obscure,
        keyboardType: keyboard,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: theme.textTheme.bodyMedium?.copyWith(
            color: theme.hintColor,
            fontSize: Constant.LABEL_TEXT_SIZE_15,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: Constant.SIZE_15,
            vertical: Constant.SIZE_15,
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Constant.SIZE_10),
            borderSide: BorderSide(color: theme.dividerColor),
          ),
        ),
      ),
    );
  }


  Widget _buildPasswordField(BuildContext context, String hint) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: Constant.SIZE_15),
      child: TextField(
        obscureText: !passwordVisible,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: theme.textTheme.bodyMedium?.copyWith(
            color: theme.hintColor,
            fontSize: Constant.LABEL_TEXT_SIZE_15,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: Constant.SIZE_15,
            vertical: Constant.SIZE_15,
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Constant.SIZE_10),
            borderSide: BorderSide(color: theme.dividerColor),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              passwordVisible ? Icons.visibility : Icons.visibility_off,
              color: theme.iconTheme.color,
            ),
            onPressed: () {
              setState(() {
                passwordVisible = !passwordVisible;
              });
            },
          ),
        ),
      ),
    );
  }
}
