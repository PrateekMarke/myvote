
import 'package:flutter/material.dart';

class MyDeviceUtils {
  /// Check if the app is in Dark Mode
  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  /// Get screen width
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// Get screen height
  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  /// Get device pixel ratio
  static double getPixelRatio(BuildContext context) {
    return MediaQuery.of(context).devicePixelRatio;
  }

  /// Get text scale factor
  static double getTextScaleFactor(BuildContext context) {
    return MediaQuery.of(context).textScaleFactor;
  }

  /// Get safe area padding (top)
  static double getSafeAreaTop(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }

  /// Get safe area padding (bottom)
  static double getSafeAreaBottom(BuildContext context) {
    return MediaQuery.of(context).padding.bottom;
  }

  /// Get responsive height based on percentage
 /// Get responsive height based on percentage, with clamping
static double responsiveHeight(BuildContext context, double percentage) {
  double height = getScreenHeight(context) * percentage;
  return height.clamp(percentage * 500, percentage * 900); // Adjust min/max limits
}

/// Get responsive width based on percentage, with clamping
static double responsiveWidth(BuildContext context, double percentage) {
  double width = getScreenWidth(context) * percentage;
  return width.clamp(percentage * 300, percentage * 600); // Adjust min/max limits
}

/// Get responsive font size based on screen width, with clamping
static double responsiveFontSize(BuildContext context, double baseSize) {
  double scaledSize = baseSize * (getScreenWidth(context) / 375);
  return scaledSize.clamp(baseSize * 0.9, baseSize * 1.2); // Prevents excessive scaling
}
// Limits min & max scale



  /// Check if the device is a tablet
  static bool isTablet(BuildContext context) {
    final double screenWidth = getScreenWidth(context);
    return screenWidth > 600;
  }

  /// Check if the device is in landscape mode
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  static getScaledPadding(BuildContext context, int i) {}

  
}