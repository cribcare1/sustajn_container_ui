import 'package:lottie/lottie.dart';
import 'package:sustajn_customer/auth/dashboard_screen/dashboard.dart';

import '../auth/dashboard_screen/home_screen.dart';
import '../auth/screens/login_screen.dart';
import '../constants/imports_util.dart';
import '../constants/number_constants.dart';
import '../constants/string_utils.dart';
import '../utils/nav_utils.dart';
import '../utils/shared_preference_utils.dart';

class AccountSuccessScreen extends StatefulWidget {
  const AccountSuccessScreen({Key? key}) : super(key: key);

  @override
  State<AccountSuccessScreen> createState() => _AccountSuccessScreenState();
}

class _AccountSuccessScreenState extends State<AccountSuccessScreen> {
  int? userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    userId = await SharedPreferenceUtils.getIntValuesSF(
      Strings.USER_ID,
    );
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted || userId == null || userId == -1) return;
    NavUtil.navigationToWithReplacement(context,
      HomeScreen(userId: userId!));
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
                'assets/lottie/lottie_animation.json',
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
