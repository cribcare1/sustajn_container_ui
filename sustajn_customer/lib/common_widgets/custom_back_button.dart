import 'package:flutter/material.dart';

class CustomBackButton extends StatefulWidget {
  final VoidCallback? onTap;
  const CustomBackButton({super.key, this.onTap});

  @override
  State<CustomBackButton> createState() => _CustomBackButtonState();
}

class _CustomBackButtonState extends State<CustomBackButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:  widget.onTap ?? () => Navigator.pop(context),
      child: const Icon(
        Icons.keyboard_arrow_left,
        color: Colors.white,
      ),
    );
  }
}