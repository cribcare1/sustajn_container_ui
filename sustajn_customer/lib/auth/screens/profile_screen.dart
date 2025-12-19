import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common_widgets/custom_cricle_painter.dart';
import '../../constants/string_utils.dart';
import '../../models/login_model.dart';
import '../../utils/theme_utils.dart';
import '../../utils/utils.dart';
import '../edit_dialogs/edit_bank_details.dart';
import '../edit_dialogs/edit_user_name.dart';
import '../edit_dialogs/feedback_dialog.dart';



class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final List<Map<String, dynamic>> detailList = [
    {"name": "History", "icon": Icons.history},
    {"name": "Payment Type", "icon": Icons.currency_rupee},
    {"name": "QR Code", "icon": Icons.qr_code},
    {"name": "Feedback", "icon": Icons.feedback_outlined},
    {"name": "Subscription Plan", "icon": Icons.credit_card_outlined},
    {"name": "Contact Us","icon": Icons.headset_mic_outlined }
  ];

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


  void _handleItemTap(int index, BuildContext context) {
    switch (index) {
      case 0:
        _showBankDetailsEdit(context);
        break;
      case 1:
        // _showBusinessEditScreen(context);
        break;
      case 2:
        // _showReportScreen(context);
        break;
      case 3:
        _showFeedbackDialog(context);
        break;
      case 4:
        // _showSubscriptionDialog(context);
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

  void _showBankDetailsEdit(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const EditBankDetailsDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || loginResponse == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    final size = MediaQuery.of(context).size;
    final theme = CustomTheme.getTheme(true);
    final w = size.width;
    final h = size.height;

    return SafeArea(
        top: false,
        bottom: true,
        child: Scaffold(
          backgroundColor: const Color(0xfff4f5f4),
          appBar: AppBar(
            backgroundColor: const Color(0xff0E3A2F),
            surfaceTintColor: const Color(0xff0E3A2F),
            leading: SizedBox.shrink(),
            title: const Text(
              "My Profile",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),

          body: SingleChildScrollView(
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
                            image: const DecorationImage(
                              image: NetworkImage(
                                "https://images.unsplash.com/photo-1414235077428-338989a2e8c0",
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            Utils.showProfilePhotoBottomSheet(context);
                          },
                          child: Container(
                            height: w * 0.09,
                            width: w * 0.09,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child:
                            Icon(Icons.edit_outlined, size: w * 0.045, color: theme!.primaryColor,),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: h * 0.015),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          loginResponse!.fullName ?? "",
                          style: TextStyle(
                            fontSize: w * 0.055,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: w * 0.015),
                        GestureDetector(
                            onTap: (){
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) => const EditUserNameDialog(),
                              );


                            },
                            child: Icon(Icons.edit_outlined,
                                size: w * 0.045, color:theme.primaryColor)),
                      ],
                    ),
                    SizedBox(height: h * 0.03),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(horizontal: w * 0.05),
                      padding: EdgeInsets.symmetric(
                        horizontal: w * 0.04,
                        vertical: h * 0.02,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(w * 0.04),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _detailItem(
                              icon: Icons.email_outlined,
                              title: "Email",
                              value: loginResponse!.userName?? "",
                              w: w,
                              showEdit: false,
                              theme: theme,
                              ontap: (){}
                          ),
                          const Divider(),
                          _detailItem(
                              icon: Icons.location_on_outlined,
                              title: "Address",
                              value:
                              "Al Marsa Street 57, Dubai Marina,\nPO Box 32923, Dubai",
                              w: w,
                              showEdit: true,
                              theme: theme,
                              ontap: (){}
                          ),
                          const Divider(),
                          _detailItem(
                              icon: Icons.phone_outlined,
                              title: "Mobile Number",
                              value: "980765432",
                              w: w,
                              showEdit: true,
                              theme: theme,
                              ontap: (){
                                // showModalBottomSheet(
                                //   context: context,
                                //   isScrollControlled: true,
                                //   backgroundColor: Colors.transparent,
                                //   builder: (context) => const EditMobileNumberDialog(),
                                // );

                              }
                          ),
                        ],
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.symmetric(horizontal: h*0.02),
                      child: ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: detailList.length,
                        separatorBuilder: (context, index) => Divider(height: 1),
                        itemBuilder: (context, index) {
                          final item = detailList[index];
                          return ListTile(
                            leading: Icon(item['icon'], size: w*0.054, color: Colors.black),
                            title: Text(item['name'], style: TextStyle(fontSize: 14)),
                            trailing: Icon(Icons.arrow_forward_ios, size: w*0.044),
                            onTap: () => _handleItemTap(index, context),
                          );
                        },
                      ),
                    ),

                    Center(
                      child: Container(
                        width: w * 0.55,
                        margin: EdgeInsets.only(top: h * 0.02),
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.logout, color: theme!.primaryColor, size: w * 0.05),
                          label: Text(
                            "Log Out",
                            style: TextStyle(
                              color: theme.primaryColor,
                              fontSize: w * 0.045,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFC8B531),
                            padding: EdgeInsets.symmetric(vertical: h * 0.018),
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
          ),
        )
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
        Icon(icon, color: Colors.grey[700], size: w * 0.06),
        SizedBox(width: w * 0.03),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: w * 0.034, color: Colors.grey),
              ),
              SizedBox(height: w * 0.01),
              Text(
                value,
                style: TextStyle(
                  fontSize: w * 0.040,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        if (showEdit)
          GestureDetector(
              onTap: ontap,
              child: Icon(Icons.edit, size: w * 0.045, color: theme!.primaryColor)),
      ],
    );
  }

}