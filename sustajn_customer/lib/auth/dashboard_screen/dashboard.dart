import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/imports_util.dart';
import '../../constants/network_urls.dart';
import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../../models/get_profile_model.dart';
import '../../models/login_model.dart';
import '../../models/signup_model.dart';
import '../../network_provider/network_provider.dart';
import '../../notification/notification_screen.dart';
import '../../profile_screen/profile_screen.dart';
import '../../provider/profile_provider.dart';
import '../../search_resturant_screen/search_resturant_screen.dart';
import '../../utils/nav_utils.dart';
import '../../utils/shared_preference_utils.dart';
import '../../utils/theme_utils.dart';
import '../../utils/utils.dart';
import '../payment_type/payment_screen.dart';
import '../screens/login_screen.dart';
import '../screens/save_home_address.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  String userName = "";
  bool isLoading = true;
  SignUpData? signUpResponse;
  ProfileData? profile;


  @override
  void initState() {
    super.initState();
    Utils.getToken();
    _loadLocalProfile();
    _getProfileData();
  }

  Future<void> _loadLocalProfile() async {
    final data = await Utils.getProfile();

    if (data == null) {
      Utils.showToast("Session expired. Please login again.");
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
            (route) => false,
      );
      return;
    }

    setState(() {
      profile = data;
      isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    final theme = CustomTheme.getTheme(true);
    final profileState = ref.watch(profileProvider);
    final ProfileData? profile = profileState.profileData;
    final ProfileData? currentProfile =
    profileState.profileList.isNotEmpty
        ? profileState.profileList.first
        : profile;
    final int? subscriptionPlanId =
        currentProfile?.subscriptionPlanId ??
            currentProfile?.subscriptionResponse?.planId;
    if (isLoading || profileState.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Constant.gold,
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: theme!.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        leading: Padding(
          padding: EdgeInsets.only(left: Constant.SIZE_10),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: currentProfile == null
                ? null
                : () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      MyProfileScreen(
                        userId: currentProfile.id!,
                        subScriptionPlanId:
                        currentProfile.subscriptionPlanId ??
                            currentProfile.subscriptionResponse?.planId ??
                            0,
                      ),
                ),
              );
            },

            child: CircleAvatar(
              radius: Constant.CONTAINER_SIZE_20,
              backgroundColor: Constant.grey.withOpacity(0.15),
              child: ClipOval(
                child: (currentProfile?.profileImageUrl != null &&
                    currentProfile!.profileImageUrl!.isNotEmpty)
                    ? Image.network(
                  "${NetworkUrls.PROFILE_IMAGE_BASE_URL}${currentProfile
                      .profileImageUrl}?t=${DateTime
                      .now()
                      .millisecondsSinceEpoch}",
                  fit: BoxFit.cover,
                  width: Constant.CONTAINER_SIZE_40,
                  height: Constant.CONTAINER_SIZE_40,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.person,
                      size: Constant.CONTAINER_SIZE_26,
                      color: theme.primaryColor,
                    );
                  },
                )
                    : Icon(
                  Icons.person,
                  size: Constant.CONTAINER_SIZE_26,
                  color: theme.primaryColor,
                ),
              ),
            ),
          ),
        ),

        title: Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi,',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Constant.subtitleText,
                  fontSize: Constant.LABEL_TEXT_SIZE_14,
                ),
              ),
              Text(
                profile?.fullName ?? "",
                maxLines: Constant.MAX_LINE_1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Constant.profileText,
                  fontSize: Constant.LABEL_TEXT_SIZE_20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: Constant.CONTAINER_SIZE_12),
            child: Row(
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(
                    Constant.CONTAINER_SIZE_26,
                  ),
                  onTap: () {
                    NavUtil.navigateToPushScreen(
                      context,
                      SearchRestaurantScreen(),
                    );
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
                  borderRadius: BorderRadius.circular(
                    Constant.CONTAINER_SIZE_26,
                  ),
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
                          Center(
                          child: Text(
                            Strings.DASHBOARD_TEXT,
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: Constant.gold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          ),
                          Image.asset(
                            'assets/images/dashboard.png',
                            height: Constant.CONATAINER_SIZE_380,
                            width: Constant.CONATAINER_SIZE_380,
                          ),


                          SizedBox(height: Constant.CONTAINER_SIZE_12),


                          SizedBox(height: Constant.CONTAINER_SIZE_12),

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

  _getProfileData() async {
    try {
      await ref.read(networkProvider.notifier).isNetworkAvailable().then((
          isNetworkAvailable,) async {
        Utils.printLog("isNetworkAvailable::$isNetworkAvailable");
        if (isNetworkAvailable) {
          ref.read(profileProvider).clearProfileList();
          ref.read(profileProvider).setIsLoading(true);
          final int? userId =
          await SharedPreferenceUtils.getIntValuesSF(Strings.USER_ID);

          if (userId == null || userId == -1) {
            Utils.showToast("User session expired. Please login again.");
            return;
          }
          final url = '${NetworkUrls.GET_PROFILE}$userId';
          Utils.printLog("Fetching URL: $url");
          ref.read(getProfileProvider(url));
        } else {
          Utils.showToast(Strings.NO_INTERNET_CONNECTION);
        }
      });
    } catch (e) {
      ref.read(profileProvider).setIsLoading(false);
      Utils.showToast(e.toString());
    }
    FocusScope.of(context).unfocus();
  }
}
