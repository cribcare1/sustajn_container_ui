import 'package:lottie/lottie.dart';
import '../auth/screens/dashboard/dashboard_screen.dart';
import '../auth/screens/login_screen.dart';
import '../constants/imports_util.dart';
import '../constants/number_constants.dart';
import '../constants/string_utils.dart';
import '../utils/nav_utils.dart';
import '../utils/sharedpreference_utils.dart';

class AccountSuccessScreen extends StatefulWidget {
  final String message;
  const AccountSuccessScreen({Key? key, required this.message}) : super(key: key);

  @override
  State<AccountSuccessScreen> createState() => _AccountSuccessScreenState();
}

class _AccountSuccessScreenState extends State<AccountSuccessScreen> {

  @override
  void initState() {
    super.initState();
    _showDashboardScreen();
  }

  Future<void> _showDashboardScreen() async {
    await Future.delayed(const Duration(seconds: 3));
    NavUtil.navigationToWithReplacement(context,
        DashboardScreen());
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
                'assets/animations/lottie_animation.json',
                height: Constant.CONTAINER_SIZE_160,
                repeat: false,
              ),
              SizedBox(height: Constant.CONTAINER_SIZE_20),
              Text(
                widget.message,
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
