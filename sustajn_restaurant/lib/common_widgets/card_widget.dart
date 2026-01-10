import 'dart:ui';
import 'package:flutter/material.dart';

class GlassSummaryCard extends StatelessWidget {
  final Widget child;

  const GlassSummaryCard({
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
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
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


class SubscriptionCard extends StatelessWidget {
  final Widget child;
  final double padding;

  const SubscriptionCard({
    super.key,
    required this.child,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18), // stronger blur
        child: Container(
          width: double.infinity,
          padding:  EdgeInsets.all(padding),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
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

