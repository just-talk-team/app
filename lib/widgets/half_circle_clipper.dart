import 'package:flutter/material.dart';

class CustomHalfCircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path()
      // path starts with (0.0, 0.0) point (1)
      ..moveTo(0,size.height)
      ..lineTo(0, size.height/4)
      ..quadraticBezierTo(size.width / 2, -size.height/100, size.width, size.height/4)
       ..lineTo(size.width, size.height)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
