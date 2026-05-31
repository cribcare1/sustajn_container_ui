import 'package:flutter/material.dart';
import 'package:sustajn_customer/utils/shared_preference_utils.dart';
import 'auth/dashboard_screen/home_screen.dart';
import 'auth/screens/login_screen.dart';
import 'constants/assets_utils.dart';
import 'constants/string_utils.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _logoFade;
  late Animation<double> _reflectionOpacity;
  late Animation<double> _nameFade;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    );

    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.4, curve: Curves.easeIn)),
    );

    _reflectionOpacity = TweenSequence([
      TweenSequenceItem(tween: ConstantTween<double>(0.4), weight: 50),
      TweenSequenceItem(tween: Tween<double>(begin: 0.4, end: 0.0), weight: 50),
    ]).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.8)),
    );

    _nameFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.75, 1.0, curve: Curves.easeIn)),
    );
    _controller.forward();
    _checkLoginAndNavigate();
  }

  Future<void> _checkLoginAndNavigate() async {
    bool? isLoggedIn = await SharedPreferenceUtils.getBoolValuesSF(
      Strings.IS_LOGGED_IN,
    );
    int? userId = await SharedPreferenceUtils.getIntValuesSF(
      Strings.USER_ID,
    );
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => isLoggedIn == true ? HomeScreen(userId: userId,) : LoginScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final logoSize = size.width * 0.32;
    final reflectionTop = logoSize * 1.05;
    final stackHeight = logoSize * 1.35;
    return Scaffold(
      backgroundColor: const Color(0xFF0E3A2F),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: stackHeight,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  FadeTransition(
                    opacity: _logoFade,
                    child: Image.asset(
                      AppAssets.sustajn_logo,
                      width: logoSize,
                    ),
                  ),
                  Positioned(
                    top: reflectionTop,
                    child: FadeTransition(
                      opacity: _reflectionOpacity,
                      child: ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.white,
                              Colors.white,
                              Colors.transparent,
                            ],
                            stops: [0.0, 0.6, 1.0],
                          ).createShader(bounds);
                        },
                        blendMode: BlendMode.dstIn,
                        child: Transform(
                          alignment: Alignment.topCenter,
                          transform: Matrix4.identity()..scale(1.0, 0.35),
                          child: Opacity(
                            opacity: 0.85,
                            child: Image.asset(
                              AppAssets.sustajn_logo,
                              width: logoSize,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            FadeTransition(
              opacity: _nameFade,
              child: Image.asset(
                AppAssets.sustajnLogoName,
                width: size.width * 0.45,
              ),
            ),
          ],
        ),
      ),
    );
  }

}