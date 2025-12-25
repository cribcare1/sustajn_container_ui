import 'package:flutter/material.dart';
import '../../../constants/number_constants.dart';
import '../../../containers/customer_profile.dart';
import '../../screens/map_screen.dart';


class HeaderWidget extends StatelessWidget {
  final String name;
  const HeaderWidget({Key? key, required this.name}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;


    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: Constant.CONTAINER_SIZE_16, vertical:Constant.CONTAINER_SIZE_12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: Constant.CONTAINER_SIZE_12),
          InkWell(
            onTap: (){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context)=> MapScreen()));
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
                Text('Hi,', style: textTheme.titleMedium?.copyWith(
                    color: Constant.subtitleText, fontSize: Constant.LABEL_TEXT_SIZE_14)),
                SizedBox(height: Constant.SIZE_02),
                Text(name, style: textTheme.titleLarge?.copyWith(
                    color: Constant.profileText, fontSize: Constant.LABEL_TEXT_SIZE_20,
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
                  border: Border.all(color: Constant.card.withOpacity(0.3)),
                ),
                child: Icon(Icons.notifications_none, color: Constant.subtitleText, size: Constant.CONTAINER_SIZE_22),
              ),
            ),
          )
        ],
      ),
    );
  }
}