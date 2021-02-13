import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class CrashlyticsService {
  // https://firebase.flutter.dev/docs/crashlytics/usage
  static Future<void> initCrashlytics() async {
    if (kDebugMode) {
      // Force disable Crashlytics collection while doing every day development.
      // Temporarily toggle this to true if you want to test crash reporting in your app.
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    }

    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  }

  /// Force a crash to test that crashlytics is working.
  static Future<void> crash() async {
    FirebaseCrashlytics.instance.crash();
  }
}
