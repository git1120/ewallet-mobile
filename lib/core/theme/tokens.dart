import 'package:flutter/material.dart';

abstract final class IbaColors {
  static const green = Color(0xFF064E3B);
  static const greenStrong = Color(0xFF033A2C);
  static const greenSoft = Color(0xFFE6F2EE);
  static const gold = Color(0xFFC49A35);
  static const background = Color(0xFFF7F6F1);
  static const surface = Color(0xFFFFFFFF);
  static const ink = Color(0xFF17201D);
  static const muted = Color(0xFF5D6964);
  static const outline = Color(0xFFCBD4D0);
  static const success = Color(0xFF167B4B);
  static const information = Color(0xFF2563A6);
  static const warning = Color(0xFF9A6700);
  static const error = Color(0xFFB42318);
}

abstract final class IbaSpacing {
  static const xxs = 4.0;
  static const xs = 8.0;
  static const sm = 12.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
  static const xxl = 48.0;
}

abstract final class IbaRadii {
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 18.0;
  static const pill = 999.0;
}

abstract final class IbaElevation {
  static const low = 1.0;
  static const medium = 4.0;
}

abstract final class IbaMotion {
  static const fast = Duration(milliseconds: 120);
  static const standard = Duration(milliseconds: 220);
  static const slow = Duration(milliseconds: 360);
}

abstract final class IbaBreakpoints {
  static const compact = 600.0;
  static const medium = 840.0;
  static const expanded = 1200.0;
}

abstract final class IbaTypography {
  static const latinFamily = 'Inter';
  static const arabicFamily = 'NotoNaskhArabic';
}
