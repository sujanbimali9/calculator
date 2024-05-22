
import 'package:flutter/material.dart';

class CancelButtonClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final halfHeight = size.height / 2;

    final path = Path();
    path.moveTo(20, 0);
    path.lineTo(5, halfHeight - 5);
    path.quadraticBezierTo(0, halfHeight, 5, halfHeight + 5);
    path.lineTo(20, size.height);
    path.lineTo(size.width - 5, size.height);
    path.lineTo(size.width - 5, 0);
    path.lineTo(20, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}