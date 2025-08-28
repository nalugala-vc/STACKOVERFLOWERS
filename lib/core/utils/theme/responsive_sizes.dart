import 'package:flutter/material.dart';

class ResponsiveSizes {
  static double _screenWidth = 0;
  static double _screenHeight = 0;

  // Initialize screen dimensions
  static void init(BuildContext context) {
    _screenWidth = MediaQuery.of(context).size.width;
    _screenHeight = MediaQuery.of(context).size.height;
  }

  // Get current screen width
  static double get screenWidth => _screenWidth;

  // Get current screen height
  static double get screenHeight => _screenHeight;

  /// Scale size based on screen width (default base = 390)
  static double _scale(
    double baseSize, {
    double min = 0,
    double max = double.infinity,
  }) {
    double scaled = baseSize * (_screenWidth / 390);
    return scaled.clamp(min, max);
  }

  // Common text/sizes
  static double get size14 => _scale(14, min: 12, max: 16);
  static double get size16 => _scale(16, min: 14, max: 18);
  static double get size18 => _scale(18, min: 15, max: 20);
  static double get size20 => _scale(20, min: 16, max: 22);
  static double get size24 => _scale(24, min: 20, max: 28);
  static double get size32 => _scale(32, min: 26, max: 36);

  // Example for custom fixed values like your 200
  static double get size200 => _scale(200, min: 180, max: 220);

  static double get size100 => (_screenWidth * (100 / 390)).clamp(90.0, 110.0);

  static double get size160 => (_screenWidth * (160 / 390)).clamp(140.0, 180.0);

  static double get size15 => (_screenWidth * (15 / 390)).clamp(13.0, 17.0);

  static double get size25 => (_screenWidth * (25 / 390)).clamp(22.0, 28.0);
}
