import 'package:flutter/material.dart';
import '../../constants/network_urls.dart';
import '../../constants/number_constants.dart';
import 'model/borrowed_items.dart';
import 'model/detail_model.dart';

class ReceiveDetailsDialog extends StatelessWidget {
  final String title;
  List<BorrowedUiItem> item;

  ReceiveDetailsDialog({super.key, required this.title,
  required this.item});


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
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
                  title,
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
            SizedBox(height: Constant.SIZE_15,),
            _viewResturantDetails(theme, item.first),
            SizedBox(height: Constant.SIZE_08,),
            _header(theme, context, item.first),
            SizedBox(height: Constant.SIZE_15),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: item.length,
              separatorBuilder: (_, __) =>
                  SizedBox(height: Constant.SIZE_10),
              itemBuilder: (context, index) =>
                  _containerCard(item[index],
                      theme), ), ], ),
      ),

    );
  }

  Widget _header(ThemeData theme, BuildContext context, BorrowedUiItem item) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/img.png',
              height: Constant.CONTAINER_SIZE_40,
              width: Constant.CONTAINER_SIZE_40,
              color: Constant.gold,
            ),
            SizedBox(width: Constant.SIZE_08),
            Text(
              item.containerCount.toString(),
              style: theme.textTheme.headlineLarge?.copyWith(
                  color: Constant.gold
              ),
            ),
          ],
        ),
        Text(
          '${item.date} | ${item.time}',
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
      BorrowedUiItem item, ThemeData theme) {
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
          item.imageUrl != null && item.imageUrl.isNotEmpty
              ? ClipOval(
            child: Image.network(
              NetworkUrls.BASE_IMAGE_URL + item.imageUrl,
              fit: BoxFit.cover,
              width: Constant.CONTAINER_SIZE_40 * 2,
              height: Constant.CONTAINER_SIZE_40 * 2,
              errorBuilder: (context, o, s) {
                return Container(
                  width: Constant.CONTAINER_SIZE_50,
                  height: Constant.CONTAINER_SIZE_50,
                  decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(Constant.CONTAINER_SIZE_12),
                    color: Constant.grey,
                  ),
                  child: Image.asset('assets/images/cups.png',
                  fit: BoxFit.contain,)
                );
              },
            ),
          )
              : Container(
              width: Constant.CONTAINER_SIZE_50,
              height: Constant.CONTAINER_SIZE_50,
              decoration: BoxDecoration(
                borderRadius:
                BorderRadius.circular(Constant.CONTAINER_SIZE_12),
                color: Constant.grey,
              ),
              child: Image.asset('assets/images/cups.png',
                fit: BoxFit.contain,)
          ),
          SizedBox(width: Constant.CONTAINER_SIZE_12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.restaurantName,
                    style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white
                    )),
                SizedBox(height: Constant.SIZE_04),
                Text(item.productId.toString(),
                    style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white
                    )),
                SizedBox(height: Constant.SIZE_04),
                Text(
                  '${item.capacity}ml',
                    // item.capacity.toString(),
                    style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white
                    )),
              ],
            ),
          ),
          Text(
            item.containerCount.toString(),
            style: theme.textTheme.titleLarge?.copyWith(
              color: Constant.gold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _viewResturantDetails(ThemeData theme, BorrowedUiItem item) {
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
      child:
      Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                   item.restaurantName ,
                    style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white
                    )),
                SizedBox(height: Constant.SIZE_04),
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.white,size: Constant.SIZE_15,),
                    SizedBox(width: Constant.SIZE_05,),
                    Expanded(
                      child: Text(item.resturantAddress,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white,
                          )),
                    ),
                  ],
                ),
                SizedBox(height: Constant.SIZE_04),
                Center(
                  child: Text(
                      'View Resturant Details',
                      style: theme.textTheme.bodySmall?.copyWith(
                          color: Constant.gold
                      )),
                ),
              ],
            ),
          ),


    );
  }
}