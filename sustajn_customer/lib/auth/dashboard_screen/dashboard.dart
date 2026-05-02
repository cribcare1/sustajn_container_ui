import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/imports_util.dart';
import '../../constants/network_urls.dart';
import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../../firebase_services.dart';
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
  const DashboardScreen({super.key});

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
      await FirebaseServices().initialize();
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

    if (isLoading || profileState.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Constant.gold),
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
                  builder: (context) => MyProfileScreen(
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
                  "${NetworkUrls.PROFILE_IMAGE_BASE_URL}${currentProfile.profileImageUrl}",
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

        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Strings.HII,
              style: theme.textTheme.titleMedium?.copyWith(
                color: Constant.subtitleText,
                fontSize: Constant.LABEL_TEXT_SIZE_14,
              ),
            ),
            Text(
              profile?.fullName ?? "",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleLarge?.copyWith(
                color: Constant.profileText,
                fontSize: Constant.LABEL_TEXT_SIZE_20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
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
                      border: Border.all(
                        color: Constant.grey.withOpacity(0.2),
                      ),
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
                    Utils.navigateToPushScreen(
                      context,
                      NotificationScreen(),
                    );
                  },
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        padding: EdgeInsets.all(Constant.SIZE_08),
                        decoration: BoxDecoration(
                          color: Constant.grey.withOpacity(0.1),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Constant.grey.withOpacity(0.2),
                          ),
                        ),
                        child: Icon(
                          Icons.notifications_none,
                          color: Constant.subtitleText,
                          size: Constant.CONTAINER_SIZE_22,
                        ),
                      ),

                      Positioned(
                        top: -2,
                        right: -2,
                        child: Container(
                          height: 10,
                          width: 10,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              Strings.DASHBOARD_TEXT,
              style: theme.textTheme.titleLarge?.copyWith(
                color: Constant.gold,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: Constant.CONTAINER_SIZE_12),

            Image.asset(
              'assets/images/dashboard.png',
              height: Constant.CONATAINER_SIZE_380,
              width: Constant.CONATAINER_SIZE_380,
            ),
          ],
        ),
      ),
    );
  }

  _getProfileData() async {
    try {
      await ref
          .read(networkProvider.notifier)
          .isNetworkAvailable()
          .then((isNetworkAvailable) async {
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