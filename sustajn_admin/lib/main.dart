import 'package:container_tracking/splash_screen.dart';
import 'package:container_tracking/utils/theme_utils.dart';
import 'package:container_tracking/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Utils.getToken();
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Container tracking',
        theme: CustomTheme.getTheme(true),
        home: const SplashScreen(),
      ),
    );
  }
}
