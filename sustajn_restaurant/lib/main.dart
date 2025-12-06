import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sustajn_restaurant/splash_screen.dart';
import 'package:sustajn_restaurant/utils/theme_utils.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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

