import 'package:flutter/material.dart';

import '../../constants/number_constants.dart';

class NoDataFoundCustomText extends StatelessWidget {
  final String text;
  final double fontSize;

  const NoDataFoundCustomText({
    super.key,
    required this.text,
    this.fontSize = Constant.CONTAINER_SIZE_18,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}