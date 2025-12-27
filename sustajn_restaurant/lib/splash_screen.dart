import 'package:sustajn_restaurant/constants/assets_utils.dart';

import 'constants/imports_util.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<Offset> _logoMoveUpAnimation;
  late Animation<double> _nameFadeAnimation;
  late Animation<Offset> _nameSlideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    /// GIF moves slightly UP
    _logoMoveUpAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -0.15),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    /// App name fades IN
    _nameFadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    /// App name slides UP
    _nameSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    /// Start animation AFTER 1 second
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) _controller.forward();
    });

    /// Navigate after splash
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// GIF Logo (moves up)
            SlideTransition(
              position: _logoMoveUpAnimation,
              child: Image.asset(
                AppAssets.sustajnLogoGif,
                height: Constant.CONTAINER_SIZE_200,
                fit: BoxFit.contain,
              ),
            ),

            /// App Name (appears after 1s)
            FadeTransition(
              opacity: _nameFadeAnimation,
              child: SlideTransition(
                position: _nameSlideAnimation,
                child: Image.asset(
                  AppAssets.sustajnLogoName,
                  height: Constant.CONTAINER_SIZE_70,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
