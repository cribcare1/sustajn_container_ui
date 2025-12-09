import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sustajn_restaurant/auth/screens/login_screen.dart';
import 'package:sustajn_restaurant/auth/screens/verify_email_screen.dart';
import 'package:sustajn_restaurant/common_widgets/submit_button.dart';
import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';

class SignUpScreen extends StatefulWidget {
  final int currentStep;
  const SignUpScreen({super.key, this.currentStep = 0});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final restaurantCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final mobileCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();
  final addressCtrl = TextEditingController();

  bool passwordVisible = false;
  bool confirmPasswordVisible = false;

  @override
  void dispose() {
    restaurantCtrl.dispose();
    emailCtrl.dispose();
    mobileCtrl.dispose();
    passwordCtrl.dispose();
    confirmPasswordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(Constant.SIZE_15),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).padding.top +
                      Constant.CONTAINER_SIZE_70,
                ),
                Row(
                  children: List.generate(4, (index) {
                    bool active = index <= widget.currentStep;
                    return Expanded(
                      child: Container(
                        height: Constant.SIZE_05,
                        margin: EdgeInsets.only(
                            right: index == 3 ? 0 : Constant.SIZE_10),
                        decoration: BoxDecoration(
                          color: active
                              ? theme.primaryColor
                              : theme.primaryColor.withOpacity(0.3),
                          borderRadius:
                          BorderRadius.circular(Constant.SIZE_10),
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
                SizedBox(height: Constant.CONTAINER_SIZE_16),
                _buildTextField(
                  context,
                  controller: restaurantCtrl,
                  hint: Strings.RESTURANT_NAME,
                  validator: (v) =>
                  v!.isEmpty ? "Restaurant name required" : null,
                ),
                _buildTextField(
                  context,
                  controller: emailCtrl,
                  hint: Strings.EMAIL,
                  keyboard: TextInputType.emailAddress,
                  validator: (v) {
                    if (v!.isEmpty) return "Email required";
                    if (!v.contains("@")) return "Enter valid email";
                    return null;
                  },
                ),
                _buildTextField(
                  context,
                  controller: mobileCtrl,
                  hint: Strings.MOBILE_NUMBER,
                  keyboard: TextInputType.phone,
                  validator: (v) {
                    if (v!.isEmpty) return "Mobile number required";
                    if (v.length < 10) return "Enter valid mobile number";
                    return null;
                  },
                ),
                _buildPasswordField(
                  context,
                  controller: passwordCtrl,
                  hint: Strings.PASSWORD,
                  visible: passwordVisible,
                  toggleVisibility: () {
                    setState(() => passwordVisible = !passwordVisible);
                  },
                  validator: (v) {
                    if (v!.isEmpty) return "Password required";
                    if (v.length < 6) return "Minimum 6 characters";
                    return null;
                  },
                ),
                _buildPasswordField(
                  context,
                  controller: confirmPasswordCtrl,
                  hint: Strings.CONFIRM_PASSWORD,
                  visible: confirmPasswordVisible,
                  toggleVisibility: () {
                    setState(() =>
                    confirmPasswordVisible = !confirmPasswordVisible);
                  },
                  validator: (v) {
                    if (v!.isEmpty) return "Confirm password required";
                    if (v != passwordCtrl.text) {
                      return "Passwords do not match";
                    }
                    return null;
                  },
                ),
                InkWell(
                  onTap: (){},
                  child: _buildTextField(
                    readOnly: true,
                    context,
                    controller: addressCtrl,
                    hint: Strings.RESTURANT_ADDRESS,
                    validator: (v) =>
                    v!.isEmpty ? "Restaurant address required" : null,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  child: SubmitButton(
                    onRightTap: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => VerifyEmailScreen(previousScreen: 'signUp',)),
                        );
                      }
                    },
                    rightText: Strings.CONTINUE_VERIFICATION,
                  ),
                ),
                SizedBox(height: Constant.CONTAINER_SIZE_16),
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: Strings.ALREADY_HAVE_ACC,
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
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()),
                              );
                            },
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildTextField(
      BuildContext context, {
        required TextEditingController controller,
        required String hint,
        String? Function(String?)? validator,
        bool obscure = false,
        TextInputType keyboard = TextInputType.text,
        bool? readOnly= false,
      }) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: Constant.SIZE_15),
      child: TextFormField(
        readOnly: readOnly!,
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboard,
        validator: validator,
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
              visible ? Icons.visibility : Icons.visibility_off,
              color: theme.iconTheme.color,
            ),
            onPressed: toggleVisibility,
          ),
        ),
      ),
    );
  }
}
