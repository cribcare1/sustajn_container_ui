import 'package:flutter/material.dart';
import 'package:sustajn_customer/profile_screen/profile_screen.dart';
import 'package:sustajn_customer/search_resturant_screen/search_resturant_screen.dart';
import '../../../constants/number_constants.dart';
// import '../../../containers/customer_profile.dart';
import '../../../utils/nav_utils.dart';
import '../../payment_type/payment_screen.dart';
import '../../screens/map_screen.dart';
import '../dashboard.dart';


class HeaderWidget extends StatelessWidget {
  final String name;
  const HeaderWidget({Key? key, required this.name}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);


    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: Constant.CONTAINER_SIZE_16, vertical:Constant.CONTAINER_SIZE_12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: Constant.CONTAINER_SIZE_12),
          InkWell(
            onTap: (){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context)=> MyProfileScreen()));
            },
            child: CircleAvatar(
              radius: Constant.CONTAINER_SIZE_20,
              backgroundColor: Constant.grey,
              child: Icon(Icons.person, size: Constant.CONTAINER_SIZE_30, color: theme.primaryColor),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hi,', style: theme.textTheme.titleMedium?.copyWith(
                    color: Constant.subtitleText, fontSize: Constant.LABEL_TEXT_SIZE_14)),
                SizedBox(height: Constant.SIZE_02),
                Text(name, style: theme.textTheme.titleLarge?.copyWith(
                    color: Constant.profileText, fontSize: Constant.LABEL_TEXT_SIZE_20,
                    fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_26),
            onTap: () {
              NavUtil.navigateToPushScreen(context, SearchRestaurantScreen());
            },
            child: Container(
              padding: EdgeInsets.all(Constant.SIZE_08),
              decoration: BoxDecoration(
                color: Constant.grey.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(color: Constant.grey.withOpacity(0.2)),
              ),
              child: Icon(Icons.search, color: Constant.subtitleText, size: Constant.CONTAINER_SIZE_22),
            ),
          ),
            SizedBox(width: Constant.SIZE_10,),
            InkWell(
              borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_26),
              onTap: () {
              },
              child: Container(
                padding: EdgeInsets.all(Constant.SIZE_08),
                decoration: BoxDecoration(
                  color: Constant.grey.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: Constant.grey.withOpacity(0.2)),
                ),
                child: Icon(Icons.notifications_none, color: Constant.subtitleText, size: Constant.CONTAINER_SIZE_22),
              ),
            ),
        ],
      ),
    );
  }
}