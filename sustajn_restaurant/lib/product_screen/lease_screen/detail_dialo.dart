import 'package:flutter/material.dart';
import '../../constants/number_constants.dart';
import '../models/lease_model.dart';

class LeaseDetailsDialog extends StatelessWidget {
  final String customerId;
  final String dateTime;

  LeaseDetailsDialog({super.key, required this.customerId, required this.dateTime});

  final List<LeasedContainer> containers = [
    LeasedContainer(
      name: "Dip Cups",
      code: "ST-DC-50",
      volume: "50ml",
      qty: 3,
      image: "assets/images/cups.png",
    ),
    LeasedContainer(
      name: "Round Container",
      code: "ST-RDC-500",
      volume: "500ml",
      qty: 5,
      image: "assets/images/cups.png",
    ),
    LeasedContainer(
      name: "Rectangular Container",
      code: "ST-RC-600",
      volume: "900ml",
      qty: 2,
      image: "assets/images/cups.png",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Constant.CONTAINER_SIZE_30),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _header(theme, context),
          SizedBox(height: Constant.SIZE_15),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: containers.length,
            separatorBuilder: (_, __) =>
                SizedBox(height: Constant.SIZE_10),
            itemBuilder: (context, index) =>
                _containerCard(containers[index],
                theme), ), ], ),

    );
  }

  Widget _header(ThemeData theme, BuildContext context) {
    return Column(
      children: [
        Container(
          width: Constant.CONTAINER_SIZE_60,
          height: Constant.SIZE_05,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Constant.SIZE_05),
            color: Colors.white
            ,
          ),
        ),
        SizedBox(height: Constant.SIZE_15),
        Row(
          children: [
            Text(
              "Leased Details",
              style: theme.textTheme.titleLarge?.copyWith(
                color: Colors.white
              ),
            ),
            Spacer(),
            InkWell(
              onTap: ()=> Navigator.pop(context),
                child: Icon(Icons.close,
                    color: Colors.white,))
          ],
        ),
        SizedBox(height: Constant.SIZE_08),
        Row(
          children: [
            Icon(Icons.person_outline, size: Constant.SIZE_18,
            color: Colors.white,),
            SizedBox(width: Constant.SIZE_08),
            Expanded(
              child: Text(
                "Customer ID: $customerId",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: Constant.SIZE_15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Image.asset('assets/images/img.png',
            height: 40,
            width: 40,
          ),
            SizedBox(width: Constant.SIZE_08),
            Text(
              "3",
              style: theme.textTheme.headlineLarge?.copyWith(
                color: Colors.white
              ),
            ),
          ],
        ),
        Text(
          dateTime,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall?.copyWith(
            fontSize: Constant.LABEL_TEXT_SIZE_14,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _containerCard(
      LeasedContainer item, ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_12),
      decoration: BoxDecoration(
        color: Constant.grey.withOpacity(0.2),
        borderRadius:
        BorderRadius.circular(Constant.CONTAINER_SIZE_15),
        border: Border.all(
          color: Constant.grey.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: Constant.CONTAINER_SIZE_50,
            height: Constant.CONTAINER_SIZE_50,
            decoration: BoxDecoration(
              borderRadius:
              BorderRadius.circular(Constant.CONTAINER_SIZE_12),
              color: Constant.grey,
            ),
            child: Image.asset(item.image, fit: BoxFit.contain),
          ),
          SizedBox(width: Constant.CONTAINER_SIZE_12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white
                    )),
                SizedBox(height: Constant.SIZE_04),
                Text(item.code,
                    style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white
                    )),
                SizedBox(height: Constant.SIZE_04),
                Text(item.volume,
                    style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white
                    )),
              ],
            ),
          ),
          Text(
            item.qty.toString(),
            style: theme.textTheme.titleLarge?.copyWith(
              color: Constant.gold,
            ),
          ),
        ],
      ),
    );
  }
}
