import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sustajn_customer/splash_screen.dart';
import 'package:sustajn_customer/utils/nav_utils.dart';
import 'package:sustajn_customer/utils/theme_utils.dart';

import 'firebase_services.dart';
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

@pragma('vm:entry-point')
Future<void> backgroundMessageHandler(RemoteMessage message) async {
  debugPrint("📩 Background Notification Data: ${message.data}");
}
void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);
  await FirebaseServices().initialize();

  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      child: MaterialApp(
        navigatorObservers: [routeObserver],
        navigatorKey: NavUtil.navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Container tracking',
        theme: CustomTheme.getTheme(true),
        home: const SplashScreen(),
      ),
    );
  }
}
