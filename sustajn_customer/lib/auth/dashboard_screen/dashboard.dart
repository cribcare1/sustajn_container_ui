import 'package:sustajn_customer/auth/dashboard_screen/widgets/header.dart';

import '../../constants/imports_util.dart';
import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../../utils/theme_utils.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = CustomTheme.getTheme(true);

    return Scaffold(
      backgroundColor: theme!.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            HeaderWidget(name: 'John Dee'),
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
