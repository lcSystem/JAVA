import 'package:flutter/material.dart';

class AvatarRealisticAssets {
  /// Realistic Face Shape Paths
  static Path getFacePath(String shape, Size size) {
    final center = Offset(size.width / 2, size.height * 0.3);
    final w = size.width * 0.35;
    final h = size.height * 0.45;
    
    switch (shape) {
      case 'ovalado':
        return Path()..addOval(Rect.fromCenter(center: center, width: w, height: h));
      case 'redondo':
        return Path()..addOval(Rect.fromCenter(center: center, width: w * 1.1, height: w * 1.1));
      case 'cuadrado':
        return Path()..addRRect(RRect.fromRectAndRadius(
          Rect.fromCenter(center: center, width: w, height: h), 
          const Radius.circular(30)
        ));
      case 'diamante':
        return Path()
          ..moveTo(center.dx, center.dy - h / 2)
          ..quadraticBezierTo(center.dx + w / 2, center.dy - h / 4, center.dx + w / 2, center.dy)
          ..quadraticBezierTo(center.dx + w / 2, center.dy + h / 4, center.dx, center.dy + h / 2)
          ..quadraticBezierTo(center.dx - w / 2, center.dy + h / 4, center.dx - w / 2, center.dy)
          ..quadraticBezierTo(center.dx - w / 2, center.dy - h / 4, center.dx, center.dy - h / 2)
          ..close();
      case 'corazon':
        return Path()
          ..moveTo(center.dx, center.dy - h / 2)
          ..cubicTo(center.dx + w * 0.6, center.dy - h * 0.6, center.dx + w * 0.6, center.dy, center.dx, center.dy + h / 2)
          ..cubicTo(center.dx - w * 0.6, center.dy, center.dx - w * 0.6, center.dy - h * 0.6, center.dx, center.dy - h / 2)
          ..close();
      case 'largo':
        return Path()..addOval(Rect.fromCenter(center: center, width: w * 0.85, height: h * 1.2));
      default:
        return Path()..addOval(Rect.fromCenter(center: center, width: w, height: h));
    }
  }

  /// Realistic Eye Paths
  static Path getEyePath(Offset center, double width) {
    return Path()
      ..moveTo(center.dx - width / 2, center.dy)
      ..quadraticBezierTo(center.dx, center.dy - width / 4, center.dx + width / 2, center.dy)
      ..quadraticBezierTo(center.dx, center.dy + width / 4, center.dx - width / 2, center.dy)
      ..close();
  }

  /// Detailed Hair Geometry
  static Path getHairPath(String type, Size size) {
    final center = Offset(size.width / 2, size.height * 0.3);
    final w = size.width * 0.35;
    final h = size.height * 0.45;
    final path = Path();
    
    switch (type) {
      case 'liso':
        path.moveTo(center.dx - w/2 - 5, center.dy - h/4);
        path.quadraticBezierTo(center.dx, center.dy - h/2 - 25, center.dx + w/2 + 5, center.dy - h/4);
        path.lineTo(center.dx + w/2 + 10, center.dy + h/2 + 30);
        path.lineTo(center.dx - w/2 - 10, center.dy + h/2 + 30);
        path.close();
        break;
      case 'ondulado':
        path.moveTo(center.dx - w/2 - 15, center.dy);
        path.quadraticBezierTo(center.dx, center.dy - h/2 - 20, center.dx + w/2 + 15, center.dy);
        for(int i=0; i<3; i++) {
           path.relativeQuadraticBezierTo(10, 15, 0, 30);
           path.relativeQuadraticBezierTo(-10, 15, 0, 30);
        }
        path.lineTo(center.dx - w/2 - 15, center.dy + 120);
        path.close();
        break;
      case 'afro':
        path.addOval(Rect.fromCenter(center: Offset(center.dx, center.dy - 15), width: w + 40, height: h + 20));
        break;
      case 'corto':
        path.moveTo(center.dx - w/2 - 5, center.dy);
        path.quadraticBezierTo(center.dx, center.dy - h/2 - 20, center.dx + w/2 + 5, center.dy);
        path.quadraticBezierTo(center.dx + 5, center.dy - 10, center.dx - w/2, center.dy);
        path.close();
        break;
      default:
        path.addOval(Rect.fromCenter(center: Offset(center.dx, center.dy - 20), width: w + 10, height: h / 2));
    }
    return path;
  }
}
