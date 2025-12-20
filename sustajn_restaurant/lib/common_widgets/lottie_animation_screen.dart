import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieMessageScreen extends StatefulWidget {
  final String animation;
  final String title;
  final String subtitle;
  final Widget nextScreen;

  const LottieMessageScreen({
    super.key,
    required this.animation,
    required this.title,
    required this.subtitle,
    required this.nextScreen,
  });

  @override
  State<LottieMessageScreen> createState() => _LottieMessageScreenState();
}

class _LottieMessageScreenState extends State<LottieMessageScreen> {

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => widget.nextScreen),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(widget.animation, height: 200),
              const SizedBox(height: 20),
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                widget.subtitle,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
