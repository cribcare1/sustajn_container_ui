import 'dart:ui';
import 'package:flutter/material.dart';

class CircleCardWidget extends StatelessWidget {
  final Widget child;

  const CircleCardWidget({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18), // stronger blur
        child: Container(
          padding: const EdgeInsets.all(10),
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
          child: child,
        ),
      ),
    );
  }
}

