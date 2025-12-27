import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sustajn_restaurant/splash_screen.dart';
import 'package:sustajn_restaurant/utils/theme_utils.dart';

@pragma('vm:entry-point')
Future<void> backgroundMessageHandler(RemoteMessage message) async {
  debugPrint("📩 Background Notification Data: ${message.data}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    debugPrint('✅ User granted notification permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    debugPrint('⚠️ User granted provisional permission');
  } else {
    debugPrint('❌ User declined notification permission');
  }
  FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);

  // Foreground message
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    debugPrint('📩 Foreground message received');
    if (message.data.isNotEmpty) {
      debugPrint('Title: ${message.notification?.title}');
      debugPrint('Body: ${message.notification?.body}');
      await backgroundMessageHandler(message);
    }
  });

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Container tracking',
      theme: CustomTheme.getTheme(true),
      home: const SplashScreen(),
    );
  }
}
