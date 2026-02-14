import 'package:lottie/lottie.dart';
import '../auth/screens/dashboard/dashboard_screen.dart';
import '../auth/screens/login_screen.dart';
import '../constants/imports_util.dart';
import '../constants/number_constants.dart';
import '../constants/string_utils.dart';
import '../utils/nav_utils.dart';
import '../utils/sharedpreference_utils.dart';

class ContainerOrderScreen extends StatefulWidget {
  final String title;
  final String subTitle;
  const ContainerOrderScreen({Key? key, required this.title, required this.subTitle}) : super(key: key);

  @override
  State<ContainerOrderScreen> createState() => _ContainerOrderScreenState();
}

class _ContainerOrderScreenState extends State<ContainerOrderScreen> {

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
                widget.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Constant.gold,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                widget.subTitle,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleSmall?.copyWith(
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
