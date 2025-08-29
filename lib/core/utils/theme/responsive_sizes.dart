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
  static double get size22 => (_screenWidth * (22 / 390)).clamp(19.0, 25.0);
  static double get size36 => (_screenWidth * (36 / 390)).clamp(32.0, 40.0);
  static double get size80 => (_screenWidth * (80 / 390)).clamp(70.0, 90.0);

  // Additional sizes for padding, margins, and icons
  static double get size5 => _scale(5, min: 4, max: 6);
  static double get size6 => _scale(6, min: 5, max: 7);
  static double get size8 => _scale(8, min: 6, max: 10);
  static double get size10 => _scale(10, min: 8, max: 12);
  static double get size12 => _scale(12, min: 10, max: 14);
  static double get size30 => _scale(30, min: 26, max: 34);
  static double get size40 => _scale(40, min: 35, max: 45);
  static double get size60 => _scale(60, min: 50, max: 70);
  static double get size65 => _scale(65, min: 55, max: 75);

  // Hero section height calculation
  static double getHeroHeight(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    // Calculate aspect ratio
    double aspectRatio = screenWidth / screenHeight;

    // Base height percentage
    double heightPercentage = 0.60;

    // Adjust percentage based on aspect ratio
    if (aspectRatio < 0.5) {
      // Very tall devices
      heightPercentage = 0.50;
    } else if (aspectRatio > 0.65) {
      // Wider devices
      heightPercentage = 0.65;
    }

    // Calculate height
    double calculatedHeight = screenHeight * heightPercentage;

    // Ensure minimum and maximum heights
    return calculatedHeight.clamp(500.0, 700.0);
  }
}
