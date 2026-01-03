import 'package:flutter/material.dart';

import '../constants/number_constants.dart';

class CustomBackButton extends StatefulWidget {

  final VoidCallback? onTap;
  const CustomBackButton({super.key, this.onTap });

  // Icon icon;

  @override
  State<CustomBackButton> createState() => _CustomBackButtonState();
}

class _CustomBackButtonState extends State<CustomBackButton> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: widget.onTap ?? () => Navigator.pop(context),
      child: Container(
        width: Constant.CONTAINER_SIZE_50,
        height: Constant.CONTAINER_SIZE_50,
        margin: EdgeInsets.all(Constant.SIZE_08),
        decoration: BoxDecoration(
          color: theme.primaryColor,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: Constant.grey, width: 0.3),
        ),
        child: Icon(Icons.arrow_back_ios, color: Colors.white70),
      ),
    );
  }
}