import 'package:flutter/material.dart';

import '../../common_widgets/custom_profile_paint.dart';
import '../../constants/number_constants.dart';
import '../../feedback_screen/feedback_list_screen.dart';
import '../../utils/theme_utils.dart';


class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = CustomTheme.getTheme(true);
    final w = size.width;
    final h = size.height;

    return Scaffold(
      backgroundColor: const Color(0xfff4f5f4),

      appBar: AppBar(
        backgroundColor: const Color(0xff0E3A2F),
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
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
                    Container(
                      height: w * 0.09,
                      width: w * 0.09,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Icon(Icons.edit, size: w * 0.045),
                    ),
                  ],
                ),

                SizedBox(height: h * 0.015),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Marina Sky Dine",
                      style: TextStyle(
                        fontSize: w * 0.055,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: w * 0.015),
                    Icon(Icons.edit, size: w * 0.045, color: Colors.green),
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
                        value: "hello597@gmail.com",
                        w: w,
                        showEdit: false
                      ),
                      const Divider(),
                      _detailItem(
                        icon: Icons.location_on_outlined,
                        title: "Address",
                        value:
                        "Al Marsa Street 57, Dubai Marina,\nPO Box 32923, Dubai",
                        w: w,
                        showEdit: true
                      ),
                      const Divider(),
                      _detailItem(
                        icon: Icons.phone_outlined,
                        title: "Mobile Number",
                        value: "980765432",
                        w: w,
                        showEdit: true
                      ),
                    ],
                  ),
                ),


                SizedBox(height: Constant.CONTAINER_SIZE_40,),
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
                        Navigator.push(context,
                        MaterialPageRoute(builder: (context)=> FeedBackScreen()));
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

// Update _detailItem to include showEdit parameter
  Widget _detailItem({
    required IconData icon,
    required String title,
    required String value,
    required double w,
    bool showEdit = true, // new parameter
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
          Icon(Icons.edit, size: w * 0.045, color: Colors.green), // only show if true
      ],
    );
  }


}
