import 'package:flutter/material.dart';



class NavUtil {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


  static void navigateToPushScreen(BuildContext context, screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  Future<dynamic> navigateTo(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!
        .pushNamed(routeName, arguments: arguments);
  }


  static void navigateToWithReplacement(
      BuildContext context, StatefulWidget statefulWidget) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => statefulWidget,
      ),
    );
  }

  static void pushAndRemoveUntil(BuildContext context, screen){
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => screen
        ),
        ModalRoute.withName("/Home")
    );
  }

  static void popScreen(BuildContext context, int num){
    int count = 0;
    Navigator.popUntil(context, (route) {
      return count++ == num;
    });
  }


  static void onBackPressed(context) {
    Navigator.of(context).pop();
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