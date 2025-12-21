import 'package:flutter/material.dart';

import '../constants/number_constants.dart';

class CustomBackButton extends StatefulWidget {
  const CustomBackButton({super.key});

  @override
  State<CustomBackButton> createState() => _CustomBackButtonState();
}

class _CustomBackButtonState extends State<CustomBackButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          Navigator.pop(context);
        });
      },
      child:  Icon(
        size: Constant.CONTAINER_SIZE_18,
        Icons.arrow_back_ios,
        color: Colors.white,
      ),
    );
  }
}
