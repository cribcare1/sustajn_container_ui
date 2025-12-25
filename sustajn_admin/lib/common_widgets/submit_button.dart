import 'package:container_tracking/constants/number_constants.dart';
import 'package:flutter/material.dart';

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
        backgroundColor: Theme.of(context).secondaryHeaderColor, // Gold color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 0,
        padding:  EdgeInsets.symmetric(vertical: Constant.CONTAINER_SIZE_12),
      ),
      child: Text(
        rightText!,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(color:Theme.of(context).primaryColor)
      ),
    );
  }
}
