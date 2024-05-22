

import 'package:flutter/material.dart';

class CancelButtonSplashClip extends ShapeBorder {
  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    final halfHeight = rect.height / 2;

    final path = Path();
    path.moveTo(rect.left + 20, rect.top);
    path.lineTo(rect.left + 5, rect.top + halfHeight - 5);
    path.quadraticBezierTo(rect.left, rect.top + halfHeight, rect.left + 5,
        rect.top + halfHeight + 5);
    path.lineTo(rect.left + 20, rect.bottom);
    path.lineTo(rect.right - 5, rect.bottom);
    path.lineTo(rect.right - 5, rect.top);
    path.lineTo(rect.left + 20, rect.top);

    path.close();
    return path;
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final halfHeight = rect.height / 2;

    final path = Path();
    path.moveTo(rect.left + 20, rect.top);
    path.lineTo(rect.left + 5, rect.top + halfHeight - 5);
    path.quadraticBezierTo(rect.left, rect.top + halfHeight, rect.left + 5,
        rect.top + halfHeight + 5);
    path.lineTo(rect.left + 20, rect.bottom);
    path.lineTo(rect.right - 5, rect.bottom);
    path.lineTo(rect.right - 5, rect.top);
    path.lineTo(rect.left + 20, rect.top);

    path.close();
    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => this;
}
