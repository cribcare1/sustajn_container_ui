import 'package:container_tracking/auth/screens/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:container_tracking/utils/SharedPreferenceUtils.dart';
import 'package:flutter/material.dart';

import 'auth/screens/intro_screen.dart';
import 'auth/screens/login_screen.dart';
import 'constants/string_utils.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    _checkLoginAndNavigate();
    super.initState();
  }
  Future<void> _checkLoginAndNavigate() async {
    bool? isLoggedIn = await SharedPreferenceUtils.getBoolValuesSF(Strings.IS_LOGGED_IN);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => isLoggedIn == true ? HomeScreen() : WelcomeScreen(),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}
