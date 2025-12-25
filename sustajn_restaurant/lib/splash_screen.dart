import 'package:flutter/material.dart';
import 'package:sustajn_restaurant/utils/app_permissons.dart';
import 'package:sustajn_restaurant/utils/sharedpreference_utils.dart';

import 'auth/screens/dashboard_screen.dart';
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
    AppPermissions.handleNotificationPermission();
    AppPermissions.handleLocationPermission(context);
    _checkLoginAndNavigate();
    super.initState();
  }
  Future<void> _checkLoginAndNavigate() async {
    bool? isLoggedIn = await SharedPreferenceUtils.getBoolValuesSF(
      Strings.IS_LOGGED_IN,
    );
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => isLoggedIn == true ? DashboardScreen() : LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Image.asset("assets/logo/Sustajn_logo.gif", fit: BoxFit.contain),
      ),
    );
  }
}
