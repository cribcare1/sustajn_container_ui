import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sustajn_customer/utils/theme_utils.dart';

import '../constants/number_constants.dart';

class Utility {


  static  showProfilePhotoBottomSheet(BuildContext context) {
    final theme = CustomTheme.getTheme(true);
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      backgroundColor: Colors.white,
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
                        "Profile Photo",
                        style: TextStyle(
                          fontSize: Constant.LABEL_TEXT_SIZE_18,
                          fontWeight: FontWeight.bold,
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
                          color: Colors.grey.shade200,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.clear,
                          size: Constant.CONTAINER_SIZE_20,
                          color: Colors.black54,
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
                      color: theme!.primaryColor.withOpacity(0.10),
                      iconColor: theme.primaryColor,
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),

                    _optionButton(
                      context,
                      icon: Icons.image_outlined,
                      label: "Gallery",
                      color: theme.primaryColor.withOpacity(0.10),
                      iconColor: theme.primaryColor,
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),

                    _optionButton(
                      context,
                      icon: Icons.delete_outline,
                      label: "Remove",
                      color: Colors.red.withOpacity(0.10),
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
              style: TextStyle(fontSize: Constant.LABEL_TEXT_SIZE_14),
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

}