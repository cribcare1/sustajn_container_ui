import 'package:sustajn_customer/auth/dashboard_screen/widgets/header.dart';
import 'package:sustajn_customer/auth/screens/map_screen.dart';

import '../../constants/imports_util.dart';
import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../../models/login_model.dart';
import '../../notification/notification_screen.dart';
import '../../profile_screen/profile_screen.dart';
import '../../search_resturant_screen/search_resturant_screen.dart';
import '../../utils/nav_utils.dart';
import '../../utils/theme_utils.dart';
import '../../utils/utils.dart';
import '../screens/save_home_address.dart';

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
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        leading:  Padding(
          padding:  EdgeInsets.only(left:Constant.SIZE_10),
          child: InkWell(
            onTap: (){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context)=> MyProfileScreen()));
            },
            child: CircleAvatar(
              radius: Constant.CONTAINER_SIZE_20,
              backgroundColor: Constant.grey,
              child: Icon(Icons.person, size: Constant.CONTAINER_SIZE_35, color: theme.primaryColor),
            ),
          ),
        ),
        title:  Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hi,', style: theme.textTheme.titleMedium?.copyWith(
                  color: Constant.subtitleText, fontSize: Constant.LABEL_TEXT_SIZE_14)),
              Text(loginResponse?.fullName??"",
                  maxLines: Constant.MAX_LINE_1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleLarge?.copyWith(
                  color: Constant.profileText, fontSize: Constant.LABEL_TEXT_SIZE_20,
                  fontWeight: FontWeight.w600)),
            ],
          ),
        ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: Constant.CONTAINER_SIZE_12),
              child: Row(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_26),
                    onTap: () {
                      NavUtil.navigateToPushScreen(context, MapScreen());
                    },
                    child: Container(
                      padding: EdgeInsets.all(Constant.SIZE_08),
                      decoration: BoxDecoration(
                        color: Constant.grey.withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(color: Constant.grey.withOpacity(0.2)),
                      ),
                      child: Icon(
                        Icons.search,
                        color: Constant.subtitleText,
                        size: Constant.CONTAINER_SIZE_22,
                      ),
                    ),
                  ),
                  SizedBox(width: Constant.SIZE_10),
                  InkWell(
                    borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_26),
                    onTap: () {
                      Utils.navigateToPushScreen(context, NotificationScreen());
                    },
                    child: Container(
                      padding: EdgeInsets.all(Constant.SIZE_08),
                      decoration: BoxDecoration(
                        color: Constant.grey.withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(color: Constant.grey.withOpacity(0.2)),
                      ),
                      child: Icon(
                        Icons.notifications_none,
                        color: Constant.subtitleText,
                        size: Constant.CONTAINER_SIZE_22,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

      ),
      body: SafeArea(
        child: Column(
          children: [
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
