import 'dart:ui';

class ScreenUtil {
  static final FlutterView view = PlatformDispatcher.instance.views.first;
  static final Size _mediaQuery = view.physicalSize / view.devicePixelRatio;

  static double get screenWidth => _mediaQuery.width;
  static double get screenHeight => _mediaQuery.height;

  /// Adjust font scale based on screen width
  static double get scaleFactor {
    if (screenWidth > 1200) {
      return 1.3;  // Large screens (e.g., tablets)
    } else if (screenWidth > 800) {
      return 1.1;  // Medium screens (e.g., larger phones)
    } else {
      return 1.0;  // Default for mobile
    }
  }

  /// Responsive font size
  static double responsiveFontSize(double baseSize) {
    return baseSize * scaleFactor;
  }
}
