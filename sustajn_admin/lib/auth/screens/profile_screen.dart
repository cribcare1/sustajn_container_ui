
import 'package:container_tracking/auth/model/login_model.dart';
import 'package:container_tracking/auth/screens/login_screen.dart';
import 'package:container_tracking/utils/SharedPreferenceUtils.dart';
import 'package:flutter/material.dart';

import '../../common_widgets/card_widget.dart';
import '../../common_widgets/custom_profile_paint.dart';
import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../../feedback_screen/feedback_list_screen.dart';
import '../../utils/theme_utils.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {

  @override
  void initState() {
    _getUserData();
    super.initState();
  }

  LoginData? loginModel;
  bool _isLoading  = false;
  Future<void> _getUserData() async {
    _isLoading = true;
    final Map<String, dynamic>? json =
    await SharedPreferenceUtils.getMapFromSF(Strings.PROFILE_DATA);

    if (json != null) {
      loginModel = LoginData.fromJson(json);

    }
    _isLoading = false;
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = CustomTheme.getTheme(true);
    final w = size.width;
    final h = size.height;
    return Scaffold(
      backgroundColor: theme!.primaryColor,
      appBar: AppBar(
        backgroundColor: theme.secondaryHeaderColor,
        surfaceTintColor: theme.secondaryHeaderColor,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(
          "My Profile",
          style: Theme.of(
            context,
          ).textTheme.titleMedium!.copyWith(color: Colors.white),
        ),
      ),

      body:_isLoading?Center(child: CircularProgressIndicator(),): SingleChildScrollView(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            SizedBox(
              width: w - (w * 0.34),
              height: h * 0.45,
              child: CustomPaint(painter: TopCirclePainter()),
            ),
            Column(
              children: [
                SizedBox(height: h * 0.1),
                //todo:- profile image
                // Stack(
                //   alignment: Alignment.bottomRight,
                //   children: [
                //     Container(
                //       height: w * 0.28,
                //       width: w * 0.28,
                //       decoration: BoxDecoration(
                //         shape: BoxShape.circle,
                //         border: Border.all(
                //           color: Colors.white,
                //           width: w * 0.012,
                //         ),
                //       ),
                //       child: ClipOval(
                //         child: Image.network(
                //           "https://images.unsplash.com/photo-1414235077428-338989a2e8c0",
                //           fit: BoxFit.cover,
                //           loadingBuilder: (context, child, loadingProgress) {
                //             if (loadingProgress == null) return child;
                //
                //             return Center(
                //               child: SizedBox(
                //                 height: w * 0.08,
                //                 width: w * 0.08,
                //                 child: const CircularProgressIndicator(
                //                   strokeWidth: 2,
                //                   color: Colors.green,
                //                 ),
                //               ),
                //             );
                //           },
                //           errorBuilder: (context, error, stackTrace) =>
                //               const Icon(Icons.error, color: Colors.red),
                //         ),
                //       ),
                //     ),
                //
                //     Container(
                //       height: w * 0.09,
                //       width: w * 0.09,
                //       decoration: const BoxDecoration(
                //         shape: BoxShape.circle,
                //         color: Colors.white,
                //       ),
                //       child: Icon(Icons.edit, size: w * 0.045),
                //     ),
                //   ],
                // ),

                SizedBox(height: h * 0.015),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                     loginModel!.fullName,
                      style: theme.textTheme.titleMedium
                    ),
                    SizedBox(width: w * 0.015),
                    Icon(Icons.edit, size: w * 0.045, color: Colors.white),
                  ],
                ),
                SizedBox(height: h * 0.03),
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal: Constant.CONTAINER_SIZE_16),
                  child: GlassSummaryCard(
                    child: Column(
                      children: [
                        _detailItem(
                          icon: Icons.email_outlined,
                          title: "Email",
                          value: loginModel!.userName,
                          w: w,
                          isRequired: false,
                        ),
                        const Divider(color: Colors.grey),
                        // _detailItem(
                        //   icon: Icons.location_on_outlined,
                        //   title: "Address",
                        //   value:
                        //       "Al Marsa Street 57, Dubai Marina,\nPO Box 32923, Dubai",
                        //   w: w,
                        //   isRequired: false,
                        // ),
                        // const Divider(color: Colors.grey),
                        _detailItem(
                          icon: Icons.phone_outlined,
                          title: "Mobile Number",
                          value: loginModel!.mobileNo,
                          w: w,
                          isRequired: true,
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: Constant.CONTAINER_SIZE_16),
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal: Constant.CONTAINER_SIZE_16),
                  child: InkWell(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FeedBackScreen(),
                        ),
                      );
                    },
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("FeedBack",style: Theme.of(context).textTheme.titleMedium),
                        Icon(Icons.arrow_forward_ios,size:20,color: Colors.white,)
                      ],
                    ),
                  ),
                ),
                SizedBox(height: Constant.CONTAINER_SIZE_16),
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
                        SharedPreferenceUtils.clearAll();
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
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

  Widget _detailItem({
    required IconData icon,
    required String title,
    required String value,
    required double w,
    required bool isRequired,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.white, size: w * 0.06),
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
                ),
              ),
            ],
          ),
        ),
        isRequired
            ? Icon(Icons.edit, size: w * 0.045, color: Colors.white)
            : const SizedBox(),
      ],
    );
  }
}
