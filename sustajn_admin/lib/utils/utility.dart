import 'package:container_tracking/constants/network_urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/number_constants.dart';
import '../constants/string_utils.dart';

class Utils {
  static Future<void> showEditDeleteMenu({
    required BuildContext context,
    required GlobalKey iconKey,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
  }) async {
    final RenderBox renderBox = iconKey.currentContext!.findRenderObject() as RenderBox;
    final Offset position = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;

    await showMenu<void>(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx + size.width - 150,
        position.dy + size.height,
        position.dx,
        0,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
      ),
      elevation: 4,
      items: <PopupMenuEntry<void>>[
        PopupMenuItem<void>(
          height: Constant.CONTAINER_SIZE_40,
          padding:  EdgeInsets.symmetric(horizontal: Constant.CONTAINER_SIZE_12),
          onTap: onEdit,
          child: Row(
            children:  [
              Icon(Icons.edit, size: Constant.LABEL_TEXT_SIZE_18),
              SizedBox(width: Constant.SIZE_10),
              Text(Strings.EDIT),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem<void>(
          height: Constant.CONTAINER_SIZE_40,
          padding:  EdgeInsets.symmetric(horizontal: Constant.CONTAINER_SIZE_12),
          onTap: onDelete,
          child: Row(
            children:  [
              Icon(Icons.delete, size: Constant.CONTAINER_SIZE_18, color: Colors.red),
              SizedBox(width: Constant.SIZE_10),
              Text(Strings.DELETE, style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
    );
  }



  static displayDialog(BuildContext context, IconData icon,String title, String subTitle, String buttonText) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (_) => Dialog(
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
                  color: buttonText == 'Reject' ?
                  Colors.red.withOpacity(0.1) :
                      theme.primaryColor.withOpacity(0.1),
                  // color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: Constant.CONTAINER_SIZE_40,
                  color: buttonText == 'Reject' ? Colors.red :
                  theme.primaryColor,
                ),
              ),
              SizedBox(height: Constant.CONTAINER_SIZE_12),
              Text(title, style: theme.textTheme.titleMedium),
              SizedBox(height: Constant.SIZE_05),
              Text(
                subTitle,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
              SizedBox(height: Constant.CONTAINER_SIZE_12),
              TextField(
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "Remarks*",
                  hintStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: theme.colorScheme.surfaceVariant,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      Constant.CONTAINER_SIZE_12,
                    ),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: Constant.CONTAINER_SIZE_12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                            color: Color(0xFFC8B531)
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            Constant.CONTAINER_SIZE_12,
                          ),
                        ),
                      ),
                      child: Text("Cancel",  style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.primaryColor,
                      ),),
                    ),
                  ),
                  SizedBox(width: Constant.CONTAINER_SIZE_12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonText == 'Reject' ? Colors.red :
                        theme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            Constant.CONTAINER_SIZE_12,
                          ),
                        ),
                      ),
                      child: Text(
                        buttonText,
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
  static String? token = "";
  static void getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString(Strings.JWT_TOKEN);
    printLog("JUT Token ==== $token");
  }

  static String authToken() {
    if (token == null || token!.isEmpty) {
      getToken();
    }
    return (token != null && token!.isNotEmpty) ? token! : "";
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

}
Dio getDio(){
var  dio = Dio();
final token = Utils.authToken();
dio.options.headers = {
  'Authorization': 'Bearer $token',
  'Content-Type': 'application/json',
  'Accept': 'application/json',
};
  return dio;
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
