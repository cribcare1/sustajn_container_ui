import 'package:flutter/material.dart';
import 'package:sustajn_customer/utils/app_permissions.dart';

import 'auth/screens/login_screen.dart';

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
    Future.delayed(Duration(seconds: 2)).then((_){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
    });
    super.initState();
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
