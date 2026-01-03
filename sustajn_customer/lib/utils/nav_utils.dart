import 'package:flutter/material.dart';
import 'package:sustajn_customer/auth/screens/login_screen.dart';



class NavUtil {
  static final GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();


  static void navigateToPushScreen(BuildContext context, screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }


  static Future<dynamic> navigateTo(Widget screen) {
    return navigatorKey.currentState!.push(
      MaterialPageRoute(builder: (_) => screen),
    );
  }


  static Future<dynamic> navigateWithReplacement(Widget screen) {
    return navigatorKey.currentState!.pushReplacement(
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  static void pushAndRemoveAll(Widget screen) {
    navigatorKey.currentState!.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => screen),
          (route) => false,
    );
  }

  static void popScreen(BuildContext context, int num){
    int count = 0;
    Navigator.popUntil(context, (route) {
      return count++ == num;
    });
  }


  static void pop() {
    navigatorKey.currentState!.pop();
  }


  static void navigationToWithReplacement(
      BuildContext context, dynamic statefulWidget) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => statefulWidget),
          (Route<dynamic> route) => false,
    );
  }
}