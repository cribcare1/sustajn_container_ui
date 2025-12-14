import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sustajn_restaurant/auth/screens/login_screen.dart';
import 'package:sustajn_restaurant/common_widgets/submit_button.dart';
import 'package:sustajn_restaurant/models/registration_data.dart';
import 'package:sustajn_restaurant/auth/screens/map_screen.dart';
import 'package:sustajn_restaurant/auth/screens/verify_email_screen.dart';
import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../../provider/login_provider.dart';
import '../../utils/utility.dart';
import 'business_information.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  final int currentStep;
  const SignUpScreen({super.key, this.currentStep = 0});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final restaurantCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final mobileCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();
  final addressCtrl = TextEditingController();

  bool passwordVisible = false;
  bool confirmPasswordVisible = false;
  double lat = 0.0;
  double long = 0.0;

  File? selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    restaurantCtrl.addListener(() => setState(() {}));
    emailCtrl.addListener(() => setState(() {}));
    mobileCtrl.addListener(() => setState(() {}));
    passwordCtrl.addListener(() => setState(() {}));
    confirmPasswordCtrl.addListener(() => setState(() {}));
    addressCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    restaurantCtrl.dispose();
    emailCtrl.dispose();
    mobileCtrl.dispose();
    passwordCtrl.dispose();
    confirmPasswordCtrl.dispose();
    addressCtrl.dispose();
    super.dispose();
  }

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 70,
    );

    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);

      setState(() {
        selectedImage = imageFile;
      });

      ref.read(authNotifierProvider).setImage(imageFile);
    }
  }

  bool _validateImage() {
    if (selectedImage == null) {
      Utils.showToast("Please select a profile image");
      return false;
    }
    return true;
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
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).padding.top +
                      Constant.CONTAINER_SIZE_50,
                ),
                Row(
                  children: List.generate(3, (index) {
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

                Center(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(60),
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16)),
                        ),
                        builder: (_) => Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: const Icon(Icons.camera),
                              title: const Text("Camera"),
                              onTap: () {
                                Navigator.pop(context);
                                pickImage(ImageSource.camera);
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.photo),
                              title: const Text("Gallery"),
                              onTap: () {
                                Navigator.pop(context);
                                pickImage(ImageSource.gallery);
                              },
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      );
                    },
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      backgroundImage:
                      selectedImage != null ? FileImage(selectedImage!) : null,
                      child: selectedImage == null
                          ? Icon(
                        Icons.person,
                        size: 50,
                        color: theme.primaryColor,
                      )
                          : null,
                    ),
                  ),
                ),

                SizedBox(height: Constant.CONTAINER_SIZE_16),

                _buildTextField(
                  context,
                  controller: restaurantCtrl,
                  hint: Strings.RESTURANT_NAME,
                  validator: (v) {
                    if (v!.isEmpty) return "Restaurant name required";
                    if (!RegExp(r'^[a-zA-Z0-9 ]+$').hasMatch(v)) {
                      return "No special characters allowed";
                    }
                    return null;
                  },
                ),

                _buildTextField(
                  context,
                  controller: emailCtrl,
                  hint: Strings.EMAIL,
                  keyboard: TextInputType.emailAddress,
                  validator: (v) {
                    if (v!.isEmpty) return "Email required";
                    if (!RegExp(
                        r'^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}$')
                        .hasMatch(v)) {
                      return "Enter valid email";
                    }
                    return null;
                  },
                ),

                _buildTextField(
                  context,
                  controller: mobileCtrl,
                  hint: Strings.MOBILE_NUMBER,
                  keyboard: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  validator: (v) {
                    if (v!.isEmpty) return "Mobile number required";
                    if (v.length != 10) return "Enter valid 10-digit mobile number";
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
                    if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&]).{8,}$').hasMatch(v)) {
                      return "Password must be 8+ chars with letters, numbers & special char";
                    }
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
                    if (v != passwordCtrl.text) return "Passwords do not match";
                    return null;
                  },
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => MapScreen())).then((value){
                      if(value != null){
                        addressCtrl.text = value['address'];
                        lat=value['lat'];
                        long=value['lng'];
                      }

                    });
                  },
                  child: IgnorePointer(
                    child: _buildTextField(
                      readOnly: true,
                      context,
                      controller: addressCtrl,
                      hint: Strings.RESTURANT_ADDRESS,
                      validator: (v) =>
                      v!.isEmpty ? "Restaurant address required" : null,
                    ),
                  ),
                ),
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
                        if (!_validateImage()) return;

                        final registrationData = RegistrationData(
                          fullName: restaurantCtrl.text,
                          email: emailCtrl.text,
                          phoneNumber: mobileCtrl.text,
                          password: passwordCtrl.text,
                          profileImage: selectedImage,
                        );

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BusinessScreen(
                              registrationData: registrationData,
                            ),
                          ),
                        );
                      }
                    },
                    child: Text(
                      Strings.CONTINUE_VERIFICATION,
                      style: theme.textTheme.titleMedium!
                          .copyWith(color: theme.primaryColor),
                    ),
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
        bool? readOnly = false,
        List<TextInputFormatter>? inputFormatters,
      }) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: Constant.SIZE_15),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        validator: validator,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          labelText: hint,
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
          labelText: hint,
          suffixIcon: IconButton(
            icon:
            Icon(visible ? Icons.visibility : Icons.visibility_off),
            onPressed: toggleVisibility,
          ),
        ),
      ),
    );
  }
}
