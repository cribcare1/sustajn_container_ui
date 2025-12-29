import 'package:sustajn_customer/auth/dashboard_screen/widgets/header.dart';

import '../../constants/imports_util.dart';
import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../../models/login_model.dart';
import '../../utils/theme_utils.dart';
import '../../utils/utils.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  String userName = "";
  Data? loginResponse;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    await Utils.getProfile();
    setState(() {
      loginResponse = Utils.loginData?.data;
      isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    final theme = CustomTheme.getTheme(true);

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      backgroundColor: theme!.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            HeaderWidget(name:loginResponse?.fullName??"",),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/img_1.png',
                            height: Constant.CONATAINER_SIZE_380,
                            width: Constant.CONATAINER_SIZE_380,
                          ),

                          SizedBox(height: Constant.CONTAINER_SIZE_12),

                          Text(
                            Strings.DASHBOARD_TEXT,
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: Constant.gold,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          SizedBox(height: Constant.CONTAINER_SIZE_12),

                          Text(
                            Strings.BORROW_REUSABLE_CONTAINERS,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
