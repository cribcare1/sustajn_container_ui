import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  final String? title;
  final Widget child;

  const SummaryCard({
    super.key,
    this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
          color: Color(0xffFFFFFF),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 5),
                blurRadius: 9,
                color: Colors.grey.shade200,
                spreadRadius: 0),
          ]),
      child: child,
    );
  }
}