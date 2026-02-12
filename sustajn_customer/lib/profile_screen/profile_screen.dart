import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sustajn_customer/common_widgets/custom_back_button.dart';
import 'package:sustajn_customer/constants/number_constants.dart';
import 'package:sustajn_customer/profile_screen/edit_dialogs/contact_us_dialog.dart';
import 'package:sustajn_customer/provider/profile_provider.dart';
import '../auth/dashboard_screen/generate_qr_screen.dart';
import '../auth/payment_type/payment_screen.dart';
import '../common_widgets/custom_cricle_painter.dart';
import '../constants/network_urls.dart';
import '../constants/string_utils.dart';
import '../models/get_profile_model.dart';
import '../models/login_model.dart';
import '../models/signup_model.dart';
import '../models/subscriptionplan_data.dart';
import '../models/update_image.dart';
import '../network_provider/network_provider.dart';
import '../provider/signup_provider.dart';
import '../utils/nav_utils.dart';
import '../utils/shared_preference_utils.dart';
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
  final int subScriptionPlanId;

  const MyProfileScreen({super.key, required this.userId,
  required this.subScriptionPlanId});

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
    {"name": "Contact Us", "icon": Icons.headset_mic},
  ];

  bool isLoading = true;
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();
  int _profileImageVersion = 0;

  @override
  void initState() {
    super.initState();
    Utils.getToken();
    ref.read(getProfileProvider('${NetworkUrls.GET_PROFILE}${widget.userId}'));
    ref.read(getSubscriptionProvider('${NetworkUrls.GET_SUBSCRIPTION_PLAN}'));
  }




  void _handleItemTap(
    int index,
    BuildContext context,
    int? planID,
    String? mobileNumber,
      String? secondaryNumber,
      var profileState,
      int userId
  ) {
    switch (index) {
      case 0:
        _showMobileEditDialog(context, mobileNumber ?? "", userId, secondaryNumber ??"" );
        break;
      case 1:
        _showEditAddress(context);
        break;
      case 2:
        _showHistoryScreen(context);
        break;
      case 3:
        _showPaymentScreen(context, profileState);
        break;
      case 4:
        _showQRDialog(context, profileState);
        break;
      case 5:
        _showFeedbackDialog(context);
        break;
      case 6:
        if (planID == null) {
          showCustomSnackBar(
            context: context,
            message: Strings.SUBSCRIPTION_NOT_FOUND,
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

  void _showMobileEditDialog(BuildContext context, String mobileNumber, int userId, String secondayNumber) {
    ref.read(profileProvider).setContext(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => EditMobileNumberDialog(mobileNumber: mobileNumber,
      secondaryNumber: secondayNumber,
      userId: userId,),
    );
  }

  void _showEditAddress(BuildContext context) {
    NavUtil.navigateToPushScreen(context, AddressScreen());
  }

  void _showFeedbackDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FeedbackBottomSheet(userId: widget.userId),
    );
  }

  void _showPaymentScreen(
      BuildContext context,
      var profileState,
      ) {
    final profile = profileState.profileList.isNotEmpty
        ? profileState.profileList.first
        : null;

    final bankDetails = profile?.bankDetailsResponse;

    if (bankDetails == null) {
      NavUtil.navigateToPushScreen(
        context,
        PaymentTypeScreen(
          flow: PaymentFlow.profile,
        ),
      );
      return;
    }

    NavUtil.navigateToPushScreen(
      context,
      EditPaymentScreen(
        bankDetails: profile.bankDetailsResponse,
        cardDetails: profile.cardDetailsResponse,
        paymentGateway: profile.paymentGetWayResponse,),
    );
  }


  void _showContactDialog(BuildContext context) {
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
      builder: (_) =>
          FreemiumBottomSheet(userID: widget.userId,
              // planID: planId
          ),
    );
  }

  void _showQRDialog(
      BuildContext context,
      var profileState,
      ) {
    final profile = profileState.profileList.isNotEmpty
        ? profileState.profileList.first
        : null;

    if (profile?.bankDetailsResponse == null) {
      if (!mounted) return;
      showCustomSnackBar(
        context: context,
        message:
        Strings.BANK_DETAILS_NOT_ADDED,
        color: Colors.green,
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => QrDialog(),
    );
  }


  void _showHistoryScreen(BuildContext context) {
    NavUtil.navigateToPushScreen(
      context,
      HistoryHomeScreen(userId: widget.userId),
    );
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

      _uploadImageNetwork(ref.read(signUpNotifier));
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

      _uploadImageNetwork(ref.read(signUpNotifier));
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);

    final profile = profileState.profileList.isNotEmpty
        ? profileState.profileList.first
        : null;

    final profileImageUrl =
    profile?.profileImageUrl != null && profile!.profileImageUrl!.isNotEmpty
        ? '${NetworkUrls.PROFILE_IMAGE_BASE_URL}${profile.profileImageUrl}?v=$_profileImageVersion'
        : null;

    final size = MediaQuery.of(context).size;
    final theme = CustomTheme.getTheme(true);
    final w = size.width;
    final h = size.height;
    final double goldBarHeight = h * 0.26;

    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        backgroundColor: theme?.scaffoldBackgroundColor,
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              width: Constant.CONTAINER_SIZE_30,
              height: Constant.CONTAINER_SIZE_30,
              margin: EdgeInsets.all(Constant.SIZE_08),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.arrow_back_ios, color: Colors.black),
            ),
          ),
          title:Padding(
            padding: const EdgeInsets.only(left: 4),
          child:  Text(
            Strings.MY_PROFILE,
            style: TextStyle(
              fontSize: Constant.CONTAINER_SIZE_18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
        ),
        extendBodyBehindAppBar:true,

        body: SingleChildScrollView(
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    height: goldBarHeight,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Constant.gold,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(Constant.CONTAINER_SIZE_40),
                        bottomRight: Radius.circular(Constant.CONTAINER_SIZE_40),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      SizedBox(height: goldBarHeight - (w * 0.14)),
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            height: w * 0.28,
                            width: w * 0.28,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Constant.gold, width: Constant.CONTAINER_SIZE_2),
                              ),
                            child: ClipOval(
                              child: profileImageUrl != null
                                  ? Image.network(
                                profileImageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return _defaultProfileIcon(w, theme!);
                                },
                              )
                                  : _defaultProfileIcon(w, theme!),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Utils.showProfilePhotoBottomSheet(
                                context,
                                onCamera: _pickFromCamera,
                                onGallery: _pickFromGallery,
                              );
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
                                color: theme?.primaryColor,
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
                          InkWell(
                            onTap: () {
                              ref.read(profileProvider).setContext(context);
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                useRootNavigator: true,
                                backgroundColor: Colors.transparent,
                                builder: (_) => EditUserNameDialog(
                                  userName: profile?.fullName ?? "",
                                  dob: profile?.dateOfBirth ?? "",
                                  userId: widget.userId,
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
                      // SizedBox(height: h * 0.01),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                           'DOB - ${profile?.dateOfBirth ?? ""} ',
                            style: TextStyle(
                              fontSize: w * 0.045,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: h * 0.03),
                      Container(
                        margin: EdgeInsets.only(
                          left: h*0.02,
                          right: h*0.02,
                        ),
                        child: ListTile(
                          leading: Icon(
                            Icons.email_outlined,
                            size: w*0.054,
                            color: Constant.gold,
                          ),
                          title: Text(
                            Strings.EMAIL_1,
                            style: TextStyle(
                              fontSize: Constant.CONTAINER_SIZE_14,
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Text(profile?.emailId ?? "",
                            maxLines:1,
                            overflow:TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: w*0.040,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      _commonDivider(),
                      Container(
                        margin: EdgeInsets.only(
                          left: h*0.02,
                          right: h*0.02,
                          top: 0,
                        ),
                        child: ListView.separated(
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: detailList.length,
                          separatorBuilder: (context, index) => Divider(
                            height: 1,
                            thickness: 1,
                            color: Constant.grey.withOpacity(0.3),
                          ),
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
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                size: w * 0.044,
                                color: Constant.grey,
                              ),
                              onTap: () => _handleItemTap(
                                index,
                                context,
                                widget.subScriptionPlanId,
                                  profile?.mobileNumber ?? "",
                                profile?.secondaryNumber ?? "",
                                profileState,profile?.id ?? 0
                              ),
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
                              color: Constant.gold,
                              size: w * 0.05,
                            ),
                            label: Text(
                              Strings.LOG_OUT,
                              style: TextStyle(
                                color: Constant.gold,
                                fontSize: w * 0.045,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme?.primaryColor,
                              padding: EdgeInsets.symmetric(
                                vertical: h * 0.018,
                              ),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: Constant.gold),
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
                    ],
                  ),
                ],
              ),
            ),
      ),
    );
  }

  Widget _defaultProfileIcon(double w, ThemeData theme) {
    return Container(
      color: Colors.grey.withOpacity(0.8),
      child: Icon(Icons.person, size: w * 0.15, color: theme.primaryColor),
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
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
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
            child: Icon(
              Icons.edit_outlined,
              size: w * 0.045,
              color: Colors.white,
            ),
          ),
      ],
    );
  }
  Widget _commonDivider(){
    return Divider(
      height: Constant.CONTAINER_SIZE_1,
      thickness: Constant.CONTAINER_SIZE_1,
      color: Constant.grey.withOpacity(0.3),
    );
  }
  _uploadImageNetwork(var registrationState) async {
    if (_profileImage == null) return;

    try {
      final isNetworkAvailable =
      await ref.read(networkProvider.notifier).isNetworkAvailable();

      if (!isNetworkAvailable) {
        Utils.showToast(Strings.NO_INTERNET_CONNECTION);
        return;
      }

      ref.read(profileProvider).setIsLoading(true);

      final params = <String, dynamic>{
        Strings.PART_URL: '${NetworkUrls.UPLOAD_IMAGE}${widget.userId}',
        Strings.REQUEST_KEY: 'image',
        Strings.IMAGE: _profileImage!,
        'userId': widget.userId,
      };

      final UpdateImage response = await ref.read(uploadImageProvider(params).future);

      if (response.message?.toLowerCase().contains("success") ?? false) {
        final profileResponse = await ref.refresh(
          getProfileProvider('${NetworkUrls.GET_PROFILE}${widget.userId}').future,
        );

        ref.read(profileProvider.notifier).setProfileList(profileResponse);

        await SharedPreferenceUtils.removeValueFromSF(Strings.PROFILE_DATA);
        await SharedPreferenceUtils.saveDataInSF(
          Strings.PROFILE_DATA,
          jsonEncode(profileResponse.data?.toJson()),
        );

        final newImageFileName = profileResponse.data?.profileImageUrl;
        if (newImageFileName != null && newImageFileName.isNotEmpty) {
          final newUrl =
              '${NetworkUrls.PROFILE_IMAGE_BASE_URL}$newImageFileName?v=${DateTime.now().millisecondsSinceEpoch}';
          await NetworkImage(newUrl).evict();
        }

        imageCache.clear();
        imageCache.clearLiveImages();

        if (mounted) {
          setState(() {
            _profileImageVersion++;
            _profileImage = null;
          });

          WidgetsBinding.instance.addPostFrameCallback((_) {
            showCustomSnackBar(
              context: context,
              message: 'User image uploaded successfully',
              color: Constant.green,
            );

          });
        }
      }
    } catch (e) {
      Utils.printLog('Error in image upload: $e');
      Utils.showToast(e.toString());
    } finally {
      ref.read(profileProvider).setIsLoading(false);
    }
  }

}
