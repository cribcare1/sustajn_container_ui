import 'package:flutter/material.dart';
import 'package:sustajn_customer/auth/screens/profile_screen.dart';
import '../../../constants/number_constants.dart';
import '../../screens/map_screen.dart';


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
              radius: Constant.CONTAINER_SIZE_26,
              backgroundColor: Constant.card,
              child: Icon(Icons.person, size: Constant.CONTAINER_SIZE_30, color: Constant.profileText),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hi,', style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.black, fontSize: Constant.LABEL_TEXT_SIZE_14)),
                SizedBox(height: Constant.SIZE_02),
                Text(name, style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.black, fontSize: Constant.LABEL_TEXT_SIZE_20,
                    fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_26),
              onTap: () {},
              child: Container(
                padding: EdgeInsets.all(Constant.SIZE_08),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: theme.primaryColor.withOpacity(0.3)),
                ),
                child: Icon(Icons.notifications_none, color: theme.primaryColor, size: Constant.CONTAINER_SIZE_22),
              ),
            ),
          )
        ],
      ),
    );
  }
}