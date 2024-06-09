import 'package:flutter/material.dart';

class WaveClipper extends CustomClipper<Path> {
  final double waveHeight;

  WaveClipper({this.waveHeight = 100.0});

  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - waveHeight);

    // First curve
    var firstControlPoint = Offset(size.width / 4, size.height - waveHeight + waveHeight / 3);
    var firstEndPoint = Offset(size.width / 2, size.height - waveHeight);

    // Second curve
    var secondControlPoint = Offset(size.width * 3 / 4, size.height - waveHeight - waveHeight / 4);
    var secondEndPoint = Offset(size.width, size.height - waveHeight);

    path.quadraticBezierTo(
        firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);
    path.quadraticBezierTo(
        secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
