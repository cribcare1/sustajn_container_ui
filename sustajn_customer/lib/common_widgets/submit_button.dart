
import 'package:flutter/material.dart';

import '../constants/number_constants.dart';

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
    return ElevatedButton(
      onPressed: onRightTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFD1AE31), // Gold color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 0,
        padding:  EdgeInsets.symmetric(vertical: Constant.CONTAINER_SIZE_12),
      ),
      child: Text(
        rightText!,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
