import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart' as picker;
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
import '../lease_receive/lease_receive_notifier.dart';
import '../lease_receive/lease_receive_provider.dart';
import '../models/login_model.dart';
import '../network_provider/network_provider.dart';

class Utils {

  static buildFloatingHeader(BuildContext context) {
    return  Align(
      alignment: Alignment.centerRight,
      child: InkWell(
        onTap: () => Navigator.pop(context),
        child: CircleAvatar(
          radius: Constant.CONTAINER_SIZE_16,
          backgroundColor: Colors.white,
          child: Icon(Icons.clear, color: Colors.black, size: Constant.CONTAINER_SIZE_18),
        ),
      ),
    );
  }

  static showProfilePhotoBottomSheet(BuildContext context) {
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
                          color: Colors.white,
                        ),
                      ),
                    ),

                    InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      borderRadius: BorderRadius.circular(
                        Constant.CONTAINER_SIZE_20,
                      ),
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
      backgroundColor:Colors.transparent,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SafeArea(
            top: false, bottom: true,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                Constant.CONTAINER_SIZE_16,
                Constant.CONTAINER_SIZE_16,
                Constant.CONTAINER_SIZE_16,
                0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Utils.buildFloatingHeader(context),
                  SizedBox(height: Constant.SIZE_08),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(Constant.CONTAINER_SIZE_20),
                    decoration: BoxDecoration(
                      color: theme!.scaffoldBackgroundColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(Constant.CONTAINER_SIZE_16),
                        topRight: Radius.circular(Constant.CONTAINER_SIZE_16),
                      ),
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
                              iconColor: theme!.primaryColor,
                              onTap: () async {
                                final XFile? image = await picker.pickImage(
                                  source: ImageSource.camera,
                                );

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
                                final XFile? image = await picker.pickImage(
                                  source: ImageSource.gallery,
                                );

                                if (image != null) {
                                  Navigator.pop(context, File(image.path));
                                } else {
                                  Navigator.pop(context);
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                ],
              ),
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

  static logOutDialog(
    BuildContext context,
    IconData icon,
    String title,
    String subTitle,
    String stayButtonText,
    String noButton,
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
                      color: Colors.grey.withOpacity(0.1),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      icon,
                      size: Constant.CONTAINER_SIZE_40,
                      color: Constant.gold,
                    ),
                  ),
                  SizedBox(height: Constant.CONTAINER_SIZE_12),
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: Constant.SIZE_05),
                  Text(
                    subTitle,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
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
                          onPressed: ()async {
                             await SharedPreferenceUtils.saveBoolDataInSF(
                                Strings.IS_LOGGED_IN, false);
                             await SharedPreferenceUtils.clearAll();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LoginScreen(),
                              ),
                                  (route) => false,
                            );
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
        ) ??
        false;
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
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      size: Constant.CONTAINER_SIZE_40,
                      color: Constant.gold,
                    ),
                  ),
                  SizedBox(height: Constant.CONTAINER_SIZE_12),
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      // fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: Constant.SIZE_05),
                  Text(
                    subTitle,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
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
        ) ??
        false;
  }

  static Future<void> skipDialog({
    required BuildContext context,
    required IconData icon,

    required String subTitle,
    required String cancelButtonText,
    required String yesButtonText,
    required VoidCallback onCancel,
    required VoidCallback onYes,
  }) async {
    final theme = Theme.of(context);

    await showDialog(
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
                  borderRadius:
                  BorderRadius.circular(Constant.CONTAINER_SIZE_12),
                  border: Border.all(
                    color: Constant.grey.withOpacity(0.1),
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
              Text(
                subTitle,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: Colors.white),
              ),
              SizedBox(height: Constant.CONTAINER_SIZE_12),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onCancel,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFC8B531)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            Constant.CONTAINER_SIZE_12,
                          ),
                        ),
                      ),
                      child: Text(
                        cancelButtonText,
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
                      onPressed: onYes,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Constant.gold,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            Constant.CONTAINER_SIZE_12,
                          ),
                        ),
                      ),
                      child: Text(
                        yesButtonText,
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
    );
  }

  static Widget _optionButton(
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
              style: TextStyle(
                fontSize: Constant.LABEL_TEXT_SIZE_14,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static showToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.white,
      toastLength: Toast.LENGTH_LONG,
      textColor: Colors.black,
      webBgColor: "linear-gradient(#673AB7, #673AB7)",
    );
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

  static String? token = " ";

  static void getToken() async {
     token =
    await SharedPreferenceUtils.getStringValuesSF(
      Strings.JWT_TOKEN,
    );
    printLog("JWT Token ==== $token");
  }

  static Future<String> authToken() async {
    if (token == null || token ==" ") {
      getToken();
    }
    return (token != null && token!.isNotEmpty) ? token! : "";
  }

  static int? userId;
  static int? planId;

  static Future<void> loadUserId() async {
    userId =
    await SharedPreferenceUtils.getIntValuesSF(Strings.USER_ID);

    printLog("User Id ==== $userId");
  }

  static Future<int> getUserId() async {
    if (userId == null || userId == 0) {
      await loadUserId();
    }

    return userId ?? 0;
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
        showCustomSnackBar(
          context: context,
          message: Strings.EMPTY_DATA_SERVER_MSG,
          color: Colors.red,
        );
        break;
      case "${NetworkUrls.TIME_OUT_CODE}":
        showCustomSnackBar(
          context: context,
          message: Strings.TIME_OUT_ERROR_MSG,
          color: Colors.red,
        );
        break;
      case "${NetworkUrls.EMPTY_RESPONSE_CODE}":
        showCustomSnackBar(
          context: context,
          message: Strings.EMPTY_DATA_SERVER_MSG,
          color: Colors.red,
        );
        break;
      case "${NetworkUrls.UNAUTHORIZED_ERROR_CODE}":
        showCustomSnackBar(
          context: context,
          message: Strings.SESSION_EXPIRED_MSG,
          color: Colors.red,
        );
        // sessionExpired(context);
        break;
      default:
        showCustomSnackBar(
          context: context,
          message: Strings.API_ERROR_MSG_TEXT,
          color: Colors.red,
        );
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
  static Future<LoginModel?> getProfile() async {
    var data = await SharedPreferenceUtils
        .getStringValuesSF(
      Strings.PROFILE_DATA,
    );
    printLog("Profile Data ==== $data");
    if (data == null || data.isEmpty) {
      return null;
    }
    try {
      var response = json.decode(data);
      loginData = LoginModel.fromJson(
        response,
      );
      return loginData;
    } catch (e) {
      printLog(
        "Profile Parse Error ==== $e",
      );
      return null;
    }
  }
static  String deviceToken = "";
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
    final Uri uri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  static String? validateEmailId(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter email address';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
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
      padding: EdgeInsets.only(bottom: Constant.SIZE_08),
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
          contentPadding: EdgeInsets.symmetric(
            horizontal: Constant.CONTAINER_SIZE_16,
            vertical: Constant.CONTAINER_SIZE_10,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Constant.SIZE_08),
            borderSide: BorderSide(color: Constant.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_14),
            borderSide: BorderSide(color: Constant.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_14),
            borderSide: BorderSide(color: Color(0xFFD1AE31)),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_14),
            borderSide: BorderSide(color: Constant.grey),
          ),
        ),
      ),
    );
  }

  static Widget getDateTimePicker(
      BuildContext context,
      String labelText,
      TextEditingController controller,
      Function(DateTime) onDateSelected,
      ThemeData theme
      ) {
    return Padding(
      padding: EdgeInsets.only(bottom: Constant.SIZE_15),
      child: GestureDetector(
        onTap: () {
          picker.DatePicker.showDatePicker(
            context,
            showTitleActions: true,
            minTime: DateTime(1900, 1, 1),
            maxTime: DateTime.now(),
            theme: picker.DatePickerTheme(
              headerColor: Constant.gold,
              backgroundColor: theme.primaryColor,
              itemStyle:  TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: Constant.LABEL_TEXT_SIZE_18,
              ),
              doneStyle:  TextStyle( fontSize: Constant.LABEL_TEXT_SIZE_16),
            ),
            onConfirm: (date) {
              final value =
                  "${date.year}-${date.month}-${date.day}";
              controller.text = value;
              onDateSelected(date);
            },
            currentTime: DateTime.now(),
            locale: picker.LocaleType.en,
          );
        },
        child: AbsorbPointer(
          child: TextFormField(
            controller: controller,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: labelText,
              labelStyle: TextStyle(color: Colors.white70),
              suffixIcon: const Icon(Icons.date_range, color: Colors.white70,),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
              ),
              enabledBorder: CustomTheme.roundedBorder(Constant.grey),
              focusedBorder: CustomTheme.roundedBorder(Constant.grey),
            ),
            validator: (value) =>
            value!.isEmpty ? 'Please select date' : null,
          ),
        ),
      ),
    );
  }



  static String formatDob(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.year}";
  }
}

void showCustomSnackBar({
  required BuildContext context,
  required String message,
  required Color color,
}) {
  final mediaQuery = MediaQuery.of(context);

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Center(
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: Constant.CONTAINER_SIZE_14,
          ),
        ),
      ),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
        left: Constant.CONTAINER_SIZE_16,
        right: Constant.CONTAINER_SIZE_16,
        bottom: mediaQuery.size.height / 2 - 40, // center vertically
      ),
      duration: const Duration(seconds: 2),
    ),
  );

}


