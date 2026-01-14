import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sustajn_customer/auth/screens/map_screen.dart';
import 'package:sustajn_customer/common_widgets/custom_back_button.dart';
import 'package:sustajn_customer/constants/number_constants.dart';
import 'package:sustajn_customer/profile_screen/edit_dialogs/contact_us_dialog.dart';
import 'package:sustajn_customer/provider/profile_provider.dart';
import '../auth/dashboard_screen/generate_qr_screen.dart';
import '../auth/payment_type/payment_screen.dart';
import '../common_widgets/custom_cricle_painter.dart';
import '../constants/network_urls.dart';
import '../constants/string_utils.dart';
import '../models/login_model.dart';
import '../models/subscriptionplan_data.dart';
import '../network_provider/network_provider.dart';
import '../provider/signup_provider.dart';
import '../utils/nav_utils.dart';
import '../utils/theme_utils.dart';
import '../utils/utils.dart';
import 'edit_dialogs/address_screen.dart';
import 'edit_dialogs/edit_mobile_number.dart';
import 'edit_dialogs/edit_payment.dart';
import 'edit_dialogs/edit_user_name.dart';
import 'edit_dialogs/feedback_dialog.dart';
import 'edit_dialogs/freemium_bottom_sheet.dart';
import 'history_screen/history_home_screen.dart';



class MyProfileScreen extends ConsumerStatefulWidget {
  final int userId;
  const MyProfileScreen({super.key, required this.userId});

  @override
  ConsumerState<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends ConsumerState<MyProfileScreen> {
  final List<Map<String, dynamic>> detailList = [
    {"name": "Mobile Number", "icon": Icons.phone},
    {"name": "Saved Address", "icon": Icons.location_on},
    {"name": "History", "icon": Icons.history},
    {"name": "Payment Type", "icon": Icons.currency_rupee},
    {"name": "QR Code", "icon": Icons.qr_code},
    {"name": "Feedback", "icon": Icons.star_border},
    {"name": "Subscription Plan", "icon": Icons.credit_card},
    {"name": "Contact Us","icon": Icons.headset_mic }
  ];

  bool isLoading = true;
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();
  Data? loginResponse;


  @override
  void initState() {
    super.initState();
    Utils.getToken();
    _getNetworkData();
    _getProfileData();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    await Utils.getProfile();
    setState(() {
      loginResponse = Utils.loginData?.data;
      isLoading = false;
    });
  }

  void _handleItemTap(int index, BuildContext context,int? planID, String? mobileNumber) {
    switch (index) {
      case 0:
        _showMobileEditDialog(context, mobileNumber??"");
        break;
      case 1:
        _showEditAddress(context);
        break;
      case 2:
        _showHistoryScreen(context);
        break;
      case 3:
        _showPaymentScreen(context);
        break;
      case 4:
        _showQRDialog(context);
        break;
      case 5:
        _showFeedbackDialog(context);
        break;
      case 6:
        if (planID == null) {
          showCustomSnackBar(
            context: context,
            message: "subscription details not found",
            color: Colors.green,
          );
          return;
        }
        _showFreemiumSheet(context, planID);
        break;
      case 7:
        _showContactDialog(context);
        break;
    }
  }

  void _showMobileEditDialog(BuildContext context, String mobileNumber){
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>  EditMobileNumberDialog(mobileNumber: mobileNumber,),
    );
  }

  void _showEditAddress(BuildContext context){
    NavUtil.navigateToPushScreen(context, AddressScreen());
  }

  void _showFeedbackDialog(BuildContext context,
      ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) =>  FeedbackBottomSheet(userId: widget.userId ),
    );
  }

  void _showPaymentScreen(BuildContext context) {
    final profileState = ref.read(profileProvider);

    final profile = profileState.profileList.isNotEmpty
        ? profileState.profileList.first
        : null;

    final bankDetails = profile?.bankDetailsResponse;

    if (bankDetails == null) {
      showCustomSnackBar(
        context: context,
        message: "Bank details not added yet. Please add bank details to view.",
        color: Colors.green,
      );
      return;
    }

    NavUtil.navigateToPushScreen(
      context,
      EditPaymentScreen(bankDetails: bankDetails),
    );
  }


  void _showContactDialog(BuildContext context){
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const ContactUsDialog(),
    );
  }

  void _showFreemiumSheet(BuildContext context, int? planId) {
    if (planId == null) {
      Utils.printLog("PlanId is null");
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => FreemiumBottomSheet(
        userID: widget.userId,
        planID: planId,
      ),
    );

  }


  void _showQRDialog(BuildContext context){
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) =>  QrDialog(),
    );
  }



  void _showHistoryScreen(BuildContext context){
    NavUtil.navigateToPushScreen(context, HistoryHomeScreen(userId:widget.userId));
  }

  Future<void> _pickFromCamera() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

  Future<void> _pickFromGallery() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final signUpState = ref.watch(signUpNotifier);
    final profileState = ref.watch(profileProvider);

    final planId = signUpState.subscriptionModel?.data?.first.planId;
    final profile = profileState.profileList.isNotEmpty
        ? profileState.profileList.first
        : null;

    final addressList = profile?.addressResponses;

    String addressText = "No address available";

    if (addressList != null && addressList.isNotEmpty) {
      final address = addressList.first;
      addressText =
      "${address.flatDoorHouseDetails ?? ""}, "
          "${address.areaStreetCityBlockDetails ?? ""}\n"
          "PO Box ${address.poBoxOrPostalCode ?? ""}";
    }


    final size = MediaQuery.of(context).size;
    final theme = CustomTheme.getTheme(true);
    final w = size.width;
    final h = size.height;

    return SafeArea(
        top: false,
        bottom: true,
        child: Scaffold(
          backgroundColor: theme?.scaffoldBackgroundColor,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Constant.gold,
            surfaceTintColor: Constant.gold,
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: Constant.CONTAINER_SIZE_30,
                height: Constant.CONTAINER_SIZE_30,
                margin: EdgeInsets.all(Constant.SIZE_08),
                decoration: BoxDecoration(
                  color: Constant.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: Constant.grey, width: 0.3),
                ),
                child: Icon(Icons.arrow_back_ios, color: theme!.primaryColor),
              ),
            ),
            title:  Text(
              "My Profile",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: theme!.primaryColor,
              ),
            ),
          ),

          body: Builder(
              builder: (context) {
                if(profileState.isLoading){
                  return Utils.showProgressBar();
                }

                if(!profileState.isLoading && profileState.profileList.isEmpty){
                  return Utils.getErrorText('No profile details found');
                }
                return SingleChildScrollView(
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
                                    color: Constant.gold,
                                    width: 2,
                                  ),
                                ),
                                child: ClipOval(
                                  child: (loginResponse?.image != null &&
                                      loginResponse!.image!.isNotEmpty)
                                      ? Image.network(
                                    "${NetworkUrls.PROFILE_IMAGE_BASE_URL}${loginResponse!.image}",
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return _defaultProfileIcon(w, theme);
                                    },
                                  )
                                      : _defaultProfileIcon(w, theme),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Utils.showProfilePhotoBottomSheet(context,
                                    onCamera: _pickFromCamera,
                                    onGallery: _pickFromGallery,);
                                },
                                child: Container(
                                  height: w * 0.09,
                                  width: w * 0.09,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                  child:
                                  Icon(Icons.edit_outlined, size: w * 0.045,
                                    color: theme.primaryColor,),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: h * 0.015),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                              loginResponse?.fullName??"",
                                style: TextStyle(
                                    fontSize: w * 0.055,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white
                                ),
                              ),
                              SizedBox(width: w * 0.015),
                              GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (context) =>
                                          EditUserNameDialog(userName:loginResponse?.fullName ?? ""),
                                    );
                                  },
                                  child: Icon(Icons.edit_outlined,
                                      size: w * 0.045, color: Colors.white)),
                            ],
                          ),
                          SizedBox(height: h * 0.03),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: h * 0.02),
                            padding: EdgeInsets.symmetric(
                              horizontal: w * 0.04,
                              vertical: h * 0.02,
                            ),
                            child: _detailItem(
                                icon: Icons.email_outlined,
                                title: "Email",
                                value: loginResponse!.userName ?? "",
                                w: w,
                                showEdit: false,
                                theme: theme,
                                ontap: () {}
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: h * 0.02),
                            child: Divider(
                              color: Colors.grey.withOpacity(0.3),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: h * 0.02),
                            child: ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: detailList.length,
                              separatorBuilder: (context, index) => Divider(
                                height: 1,
                                color: Constant.grey.withOpacity(0.3),),
                              itemBuilder: (context, index) {
                                final item = detailList[index];
                                return ListTile(
                                  leading: Icon(item['icon'], size: w * 0.054,
                                      color: Constant.gold),
                                  title: Text(item['name'], style: TextStyle(
                                      fontSize: 14, color: Colors.white)),
                                  trailing: Icon(
                                    Icons.arrow_forward_ios, size: w * 0.044,
                                    color: Constant.grey,),
                                  onTap: () =>
                                      _handleItemTap(index, context, planId,profileState.profileList.first.mobileNumber ),
                                );
                              },
                            ),
                          ),

                          Center(
                            child: Container(
                              width: w * 0.55,
                              margin: EdgeInsets.only(top: h * 0.02),
                              child: ElevatedButton.icon(
                                icon: Icon(Icons.logout, color: Constant.gold,
                                    size: w * 0.05),
                                label: Text(
                                  "Log Out",
                                  style: TextStyle(
                                    color: Constant.gold,
                                    fontSize: w * 0.045,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: theme.primaryColor,
                                  padding: EdgeInsets.symmetric(
                                      vertical: h * 0.018),
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Constant.gold
                                    ),
                                    borderRadius: BorderRadius.circular(
                                        w * 0.04),
                                  ),
                                ),
                                onPressed: () {
                                  Utils.logOutDialog(
                                      context,
                                      Icons.logout,
                                      Strings.CONFIRM_LOGOUT,
                                      Strings.SURE_LOG_OUT,
                                      Strings.YES,
                                      Strings.NO
                                  );
                                },
                              ),
                            ),
                          ),


                        ],
                      ),
                    ],
                  ),
                );

              }
          ),
        )
    );
  }

  Widget _defaultProfileIcon(double w, ThemeData theme) {
    return Container(
      color: Colors.grey.withOpacity(0.8),
      child: Icon(
        Icons.person,
        size: w * 0.15,
        color: theme.primaryColor,
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
    ThemeData? theme
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
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: w * 0.040,
                    fontWeight: FontWeight.w500,
                    color: Colors.white
                ),
              ),
            ],
          ),
        ),
        if (showEdit)
          GestureDetector(
              onTap: ontap,
              child: Icon(Icons.edit_outlined, size: w * 0.045, color: Colors.white)),
      ],
    );
  }

  _getNetworkData() async {
    final registrationState = ref.read(signUpNotifier);
    try {
      await ref
          .read(networkProvider.notifier)
          .isNetworkAvailable()
          .then((isNetworkAvailable) async {
        try {
          if (isNetworkAvailable) {
            registrationState.setIsLoading(true);
            registrationState.setContext(context);
            var url = '${NetworkUrls.GET_SUBSCRIPTION_PLAN}';

            ref.read(getSubscriptionProvider(url));
          } else {
            registrationState.setIsLoading(false);
            if(!mounted) return;
            showCustomSnackBar(context: context, message: Strings.NO_INTERNET_CONNECTION, color: Colors.red);
          }
        } catch (e) {
          Utils.printLog('Error on button onPressed: $e');
          registrationState.setIsLoading(false);
        }
        if(!mounted) return;
        FocusScope.of(context).unfocus();
      });

    } catch (e) {
      Utils.printLog('Error in Login button onPressed: $e');
      registrationState.setIsLoading(false);
    }
  }

  _getProfileData() async {
    try {
      await ref.read(networkProvider.notifier).isNetworkAvailable().then((
          isNetworkAvailable,
          ) {
        Utils.printLog("isNetworkAvailable::$isNetworkAvailable");
        if (isNetworkAvailable) {
          ref.read(profileProvider).clearProfileList();
          ref.read(profileProvider).setIsLoading(true);

          final url = '${NetworkUrls.GET_PROFILE}${widget.userId}';
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


