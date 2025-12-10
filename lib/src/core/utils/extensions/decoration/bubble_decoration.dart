import 'package:flutter/material.dart';

class BubbleDecorationPaint extends CustomPainter {
  final Color color;
  final bool isUser;

  BubbleDecorationPaint({
    required this.color,
    required this.isUser,
  });

  final double _radius = 8.0;

  @override
  void paint(Canvas canvas, Size size) {
    var h = size.height;
    var w = size.width;

    if (isUser) {
      var path = Path();

      /// starting point
      path.moveTo(_radius * 2, 0);

      /// top-left corner
      path.quadraticBezierTo(0, 0, 0, _radius * 1.5);

      /// left line
      path.lineTo(0, h - _radius * 1.5);

      /// bottom-left corner
      path.quadraticBezierTo(0, h, _radius * 2, h);

      /// bottom line
      path.lineTo(w - _radius * 3, h);

      /// bottom-right bubble curve
      path.quadraticBezierTo(
          w - _radius * 1.5, h, w - _radius * 1.5, h - _radius * 0.6);

      /// bottom-right tail curve 1
      path.quadraticBezierTo(w - _radius * _radius, h, w + _radius, h);

      /// bottom-right tail curve 2
      path.quadraticBezierTo(
          w - _radius * 0.8, h, w - _radius, h - _radius * 1.5);

      /// right line
      path.lineTo(w - _radius, _radius * 1.5);

      /// top-right curve
      path.quadraticBezierTo(w - _radius, 0, w - _radius * 3, 0);

      canvas.clipPath(path);
      canvas.drawRRect(
          RRect.fromLTRBR(0, 0, w, h, Radius.zero),
          Paint()
            ..color = color
            ..style = PaintingStyle.fill);
    } else {
      var path = Path();

      /// starting point
      path.moveTo(_radius * 3, 0);

      /// top-left corner
      path.quadraticBezierTo(_radius, 0, _radius, _radius * 1.5);

      /// left line
      path.lineTo(_radius, h - _radius * 1.5);

      path.quadraticBezierTo(_radius * .8, h, -10, h);

      path.quadraticBezierTo(
          _radius * _radius, h, _radius * 1.5, h - _radius * 0.6);

      /// bottom-left bubble curve
      path.quadraticBezierTo(_radius * 1.5, h, _radius * 3, h);

      /// bottom line
      path.lineTo(w - _radius * 2, h);

      /// bottom-right curve
      path.quadraticBezierTo(w, h, w, h - _radius * 1.5);

      /// right line
      path.lineTo(w, _radius * 1.5);

      /// top-right curve
      path.quadraticBezierTo(w, 0, w - _radius * 2, 0);
      canvas.clipPath(path);
      canvas.drawRRect(
          RRect.fromLTRBR(0, 0, w, h, Radius.zero),
          Paint()
            ..color = color
            ..style = PaintingStyle.fill);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
