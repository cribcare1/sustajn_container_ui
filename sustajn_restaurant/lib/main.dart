import 'dart:ui';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sustajn_restaurant/auth/screens/dashboard/dashboard_screen.dart';
import 'package:sustajn_restaurant/splash_screen.dart';
import 'package:sustajn_restaurant/utils/theme_utils.dart';
import 'package:sustajn_restaurant/utils/utility.dart';
import 'package:upgrader/upgrader.dart';
import 'package:workmanager/workmanager.dart';

import 'auth/screens/dashboard/pi_chart.dart';
import 'auth/screens/map_screen.dart';
import 'firebase_services.dart';
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
@pragma('vm:entry-point')
Future<void> backgroundMessageHandler(RemoteMessage message) async {
  debugPrint("📩 Background Notification Data: ${message.data}");
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
await Upgrader.clearSavedSettings();
  if (Platform.isAndroid) {
    AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
  }

  await Firebase.initializeApp();

  FlutterError.onError =
      FirebaseCrashlytics.instance.recordFlutterFatalError;

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);

  await FirebaseServices().initialize();

  Utils.getProfile();
  Utils.getUserId();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return  AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(

        statusBarColor: Color(0xff0F3727),

        statusBarIconBrightness: Brightness.light,

        statusBarBrightness: Brightness.dark,

        systemNavigationBarColor: Color(0xff0F3727),

        systemNavigationBarIconBrightness:
        Brightness.light,
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Container tracking',
        theme: CustomTheme.getTheme(true),
        home:  SplashScreen(),
      ),
    );
  }
}
