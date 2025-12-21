import 'package:flutter/cupertino.dart';

class TopCirclePainter extends CustomPainter {
  final Color color;

  TopCirclePainter({this.color = const Color(0xffD4AE37)});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();
    final double radius = size.width * 1.1;
    path.addOval(
      Rect.fromCircle(
        center: Offset(size.width / 2, -radius * 0.7),
        radius: radius,
      ),
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
