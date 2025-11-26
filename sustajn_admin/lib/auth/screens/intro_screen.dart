import 'package:container_tracking/auth/screens/login_screen.dart';
import 'package:container_tracking/auth/screens/sign_up_screen.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Title
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: const Text(
                "Sustajn",
                style: TextStyle(
                  fontSize: 55,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
Expanded(
  child: Align(
    alignment: Alignment.bottomCenter,
    child: Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: SizedBox(
          height: 55,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => SignUpScreen()));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF78B5A4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              "CREATE AN ACCOUNT",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
      const SizedBox(height: 20),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: SizedBox(
          height: 55,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => LoginScreen()));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD1E5DE),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              "LOGIN",
              style: TextStyle(color: Colors.black54),
            ),
          ),
        ),
      ),
      const SizedBox(height: 30),
    ],),
  ),
),
          Expanded(
            child: Align(
              alignment: Alignment.topCenter,
              child: Text(
                "By continuing you agree to the Terms &\nConditions of Loopi",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ),
          )
        ],
      ),
    );
  }

  //Reusable social icon widget
  static Widget _socialIcon(String path) {
    return CircleAvatar(
      radius: 25,
      backgroundColor: Colors.white,
      child: Image.asset(path, height: 30),
    );
  }
}

