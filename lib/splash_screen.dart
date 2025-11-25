import 'package:flutter/material.dart';

import 'auth/screens/intro_screen.dart';
import 'auth/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    Future.delayed(Duration(seconds: 2)).then((_){
      if(! mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => WelcomeScreen()));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}
