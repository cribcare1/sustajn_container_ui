import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sustajn_restaurant/constants/network_urls.dart';
import 'package:sustajn_restaurant/models/get_profile_data.dart';
import 'package:sustajn_restaurant/provider/profile_provider.dart';
import '../../common_widgets/custom_profile_paint.dart';
import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../../models/login_model.dart';
import '../../network_provider/network_provider.dart';
import '../../utils/theme_utils.dart';
import '../../utils/utility.dart';
import '../edit_dialogs/business_information_screen.dart';
import '../edit_dialogs/edit_address.dart';
import '../edit_dialogs/edit_bankdetails_dialog.dart';
import '../edit_dialogs/edit_contact_number/edit_mobile_number.dart';
import '../edit_dialogs/edit_contact_number/secondary_contact_no.dart';
import '../edit_dialogs/edit_resturantname_dialog.dart';
import '../edit_dialogs/feedback_dialog.dart';
import '../edit_dialogs/report_screen/reports_screen.dart';
import '../edit_dialogs/subscription_dialog.dart';

class MyProfileScreen extends ConsumerStatefulWidget {
  const MyProfileScreen({super.key});

  @override
  ConsumerState<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends ConsumerState<MyProfileScreen> {
  final List<Map<String, dynamic>> detailList = [
    // {"name": "Bank Details", "icon": Icons.account_balance_outlined},
    {"name": "Email", "icon": Icons.email_outlined},
    {"name": "Address", "icon": Icons.location_on_outlined},
    {"name": "Mobile Number", "icon": Icons.call},
    {"name": "Report Damaged Container", "icon": Icons.bar_chart_outlined}, //ok
    {"name": "Business Information", "icon": Icons.business_outlined}, //ok
    {"name": "Subscription Plan", "icon": Icons.credit_card_outlined}, //ok
    {"name": "Payment Type", "icon": Icons.payments_outlined},
    {"name": "History", "icon": Icons.history},
    {"name": "Feedback", "icon": Icons.feedback_outlined}, //ok
    {"name": "Contact Us", "icon": Icons.headset_mic_outlined},
    {"name": "Refer a Partner", "icon": Icons.connect_without_contact},

  ];

  void _handleItemTap(int index, BuildContext context, String mobileNo) {
    switch (index) {
      case 0:
        break;
      case 1:
        _showAddressDialog(context);
        break;
      case 2:
        _showMobileNoDialog(context, mobileNo);
        break;
      case 3:
        _showReportScreen(context);
        break;
      case 4:
        _showBusinessEditScreen(context);
        break;
      case 5:
        _showSubscriptionDialog(context);
        break;
      case 6:
        //paymentType
        _showBankDetailsEdit(context);
        break;
      case 7:
        //history
        break;
      case 8:
        _showFeedbackDialog(context);
        break;
      case 9:
      //contact us
        break;
      case 10:
        //refer a partner
        break;
    }
  }

  void _showFeedbackDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const FeedbackBottomSheet(),
    );
  }

  void _showSubscriptionDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const SubscriptionPlanBottomSheet(),
    );
  }

  void _showAddressDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => EditAddressDialog(selectedAddress: selectedAddress),

    );
  }

  void _showMobileNoDialog(BuildContext context, String mobile) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
      SecondaryMobileNumberDialog(mobileNumber: mobile ?? "")
        // EditMobileNumberDialog(mobileNumber: mobile ?? ""),
    );
  }
  void _showBankDetailsEdit(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const EditBankDetailsDialog(),
    );
  }

  void _showBusinessEditScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BusinessInformationScreen()),
    );
  }

  void _showReportScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ReportScreen()),
    );
  }

  List<GetProfileData> profileData = [];
  AddressResponses? selectedAddress;

  LoginData? loginResponse;
  bool isLoading = true;
  File? profileImage;

  @override
  void initState() {
    super.initState();
    _loadProfile();
    _getProfileNetworkCall();
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
    final profileState = ref.watch(profileProvider);
    final profile = profileState.getProfileData?.data;

    final List<AddressResponses>? addresses = profile?.addressResponses;

    if (addresses != null && addresses.isNotEmpty) {
      selectedAddress = addresses.firstWhere(
            (e) => e.addressType?.toLowerCase() == "home",
        orElse: () => addresses.firstWhere(
              (e) => e.addressType?.toLowerCase() == "work",
          orElse: () => addresses.first,
        ),
      );
    }

    final String fullAddress = selectedAddress == null
        ? "No address added"
        : [
      selectedAddress!.flatDoorHouseDetails,
      selectedAddress!.areaStreetCityBlockDetails,
      selectedAddress!.poBoxOrPostalCode,
    ].whereType<String>()
        .where((e) => e.isNotEmpty)
        .join(', ');


    if (profileState.isLoading == true) {
      return Center(child: CircularProgressIndicator());
    }

    final size = MediaQuery.of(context).size;
    final theme = CustomTheme.getTheme(true);
    final w = size.width;
    final h = size.height;

    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        backgroundColor: theme!.scaffoldBackgroundColor,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color(0xFFD1AE31),
          surfaceTintColor: const Color(0xFFD1AE31),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.keyboard_arrow_left),
          ),
          title: Text(
            "My Profile",
            style: TextStyle(
              fontSize: Constant.CONTAINER_SIZE_20,
              fontWeight: FontWeight.w500,
              color: theme.scaffoldBackgroundColor,
            ),
          ),
        ),

        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : (loginResponse != null || profileData != null) ? SingleChildScrollView(
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    SizedBox(
                      width: w - (w * 0.34),
                      height: h * 0.30,
                      child: CustomPaint(painter: TopCirclePainter()),
                    ),
                    Column(
                      children: [
                        SizedBox(height: h * 0.035),
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              height: w * 0.28,
                              width: w * 0.28,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: w * 0.012,
                                ),
                                image: DecorationImage(
                                  image: profile?.profileImageUrl != null && profile?.profileImageUrl.isNotEmpty ? NetworkImage(
                                    "${NetworkUrls.PROFILE_IMAGE_BASE_URL}${loginResponse!.image}",
                                  ):AssetImage("assets/images/cups.png"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _profileImgNetworkCall(
                                  profileState,
                                  profile!.mobileNumber!,
                                  profile.fullName!,
                                );
                                Utils.showProfilePhotoBottomSheet(context);
                              },
                              child: Container(
                                height: w * 0.09,
                                width: w * 0.09,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: Icon(
                                  Icons.edit_outlined,
                                  size: w * 0.045,
                                  color: theme.primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: h * 0.015),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              profile?.fullName ?? "",
                              style: TextStyle(
                                fontSize: w * 0.055,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: w * 0.015),
                            if (profile?.fullName != null)
                              GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (context) =>
                                        EditRestaurantNameDialog(
                                          name: profile!.fullName!,
                                        ),
                                  );
                                },
                                child: Icon(
                                  Icons.edit_outlined,
                                  size: w * 0.045,
                                  color: Colors.white,
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: h * 0.02),
                        // Container(
                        //   width: double.infinity,
                        //   margin: EdgeInsets.symmetric(horizontal: w * 0.05),
                        //   padding: EdgeInsets.symmetric(
                        //     horizontal: w * 0.04,
                        //     vertical: h * 0.02,
                        //   ),
                        //   decoration: BoxDecoration(
                        //     color: theme.scaffoldBackgroundColor,
                        //     borderRadius: BorderRadius.circular(w * 0.04),
                        //     border: Border.all(color: Colors.grey),
                        //     boxShadow: [
                        //       BoxShadow(
                        //         color: Colors.black.withOpacity(0.08),
                        //         blurRadius: 8,
                        //       ),
                        //     ],
                        //   ),
                        //   child: Column(
                        //     children: [
                              // _detailItem(
                              //   icon: Icons.email_outlined,
                              //   title: Strings.EMAIL,
                              //   value: profile?.emailId! ?? "",
                              //   w: w,
                              //   showEdit: false,
                              //   theme: theme,
                              //   ontap: () {},
                              // ),
                              // Divider(color: Colors.grey.shade700),
                              //
                              // _detailItem(
                              //   icon: Icons.location_on_outlined,
                              //   title: Strings.ADDRESS,
                              //   value: fullAddress ?? "No address",
                              //   w: w,
                              //   showEdit: true,
                              //   theme: theme,
                              //   ontap: () {
                              //     showModalBottomSheet(
                              //       context: context,
                              //       isScrollControlled: true,
                              //       backgroundColor: Colors.transparent,
                              //       builder: (context) =>
                              //           EditAddressDialog(selectedAddress: selectedAddress),
                              //     );
                              //   },
                              // ),
                              // Divider(color: Colors.grey.shade700),
                              // _detailItem(
                              //   icon: Icons.phone_outlined,
                              //   title: Strings.MOBILE_NUMBER,
                              //   value: profile?.mobileNumber! ?? "",
                              //   w: w,
                              //   showEdit: true,
                              //   theme: theme,
                              //   ontap: () {
                              //     showModalBottomSheet(
                              //       context: context,
                              //       isScrollControlled: true,
                              //       backgroundColor: Colors.transparent,
                              //       builder: (context) =>
                              //           EditMobileNumberDialog(
                              //             mobileNumber:
                              //                 profile?.mobileNumber ?? "",
                              //           ),
                              //     );
                              //   },
                              // ),
                        //     ],
                        //   ),
                        // ),

                        Container(
                          margin: EdgeInsets.symmetric(horizontal: h * 0.02),
                          child: ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: detailList.length,
                            separatorBuilder: (context, index) =>
                                Divider(height: 1, color: Colors.grey.shade700),
                            itemBuilder: (context, index) {
                              final item = detailList[index];
                              return ListTile(
                                leading: Icon(
                                  item['icon'],
                                  size: w * 0.054,
                                  color: Constant.gold,
                                ),
                                title: Text(
                                  item['name'],
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                                subtitle: index == 0
                                    ? Text(
                                  profile?.emailId ?? "",
                                  style: TextStyle(color: Colors.grey.shade300, fontSize: Constant.CONTAINER_SIZE_12),
                                )
                                    : null,
                                trailing: index == 0
                                    ? null
                                    : Icon(
                                  Icons.arrow_forward_ios,
                                  size: w * 0.044,
                                  color: Colors.white,
                                ),
                                onTap: () => _handleItemTap(index, context, profile?.mobileNumber ?? "", ),
                              );
                            },
                          ),
                        ),

                        Center(
                          child: Container(
                            width: w * 0.55,
                            margin: EdgeInsets.only(top: h * 0.02),
                            child: ElevatedButton.icon(
                              icon: Icon(
                                Icons.logout,
                                color: theme.primaryColor,
                                size: w * 0.05,
                              ),
                              label: Text(
                                Strings.LOGOUT,
                                style: TextStyle(
                                  color: theme.primaryColor,
                                  fontSize: w * 0.045,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFC8B531),
                                padding: EdgeInsets.symmetric(
                                  vertical: h * 0.018,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(w * 0.04),
                                ),
                              ),
                              onPressed: () {
                                Utils.logOutDialog(
                                  context,
                                  Icons.logout,
                                  Strings.CONFIRM_LOGOUT,
                                  Strings.SURE_LOG_OUT,
                                  Strings.YES,
                                  Strings.NO,
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: h * 0.035),
                      ],
                    ),
                  ],
                ),
              ):const Center(
          child: Text(
            "No Data available",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _detailItem({
    required IconData icon,
    required String title,
    required String value,
    required double w,
    bool showEdit = true,
    required VoidCallback ontap,
    ThemeData? theme,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Constant.gold, size: w * 0.06),
        SizedBox(width: w * 0.03),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: w * 0.034, color: Colors.white),
              ),
              SizedBox(height: w * 0.01),
              Text(
                value,
                style: TextStyle(
                  fontSize: w * 0.040,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        if (showEdit)
          GestureDetector(
            onTap: ontap,
            child: Icon(Icons.edit, size: w * 0.045, color: Colors.white),
          ),
      ],
    );
  }

  _getProfileNetworkCall() async {
    try {
      await ref.read(networkProvider.notifier).isNetworkAvailable().then((
        isNetworkAvailable,
      ) {
        Utils.printLog("isNetworkAvailable::$isNetworkAvailable");
        final profileState = ref.read(profileProvider);
        if (isNetworkAvailable) {
          profileState.setIsLoading(true);
          final userId = Utils.userId;
          final url = '${NetworkUrls.GET_PROFILE}$userId';
          ref.read(getProfileProvider(url));
        } else {
          profileState.setIsLoading(false);
          Utils.showToast(Strings.NO_INTERNET_CONNECTION);
        }
      });
    } catch (e) {
      Utils.printLog('Error in visitor button onPressed: $e');
    }
  }

  Map<String, dynamic> getJsonData(String mobile, String name) {
    final data = {
      "userId": Utils.userId,
      "phoneNumber": mobile,
      "fullName": name,
    };
    return data;
  }

  _profileImgNetworkCall(var profileState, String mobile, String name) async {
    Utils.printLog('Profile Image Network call');

    try {
      if (!profileState.isValid) return;

      final isNetworkAvailable = await ref
          .read(networkProvider.notifier)
          .isNetworkAvailable();
      Utils.printLog("isNetworkAvailable::$isNetworkAvailable");

      if (!isNetworkAvailable) {
        Utils.showToast(Strings.NO_INTERNET_CONNECTION);
        return;
      }

      profileState.setIsLoading(true);

      // Prepare multipart parameters using your utility method
      final params = Utils.multipartParams(
        NetworkUrls.UPDATE_PROFILE,
        getJsonData(mobile, name),
        Strings.PROFILE_IMAGE,
        profileImage,
      );
      final response = await ref.read(profileImgProvider(params).future);

      Utils.printLog("Profile image uploaded successfully: $response");
      profileState.setIsLoading(false);
    } catch (e) {
      Utils.printLog('Error uploading profile image: $e');
      profileState.setIsLoading(false);
      Utils.showToast('Failed to upload image');
    } finally {
      FocusScope.of(context).unfocus();
    }
  }
}
