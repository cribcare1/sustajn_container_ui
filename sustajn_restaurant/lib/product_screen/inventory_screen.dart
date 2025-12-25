import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/number_constants.dart';
import '../containers/container_details.dart';
import '../utils/theme_utils.dart';
import 'models/inventory_list.dart';

class InventoryScreen extends StatelessWidget {


   InventoryScreen({Key? key,
   }) : super(key: key);

  final List<InventoryItem> inventoryList = [
    InventoryItem(
      title: 'Dip Cup',
      subTitle: 'ST-DC-50',
      volume: '20 L',
      qty: 15,
    ),
    InventoryItem(
      title: 'Dip Cup',
      subTitle: 'ST-DC-50',
      volume: '10 L',
      qty: 30,
    ),
  ];
   TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          CustomTheme.searchField(searchController, "search Containers"),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: inventoryList.length,
              itemBuilder: (context, index) {
                final item = inventoryList[index];

                return inventoryItemCard(
                  context,
                  title: item.title,
                  subTitle: item.subTitle,
                  volume: item.volume,
                  qty: item.qty,
                );
              },
            ),
          ),
        ],
      ),
    );

  }

  Widget inventoryItemCard(
      BuildContext context, {
        required String title,
        required String subTitle,
        required String volume,
        required int qty,
      }) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: (){
        Navigator.push(context,
        MaterialPageRoute(builder: (context)=> ContainersDetailsScreen()));
      },
      child: Container(
        margin: EdgeInsets.only(
          bottom: Constant.SIZE_10,
        ),
        decoration: BoxDecoration(
          color: Constant.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
          border: Border.all(
            color: Constant.grey,
                width: 0.3
          )
        ),
        child: Padding(
          padding: EdgeInsets.all(Constant.CONTAINER_SIZE_12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: Constant.CONTAINER_SIZE_56,
                height: Constant.CONTAINER_SIZE_56,
                decoration: BoxDecoration(
                  color: Constant.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(Constant.SIZE_08),
                ),
                child: Center(
                  child: Icon(
                    Icons.inbox,
                    size: Constant.CONTAINER_SIZE_30,
                    color: Colors.white,
                  ),
                ),
              ),

              SizedBox(width: Constant.CONTAINER_SIZE_12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: Constant.LABEL_TEXT_SIZE_16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white70,
                      ),
                    ),
                    SizedBox(height: Constant.SIZE_04),
                    Row(
                      children: [
                        Text(
                          subTitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: Constant.LABEL_TEXT_SIZE_14,
                            color: Colors.white70,
                          ),
                        ),
                        SizedBox(width: 140,),
                        Text(
                          qty.toString(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Constant.gold,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        SizedBox(width: 12,),
                        Icon(Icons.arrow_forward_ios,
                          size: Constant.CONTAINER_SIZE_14,color: Colors.white70,)

                      ],
                    ),
                    Text(
                      volume,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: Constant.LABEL_TEXT_SIZE_14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }

}