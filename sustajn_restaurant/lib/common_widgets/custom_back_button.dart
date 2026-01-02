import 'dart:ui';

import 'package:flutter/material.dart';

import '../constants/number_constants.dart';

class CustomBackButton extends StatefulWidget {
  const CustomBackButton({super.key, });

  // Icon icon;

  @override
  State<CustomBackButton> createState() => _CustomBackButtonState();
}

class _CustomBackButtonState extends State<CustomBackButton> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () {
        setState(() {
          Navigator.pop(context);
        });
      },
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          width: Constant.CONTAINER_SIZE_30,
          height: Constant.CONTAINER_SIZE_30,
          margin: EdgeInsets.all(Constant.SIZE_08),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.01),
            border: Border.all(
              color: Colors.white.withOpacity(0.25),
              width: 0.8,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.01),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Icon(Icons.keyboard_arrow_left, color: Colors.white70),
        ),
      ),
    );
  }
}
