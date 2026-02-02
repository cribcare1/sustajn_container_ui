import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sustajn_restaurant/auth/screens/login_screen.dart';
import 'package:sustajn_restaurant/utils/nav_utils.dart';

import 'package:sustajn_restaurant/utils/sharedpreference_utils.dart';
import 'package:sustajn_restaurant/utils/theme_utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/network_urls.dart';
import '../constants/number_constants.dart';
import '../constants/string_utils.dart';
import '../models/login_model.dart';

class Utils {


  static  showProfilePhotoBottomSheet(BuildContext context) {
    final theme = CustomTheme.getTheme(true);
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      backgroundColor: theme!.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: Constant.CONTAINER_SIZE_20,
              horizontal: Constant.CONTAINER_SIZE_20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        "Choose",
                        style: TextStyle(
                          fontSize: Constant.LABEL_TEXT_SIZE_18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                        ),
                      ),
                    ),

                    InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_20),
                      child: Container(
                        height: Constant.CONTAINER_SIZE_36,
                        width: Constant.CONTAINER_SIZE_36,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.clear,
                          size: Constant.CONTAINER_SIZE_20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: Constant.CONTAINER_SIZE_20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    _optionButton(
                      context,
                      icon: Icons.camera_alt_outlined,
                      label: "Camera",
                      color: Colors.white70,
                      iconColor: theme.primaryColor,
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),

                    _optionButton(
                      context,
                      icon: Icons.image_outlined,
                      label: "Gallery",
                      color: Colors.white70,
                      iconColor: theme.primaryColor,
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),

                    _optionButton(
                      context,
                      icon: Icons.delete_outline,
                      label: "Remove",
                      color: Colors.white70,
                      iconColor: Colors.red,
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),

                SizedBox(height: Constant.CONTAINER_SIZE_20),
              ],
            ),
          ),
        );
      },
    );
  }

  static Future<File?> uploadImage(BuildContext context) async {
    final theme = CustomTheme.getTheme(true);
    final ImagePicker picker = ImagePicker();

    return await showModalBottomSheet<File?>(
      context: context,
      isScrollControlled: false,
      backgroundColor: theme!.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: Constant.CONTAINER_SIZE_20,
              horizontal: Constant.CONTAINER_SIZE_20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        Strings.CHOOSE,
                        style: TextStyle(
                          fontSize: Constant.LABEL_TEXT_SIZE_18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_20),
                      child: Container(
                        height: Constant.CONTAINER_SIZE_36,
                        width: Constant.CONTAINER_SIZE_36,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.clear,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Constant.CONTAINER_SIZE_20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _optionButton(
                      context,
                      icon: Icons.camera_alt_outlined,
                      label: Strings.CAMERA,
                      color: Colors.white70,
                      iconColor: theme.primaryColor,
                      onTap: () async {
                        final XFile? image =
                        await picker.pickImage(source: ImageSource.camera);

                        if (image != null) {
                          Navigator.pop(context, File(image.path));
                        } else {
                          Navigator.pop(context);
                        }
                      },
                    ),
                    _optionButton(
                      context,
                      icon: Icons.image_outlined,
                      label: Strings.GALLERY,
                      color: Colors.white70,
                      iconColor: theme.primaryColor,
                      onTap: () async {
                        final XFile? image =
                        await picker.pickImage(source: ImageSource.gallery);

                        if (image != null) {
                          Navigator.pop(context, File(image.path));
                        } else {
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ],
                ),

                SizedBox(height: Constant.CONTAINER_SIZE_20),
              ],
            ),
          ),
        );
      },
    );
  }
  static String maskEmail(String email) {
    if (email.isEmpty || !email.contains('@')) {
      return email;
    }

    final parts = email.split('@');
    final localPart = parts[0];
    final domainPart = parts[1];

    if (localPart.length <= 4) {
      return email;
    }

    final maskedLength = localPart.length - 4;
    final masked = List.filled(maskedLength, '*').join();

    return '${localPart.substring(0, 4)}$masked@$domainPart';
  }
  static  logOutDialog(
      BuildContext context,
      IconData icon,
      String title,
      String subTitle,
      String stayButtonText,
      String noButton
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
                  color:Colors.grey.withOpacity(0.1),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(14)
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
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                       Navigator.pop(context);
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
                        noButton,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: Constant.gold,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: Constant.CONTAINER_SIZE_12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        SharedPreferenceUtils.clearAll();
                        NavUtil.navigateToWithReplacement(context, LoginScreen());

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
                        stayButtonText,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: Colors.white,
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

  static Future<bool> displayDialog(
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
                  color: theme.primaryColor,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(12)
                ),
                child: Icon(
                  icon,
                  size: Constant.CONTAINER_SIZE_40,
                  color: Constant.gold,
                ),
              ),
              SizedBox(height: Constant.CONTAINER_SIZE_12),
              Text(title,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  // fontWeight: FontWeight.w600,
                ),),
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
                        stayButtonText,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.scaffoldBackgroundColor,
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

 static  Widget _optionButton(
     BuildContext context, {
       required IconData icon,
       required String label,
       required Color color,
       required Color iconColor,
       required VoidCallback onTap,
     }) {
   return Flexible(
     child: InkWell(
       onTap: onTap,
       borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_15),
       child: Column(
         children: [
           Container(
             height: Constant.CONTAINER_SIZE_80,
             width: Constant.CONTAINER_SIZE_80,
             decoration: BoxDecoration(
               color: color,
               borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_15),
             ),
             alignment: Alignment.center,
             child: Icon(
               icon,
               size: Constant.CONTAINER_SIZE_35,
               color: iconColor,
             ),
           ),
           SizedBox(height: Constant.CONTAINER_SIZE_10),
           Text(
             label,
             style: TextStyle(fontSize: Constant.LABEL_TEXT_SIZE_14,
             color: Colors.white),
           )
         ],
       ),
     ),
   );
  }

  static showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG);
  }

  static isReqSuccess(var response) {
    if ((response.statusCode < 200 || response.statusCode >= 300)) {
      return false;
    } else {
      return true;
    }
  }
  static void printLog(String message) {
    print(message);
  }
  static String? token = "";
  static void getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString(Strings.JWT_TOKEN);
    printLog("JWT Token ==== $token");
  }

  static String authToken() {
    if (token == null || token!.isEmpty) {
      getToken();
    }
    return (token != null && token!.isNotEmpty) ? token! : "";
  }

  static int? userId = 0;
  static void loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt(Strings.USER_ID);
    printLog("JWT Token ==== $token");
  }

  static int getUserId() {
    if (userId == 0) {
      loadUserId();
    }
    return userId!;
  }
  static showNetworkErrorToast(BuildContext context, var errorCode) {
    Utils.printLog("Exception:::: $errorCode");
    const error = "Error:";
    if (errorCode.contains(error)) {
      final startIndex = errorCode.indexOf(error);
      errorCode = errorCode
          .substring(startIndex + error.length, errorCode.length)
          .trim();
      Utils.printLog("exception code:::: $errorCode");
    }
    switch (errorCode) {
      case "${NetworkUrls.NETWORK_CALL_FAILED_CODE}":
        showCustomSnackBar( context: context, message: Strings.EMPTY_DATA_SERVER_MSG, color: Colors.red);
        break;
      case "${NetworkUrls.TIME_OUT_CODE}":
        showCustomSnackBar( context: context, message: Strings.TIME_OUT_ERROR_MSG, color: Colors.red);
        break;
      case "${NetworkUrls.EMPTY_RESPONSE_CODE}":
        showCustomSnackBar( context: context, message: Strings.EMPTY_DATA_SERVER_MSG, color: Colors.red);
        break;
      case "${NetworkUrls.UNAUTHORIZED_ERROR_CODE}":
        showCustomSnackBar( context: context, message: Strings.SESSION_EXPIRED_MSG, color: Colors.red);
        // sessionExpired(context);
        break;
      default:
        showCustomSnackBar( context: context, message: Strings.API_ERROR_MSG_TEXT, color: Colors.red);
        break;
    }
  }
  static multipartParams(var partUrl, var data, var requestKey, var image) {
    return {
      NetworkUrls.PART_URL: partUrl,
      NetworkUrls.DATA: data,
      NetworkUrls.REQUEST_KEY: requestKey,
      if (image != null) NetworkUrls.IMAGE: image,
    };
  }

  static LoginModel? loginData;
  static int? societyId = 0;
  // static int? userId = 0;

  static Future<LoginModel?> getProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = prefs.getString(Strings.PROFILE_DATA);
    printLog("Profile Data ==== $data");
    if (data != null) {
      var response = json.decode(data);
      loginData = LoginModel.fromJson(response);
      // userId = loginData!.data!.userId;
    }
    return null;
  }

  static Future<String?> getDeviceToken() async {
    final fcm = FirebaseMessaging.instance;
    await fcm.requestPermission();
    final token = await fcm.getToken();
    if (token != null && token.isNotEmpty) {
      printLog("DEVICE TOKEN: $token");
      return token;
    }
    printLog("DEVICE TOKEN NOT FOUND");

    return null;
  }

  static Future<void> sendEmail(String email) async {
    final Uri uri = Uri(
      scheme: 'mailto',
      path: email,
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  static String? validateEmailId(String? value) {
    if (value == null || value
        .trim()
        .isEmpty) {
      return 'Enter email address';
    }
    if (!RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    ).hasMatch(value)) {
      return 'Enter valid email address';
    }
    return null;
  }


  static String? validateMobile(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter mobile number';
    }
    if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
      return 'Enter valid 10 digit mobile number';
    }
    return null;
  }

  static String? validateTradeLicense(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter trade license number';
    }
    if (value.length < 5) {
      return 'Trade license number is too short';
    }
    return null;
  }

  static String? validateTaxNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter VAT / Tax number';
    }
    if (!RegExp(r'^[A-Z0-9]{8,15}$').hasMatch(value)) {
      return 'Enter valid VAT / Tax number';
    }
    return null;
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static Widget buildTextField(
      BuildContext context, {
        required TextEditingController controller,
        required String label,
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
        autofocus: false,
        style: TextStyle(color: Colors.white70),
        cursorColor: Colors.white70,
        validator: validator,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white70),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
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
}
void showCustomSnackBar({
  required BuildContext context,
  required String message,
  required Color color,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style:  TextStyle(
          color: Colors.white,
          fontSize: Constant.CONTAINER_SIZE_14,
        ),
      ),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      margin:  EdgeInsets.all(Constant.CONTAINER_SIZE_16),
      // duration: const Duration(seconds: 2),
    ),
  );
}






