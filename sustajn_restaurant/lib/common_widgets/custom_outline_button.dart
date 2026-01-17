import 'package:flutter/material.dart';

class CustomOutlineButton extends StatelessWidget {
  final String title;
  final IconData? icon;
  final VoidCallback onTap;
  final Color? color;

  const CustomOutlineButton({
    super.key,
    required this.title,
    this.icon,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColor = color ?? theme.secondaryHeaderColor;

    final style = OutlinedButton.styleFrom(
      side: BorderSide(color: borderColor),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
    );

    return SizedBox(
      width: double.infinity,
      child: icon != null
          ? OutlinedButton.icon(
              style: style,
              icon: Icon(icon, color: borderColor),
              label: Text(
                title,
                style: TextStyle(
                  color: borderColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: onTap,
            )
          : OutlinedButton(
              style: style,
              onPressed: onTap,
              child: Text(
                title,
                style: TextStyle(
                  color: borderColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
    );
  }
}
