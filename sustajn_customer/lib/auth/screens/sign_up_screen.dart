import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../../main.dart';
import '../../models/register_data.dart';
import '../../network_provider/network_provider.dart';
import '../../provider/login_provider.dart';
import '../../utils/theme_utils.dart';
import '../../utils/utils.dart';
import 'login_screen.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  final int currentStep;
  final RegistrationData? registrationData;
  const SignUpScreen({super.key, this.currentStep = 0,
  this.registrationData});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> with RouteAware {
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
    routeObserver.unsubscribe(this);

    restaurantCtrl.dispose();
    emailCtrl.dispose();
    mobileCtrl.dispose();
    passwordCtrl.dispose();
    confirmPasswordCtrl.dispose();
    addressCtrl.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
  }

  @override
  void didPopNext() {
    FocusManager.instance.primaryFocus?.unfocus();
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

    }
  }

  bool _validateImage() {
    if (selectedImage == null) {
      showCustomSnackBar(
        context: context,
        message: 'Please select a porfile image',
        color: Colors.green,
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authNotifierProvider);

    return SafeArea(
      top: false,bottom: true,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Stack(
          children:[
             SingleChildScrollView(
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
                    SizedBox(height: Constant.CONTAINER_SIZE_20),

                    Center(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(60),
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            useSafeArea: true,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.vertical(top: Radius.circular(16),
                              ),
                            ),
                            builder: (_) => SafeArea(
                              child: Padding(
                                padding:  EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                child: Column(
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
                                    ),],
                                ),
                              ),
                            ),
                          );
                        },
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Constant.gold,
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
                      hint: 'Full Name',
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
                    // InkWell(
                    //   onTap: () {
                    //     Navigator.push(context, MaterialPageRoute(builder: (_) => MapScreen())).then((value){
                    //       if(value != null){
                    //         addressCtrl.text = value['address'];
                    //         lat=value['lat'];
                    //         long=value['lng'];
                    //       }
                    //
                    //     });
                    //   },
                    //   child: IgnorePointer(
                    //     child: _buildTextField(
                    //       readOnly: true,
                    //       context,
                    //       controller: addressCtrl,
                    //       hint: Strings.RESTAURANT_ADDRESS,
                    //       validator: (v) =>
                    //       v!.isEmpty ? "Restaurant address required" : null,
                    //     ),
                    //   ),
                    // ),
                    authState.isLoading?
                    Center(
                      child: CircularProgressIndicator(),)
                        : SizedBox(
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

                            _getNetworkData(authState);
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
                            color: Colors.white,
                            fontSize: Constant.LABEL_TEXT_SIZE_14,
                          ),
                          children: [
                            TextSpan(
                              text: Strings.LOGIN,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color:Constant.gold,
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
          ]
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
        style: TextStyle(color: Colors.white70),
        cursorColor: Colors.white70,
        validator: validator,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white70),
          filled: true,
          fillColor: theme.primaryColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
            borderSide: BorderSide(color: Constant.grey),
          ),
          enabledBorder: CustomTheme.roundedBorder(Constant.grey),
          focusedBorder: CustomTheme.roundedBorder(Constant.grey),
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

  Future<void> _getNetworkData(var registrationState) async {
    try {
      if (!registrationState.isValid) return;
      registrationState.setIsLoading(true);
      FocusScope.of(context).unfocus();
      ref.read(authNotifierProvider).loginData(
        context,
        emailCtrl.text,
        passwordCtrl.text,
      );
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

      final registrationData = RegistrationData(
        fullName: restaurantCtrl.text.trim(),
        email: emailCtrl.text.trim(),
        phoneNumber: mobileCtrl.text.trim(),
        password: passwordCtrl.text,
        profileImage: selectedImage,
        dateOfBirth: null,
        address: addressCtrl.text,
        latitude: lat,
        longitude: long,
      );
      ref.read(
        validateEmail({
          "email": emailCtrl.text,
          "previous": "signUp",
          "registrationData": registrationData,
        }),
      );
    } catch (e) {
      Utils.printLog('Error in Login button: $e');
    }
  }
}


