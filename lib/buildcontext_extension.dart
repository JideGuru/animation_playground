import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;

  double get screenWidthFraction => screenWidth / 100;

  bool get isMobile => screenWidth < 600;
}
