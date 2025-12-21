import 'package:container_tracking/constants/number_constants.dart';
import 'package:flutter/material.dart';

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
              side:  BorderSide(color: Theme.of(context).secondaryHeaderColor, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding:  EdgeInsets.symmetric(vertical: Constant.CONTAINER_SIZE_12),
            ),
            child: Text(
              leftText!,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(color:Theme.of(context).secondaryHeaderColor)
            ),
          ),
        ),

         SizedBox(width: Constant.CONTAINER_SIZE_12),

        // RIGHT FILLED BUTTON
        Expanded(
          child: ElevatedButton(
            onPressed: onRightTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).secondaryHeaderColor, // Gold color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 0,
              padding:  EdgeInsets.symmetric(vertical: Constant.CONTAINER_SIZE_12),
            ),
            child: Text(
              rightText!,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(color:Theme.of(context).primaryColor)
            ),
          ),
        ),
      ],
    );
  }
}
