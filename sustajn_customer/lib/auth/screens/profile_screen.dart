import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common_widgets/custom_cricle_painter.dart';
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
  final List<Map<String, dynamic>> menuList = [
    {"title": "History", "icon": Icons.history},
    {"title": "Payment Type", "icon": Icons.currency_rupee},
    {"title": "QR Code", "icon": Icons.qr_code},
    {"title": "Feedback", "icon": Icons.star_border},
    {"title": "Subscription Plan", "icon": Icons.credit_card},
    {"title": "Contact us", "icon": Icons.headset_mic},
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
        _showHistoryScreen(context);
        break;
      case 1:
        // _showBusinessEditScreen(context);
        break;
      case 2:
        // _showReportScreen(context);
        break;
      case 3:
        _showFeedBackScreen(context);
        break;
      case 4:
        // _showSubscriptionDialog(context);
        break;
    }
  }

  void _showHistoryScreen(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context)=>HistoryScreen()));
  }
  void _showFeedBackScreen(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const FeedbackBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = CustomTheme.getTheme(true);
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xff0E3A2F),

      /// APP BAR
      appBar: AppBar(
        backgroundColor: const Color(0xFFD4AE37),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "My Profile",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [

            /// PROFILE IMAGE
            const SizedBox(height: 20),
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: w * 0.14,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: w * 0.13,
                    backgroundImage: const NetworkImage(
                      "https://images.unsplash.com/photo-1414235077428-338989a2e8c0",
                    ),
                  ),
                ),
                CircleAvatar(
                  radius: w * 0.045,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.edit,
                    size: w * 0.045,
                    color: theme!.primaryColor,
                  ),
                )
              ],
            ),

            const SizedBox(height: 12),

            /// NAME
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "John Dee",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.edit, size: 18, color: theme!.primaryColor),
              ],
            ),

            const SizedBox(height: 25),

            /// PROFILE DETAILS CARD
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xff144A3A),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _infoRow(Icons.email, "Email", "hello597@gmail.com"),
                  const Divider(color: Colors.white24),
                  _infoRow(
                    Icons.location_on,
                    "Address",
                    "Al Marsa Street 57, Dubai Marina,\nPO Box 32923, Dubai",
                    editable: true,
                  ),
                  const Divider(color: Colors.white24),
                  _infoRow(
                    Icons.phone,
                    "Mobile Number",
                    "980765432",
                    editable: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// MENU LIST
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: List.generate(menuList.length, (index) {
                  return Column(
                    children: [
                      InkWell(
                        onTap:(){
                          if(menuList[index]['title']=='Feedback') {
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.transparent,
                              isScrollControlled: true,
                              builder: (_) => const FeedbackBottomSheet(),
                            );
                          }
                  },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          child: Row(
                            children: [
                              Icon(
                                menuList[index]['icon'],
                                color: const Color(0xFFD4AE37),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Text(
                                  menuList[index]['title'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap:() => _handleItemTap(index, context),

                          child: const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Divider(color: Colors.white24),
                    ],
                  );
                }),
              ),
            ),

            const SizedBox(height: 30),

            /// LOGOUT BUTTON
            OutlinedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.logout, color: theme.primaryColor),
              label: Text(
                "Log out",
                style: TextStyle(
                  color: theme.primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: theme.primaryColor),
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  /// INFO ROW WIDGET
  Widget _infoRow(
      IconData icon,
      String title,
      String value, {
        bool editable = false,
      }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFFD4AE37)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
        if (editable)
          const Icon(Icons.edit, color: Color(0xFFD4AE37), size: 18),
      ],
    );
  }
}