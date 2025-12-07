import 'package:container_tracking/auth/screens/login_screen.dart';
import 'package:container_tracking/auth/screens/sign_up_screen.dart';
import 'package:flutter/material.dart';

import '../../utils/theme_utils.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = CustomTheme.getTheme(true);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Sustajn",
                  style: textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.w300,
                  ),
                ),

                const SizedBox(height: 50),

                SizedBox(
                  height: 55,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => SignUpScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeData!.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      "CREATE AN ACCOUNT",
                      style: textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  height: 55,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => LoginScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD1E5DE),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      "LOGIN",
                      style: textTheme.titleMedium?.copyWith(
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                Text(
                  "By continuing you agree to the Terms &\nConditions of Loopi",
                  textAlign: TextAlign.center,
                  style: textTheme.bodySmall?.copyWith(
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ),
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

