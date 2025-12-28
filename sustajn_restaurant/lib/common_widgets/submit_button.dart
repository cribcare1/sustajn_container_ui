import 'package:flutter/material.dart';

import '../constants/number_constants.dart';
import '../utils/theme_utils.dart';

class SubmitButton extends StatelessWidget {
  final String? rightText;
  final VoidCallback onRightTap;

  const SubmitButton({
    super.key,
    this.rightText="Submit",
    required this.onRightTap,
  });

  @override
  Widget build(BuildContext context) {
    var themeData = CustomTheme.getTheme(true);
    return ElevatedButton(
      onPressed: onRightTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFD1AE31), // Gold color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.white)
        ),
        elevation: 0,
        padding:  EdgeInsets.symmetric(vertical: Constant.CONTAINER_SIZE_12),
      ),
      child: Text(
        rightText!,
        style: TextStyle(
          color:themeData!.scaffoldBackgroundColor ,
          fontSize: 15,
        ),
      ),
    );
  }
}
