import 'package:flutter/material.dart';

// This file acts similar to a CSS stylesheet with reusable styles

class AppStyles {
  // Colors
  static const Color primaryTextColor = Color(0xFF000000);
  static const Color secondaryTextColor = Color(0xFF0B0B0B);
  static const Color buttonTextColor = Colors.white;
  static const Color inputBackgroundColor = Color(
    0x80000000,
  ); // 50% opacity black

  // Text Styles (like CSS classes)
  static TextStyle getLabelStyle(double fontSize) {
    return TextStyle(
      color: primaryTextColor,
      fontFamily: 'Inter',
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
    );
  }

  static const TextStyle buttonTextStyle = TextStyle(
    color: buttonTextColor,
    fontFamily: 'Inter',
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle inputTextStyle = TextStyle(
    color: Colors.white,
    fontFamily: 'Inter',
    fontSize: 16,
  );

  // Responsive breakpoints (like CSS media queries)
  static const double largeScreenBreakpoint = 991;
  static const double smallScreenBreakpoint = 640;

  // Spacing (like CSS margins/paddings)
  static const double defaultSpacing = 20;
  static const double smallSpacing = 10;
}
