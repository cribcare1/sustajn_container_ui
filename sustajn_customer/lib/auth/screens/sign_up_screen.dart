import 'dart:io';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sustajn_customer/provider/signup_provider.dart';
import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../../main.dart';
import '../../models/register_data.dart';
import '../../network_provider/network_provider.dart';
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
  final dobCtrl = TextEditingController();
  DateTime? selectedDob;
  String? selectedGender;



  bool passwordVisible = false;
  bool confirmPasswordVisible = false;
  double lat = 0.0;
  double long = 0.0;
  String postalCode = '';


  File? selectedImage;
  final ImagePicker _picker = ImagePicker();
  var themeData = CustomTheme.getTheme(true);

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
    dobCtrl.dispose();
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


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final signUpState = ref.watch(signUpNotifier);
    double height = MediaQuery.sizeOf(context).height;

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

                      Text(
                        Strings.SIGN_UP,
                        style: themeData?.textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold, fontSize: Constant.CONTAINER_SIZE_22,
                            color: Colors.white
                        ),
                      ),
                      SizedBox(height: height * 0.005),
                      Text(
                        Strings.SIGN_UP_TTITLE,
                        style: themeData?.textTheme.titleMedium!.copyWith(
                          color: Colors.white,
                        ),
                      ),

                      SizedBox(height: Constant.CONTAINER_SIZE_16),

                      _buildTextField(
                        context,
                        controller: restaurantCtrl,
                        hint: Strings.FULL_NAME,
                        validator: (v) {
                          if (v == null || v.isEmpty) return Strings.RESTAURANT;
                          if (!Strings.alphaNumericWithSpace.hasMatch(v)) {
                            return Strings.SPECIAL_CHAR;
                          }
                          return null;
                        },

                      ),

                      Utils.getDateTimePicker(
                        context,
                        Strings.DOB,
                        dobCtrl,
                            (date) {
                          setState(() {
                            selectedDob = date;
                          });
                        },
                        theme
                      ),


                      _buildGenderDropdown(context),


                      _buildTextField(
                        context,
                        controller: emailCtrl,
                        hint: Strings.EMAIL_ID,
                        keyboard: TextInputType.emailAddress,
                        validator: (v) {
                          if (v!.isEmpty) return Strings.EMAIL_REQ;
                          if (!Strings.email.hasMatch(v)) {
                            return Strings.VALID_EMAIL;
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
                          if (v!.isEmpty) return Strings.MOBILE;
                          if (v.length != 10) return Strings.VALID_MOB;
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
                          if (v!.isEmpty) return Strings.REQUIRED;
                          if (!Strings.password.hasMatch(v)) {
                            return Strings.PASSWORD_MATCH;
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
                          if (v!.isEmpty) return Strings.CONFIRM;
                          if (v != passwordCtrl.text) return Strings.NOT_MATCH;
                          return null;
                        },
                      ),
                      signUpState.isLoading?Center(child: CircularProgressIndicator(
                        color: Constant.gold,
                      ),):SizedBox(
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

                            final registrationData = RegistrationData(
                              fullName: restaurantCtrl.text,
                              email: emailCtrl.text,
                              phoneNumber: mobileCtrl.text,
                              password: passwordCtrl.text,
                              profileImage: selectedImage,
                              dateOfBirth: selectedDob == null
                                  ? null
                                  : Utils.formatDob(selectedDob!),
                              gender: selectedGender,
                              flatDoorHouseDetails: "",
                              areaStreetCityBlockDetails: addressCtrl.text,
                              poBoxOrPostalCode: postalCode,
                              addressType: Strings.HOME,
                              addressStatus: Strings.ACTIVE,

                                latitude: lat,
                                longitude: long,
                                subscriptionPlanId: 1,
                              );

                              signUpState.setRegistrationData(registrationData);
                              _getNetworkDataVerify(signUpState);
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
                                    decorationColor: Constant.gold
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
        TextInputType keyboard = TextInputType.text,
        bool readOnly = false,
        List<TextInputFormatter>? inputFormatters,

        IconData? suffixIcon,
        VoidCallback? onSuffixTap,
      }) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: Constant.SIZE_15),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        readOnly: readOnly,
        style: const TextStyle(color: Colors.white70),
        cursorColor: Colors.white70,
        validator: validator,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white70),
          filled: true,
          fillColor: theme.primaryColor,
          enabledBorder: CustomTheme.roundedBorder(Constant.grey),
          focusedBorder: CustomTheme.roundedBorder(Constant.grey),

          suffixIcon: suffixIcon == null
              ? null
              : IconButton(
            icon: Icon(suffixIcon, color: Colors.white70),
            onPressed: onSuffixTap,
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

  Widget _buildGenderDropdown(BuildContext context) {
    final theme = Theme.of(context);

    final List<String> genderItems = ['Male', 'Female'];

    return Padding(
      padding: EdgeInsets.only(bottom: Constant.SIZE_15),
      child: DropdownButtonFormField2<String>(
        value: selectedGender,
        isExpanded: true,
        decoration: InputDecoration(
          filled: true,
          fillColor: theme.primaryColor,
          hintText: "Select Gender",
          hintStyle: const TextStyle(color: Colors.white70),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
            borderSide: BorderSide(color: Constant.grey),
          ),
          enabledBorder: CustomTheme.roundedBorder(Constant.grey),
          focusedBorder: CustomTheme.roundedBorder(Constant.grey),
        ),
        dropdownStyleData: DropdownStyleData(
          decoration: BoxDecoration(
            color: theme.primaryColor,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        style: const TextStyle(color: Colors.white),
        items: genderItems
            .map(
              (item) => DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        )
            .toList(),
        onChanged: (value) {
          setState(() {
            selectedGender = value;
          });
        },
        validator: (value) {
          if (value == null) {
            return "Please select gender";
          }
          return null;
        },
      ),
    );
  }


  _getNetworkDataVerify(var registrationState) async {
    try {
      if (registrationState.isValid) {
        await ref
            .read(networkProvider.notifier)
            .isNetworkAvailable()
            .then((isNetworkAvailable) async {
          try {
            if (isNetworkAvailable) {
              registrationState.setIsLoading(true);
              registrationState.setContext(context);
              registrationState.setEmail(emailCtrl.text);
              ref.read(getOtpToVerifyProvider({"email": emailCtrl.text, "type":"SIGNUP"}));
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

