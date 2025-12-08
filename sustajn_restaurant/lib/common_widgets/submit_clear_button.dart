import 'package:flutter/material.dart';

import '../constants/number_constants.dart';

class SubmitClearButton extends StatelessWidget {
  final String? leftText;
  final String? rightText;
  final VoidCallback onLeftTap;
  final VoidCallback onRightTap;

  const SubmitClearButton({
    super.key,
     this.leftText="Clear",
     this.rightText="Apply",
    required this.onLeftTap,
    required this.onRightTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: onLeftTap,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.amber, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding:  EdgeInsets.symmetric(vertical: Constant.CONTAINER_SIZE_12),
            ),
            child: Text(
              leftText!,
              style: const TextStyle(
                color: Colors.green,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),

         SizedBox(width: Constant.CONTAINER_SIZE_12),

        // RIGHT FILLED BUTTON
        Expanded(
          child: ElevatedButton(
            onPressed: onRightTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD1AE31), // Gold color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
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
          ),
        ),
      ],
    );
  }
}
