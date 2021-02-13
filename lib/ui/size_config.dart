import 'package:flutter/widgets.dart';

/// Automatically scale the UI to any screen size:
/// https://medium.com/flutter-community/flutter-effectively-scale-ui-according-to-different-screen-sizes-2cb7c115ea0a
///
/// How to use
/// 1. Import this file
/// 2. Put this as first line of build(): SizeConfig().init(context);
/// 3. SizeConfig.h * double for horizontal or SizeConfig.v * double for vertical
class SizeConfig {
  const SizeConfig();

  static bool _initialized = false;

  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;

  /// horizontal
  static double h;

  /// vertical
  static double v;

  static double _safeAreaHorizontal;
  static double _safeAreaVertical;

  /// Horizontal size configuration that takes into account
  /// the device's safe area.
  static double safeH;

  /// Vertical size configuration that takes into account
  /// the device's safe area.
  static double safeV;

  void init(BuildContext context) {
    if (_initialized) return;
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    h = screenWidth / 100;
    v = screenHeight / 100;
    _initialized = true;
  }

  /// Initialize the size configurations taking into account
  /// the device's safe area.
  void initSafely(BuildContext context) {
    _safeAreaHorizontal =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical =
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    safeH = (screenWidth - _safeAreaHorizontal) / 100;
    safeV = (screenHeight - _safeAreaVertical) / 100;
  }
}
