import 'package:flutter/material.dart';

import '../constants/number_constants.dart';
import '../utils/theme_utils.dart';

class SubmitButton extends StatelessWidget {
  final String rightText;
  final VoidCallback? onRightTap;
  final bool isLoading;

  const SubmitButton({
    super.key,
    this.rightText = "Submit",
    this.onRightTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = CustomTheme.getTheme(true);

    return ElevatedButton(
      onPressed: isLoading ? null : onRightTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFD1AE31),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
          side: const BorderSide(color: Colors.white),
        ),
        elevation: 0,
        padding: EdgeInsets.symmetric(
          vertical: Constant.CONTAINER_SIZE_12,
          horizontal: Constant.CONTAINER_SIZE_10,
        ),
      ),
      child: isLoading
          ? SizedBox(
        height: Constant.CONTAINER_SIZE_22,
        width: Constant.CONTAINER_SIZE_22,
        child: CircularProgressIndicator(
          strokeWidth: 4,
          valueColor: AlwaysStoppedAnimation<Color>(
            Colors.white,
          ),
        ),
      )
          : Text(
        rightText,
        style: TextStyle(
          color: themeData!.scaffoldBackgroundColor,
          fontSize: Constant.CONTAINER_SIZE_15,
        ),
      ),
    );
  }
}

