import 'package:flutter/cupertino.dart';
import 'package:sustajn_customer/constants/number_constants.dart';

class TopCirclePainter extends CustomPainter {
  final Color color;

  TopCirclePainter({this.color = Constant.gold});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();
    final double radius = size.width * 1.2;
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