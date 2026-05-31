import 'package:flutter/material.dart';

import '../constants/number_constants.dart';

class SubmitClearButton extends StatelessWidget {
  final String? leftText;
  final String? rightText;
  final VoidCallback? onLeftTap;
  final VoidCallback? onRightTap;
  final bool isLoading;

  const SubmitClearButton({
    super.key,
     this.leftText="Clear",
     this.rightText="Apply",
    required this.onLeftTap,
    required this.onRightTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: onLeftTap,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.amber, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
              ),
              padding:  EdgeInsets.symmetric(vertical: Constant.CONTAINER_SIZE_12),
            ),
            child: Text(
              leftText!,
              style:  TextStyle(
                color: Constant.gold,
                fontSize: Constant.LABEL_TEXT_SIZE_15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),

         SizedBox(width: Constant.CONTAINER_SIZE_12),

        // RIGHT FILLED BUTTON
        Expanded(
          child: ElevatedButton(
            onPressed: isLoading ? null : onRightTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD1AE31), // Gold color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
                side: BorderSide(color: Colors.white),
              ),
              elevation: 0,
              padding:  EdgeInsets.symmetric(vertical: Constant.CONTAINER_SIZE_12),
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
              rightText!,
              style:  TextStyle(
                color: theme.scaffoldBackgroundColor,
                fontSize: Constant.LABEL_TEXT_SIZE_15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
