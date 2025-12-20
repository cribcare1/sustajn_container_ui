import 'package:flutter/material.dart';

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
      child: const Icon(
        Icons.arrow_back,
        color: Colors.black,
      ),
    );
  }
}