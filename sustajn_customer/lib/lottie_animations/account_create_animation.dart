import 'package:lottie/lottie.dart';

import '../auth/screens/login_screen.dart';
import '../constants/imports_util.dart';
import '../constants/number_constants.dart';

class AccountSuccessScreen extends StatefulWidget {
  const AccountSuccessScreen({Key? key}) : super(key: key);

  @override
  State<AccountSuccessScreen> createState() => _AccountSuccessScreenState();
}

class _AccountSuccessScreenState extends State<AccountSuccessScreen> {

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 5), () {
      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => LoginScreen(),
        ),
            (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Lottie.asset(
                'assets/lottie/success_animation.json',
                height: Constant.CONTAINER_SIZE_160,
                repeat: false,
              ),

              SizedBox(height: Constant.CONTAINER_SIZE_20),

              Text(
                'Account Created Successfully!',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
