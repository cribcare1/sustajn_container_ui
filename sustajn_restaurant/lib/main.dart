import 'dart:io';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sustajn_restaurant/splash_screen.dart';
import 'package:sustajn_restaurant/utils/theme_utils.dart';
import 'package:sustajn_restaurant/utils/utility.dart';
import 'package:upgrader/upgrader.dart';
import 'firebase_options.dart';
import 'firebase_services.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MaterialApp(
    home: Scaffold(
      body: Center(child: Text("App is running")),
    ),
  ));
}

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   await Upgrader.clearSavedSettings();
//
//   if (Platform.isAndroid) {
//     AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
//   }
//
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//
//   // IMPORTANT: DO NOT block app startup
//   runApp(const ProviderScope(child: MyApp()));
//
//   // run Firebase stuff AFTER UI loads
//   Future.microtask(() async {
//     try {
//       await FirebaseServices().initialize();
//     } catch (e) {
//       debugPrint("FirebaseServices init failed: $e");
//     }
//   });
//
//   // background messaging (safe placement)
//   FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);
//
//   FlutterError.onError =
//       FirebaseCrashlytics.instance.recordFlutterFatalError;
//
//   PlatformDispatcher.instance.onError = (error, stack) {
//     FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
//     return true;
//   };
// }

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Color(0xff0F3727),

        statusBarIconBrightness: Brightness.light,

        statusBarBrightness: Brightness.dark,

        systemNavigationBarColor: Color(0xff0F3727),

        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Container tracking',
        theme: CustomTheme.getTheme(true),
        home: SplashScreen(),
      ),
    );
  }
}
