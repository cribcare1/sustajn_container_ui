import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common_provider/network_provider.dart';
import '../../../common_widgets/card_widget.dart';
import '../../../common_widgets/submit_button.dart';
import '../../../common_widgets/submit_clear_button.dart';
import '../../../constants/network_urls.dart';
import '../../../constants/number_constants.dart';
import '../../../constants/string_utils.dart';
import '../../../provider/order_provider.dart';
import '../../../utils/theme_utils.dart';
import '../../../utils/utility.dart';
import '../../Partner/model/get_container_data.dart';
import '../provider/user_provider.dart';


class UsersActiveScreen extends ConsumerStatefulWidget {
  final int? userId;

  const UsersActiveScreen({super.key, required this.userId});

  @override
  ConsumerState<UsersActiveScreen> createState() => _UsersActiveScreenState();
}

class _UsersActiveScreenState extends ConsumerState<UsersActiveScreen> {
  //TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getUsersActiveNetworkCall();
  }

  @override
  Widget build(BuildContext context) {
    final userProviders = ref.watch(userProvider);

    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        body: Column(
          children: [

            Expanded(
              child: userProviders.isLoading
                  ? const Center(child: CircularProgressIndicator())
              //     : userProviders.productDataList! == null
              //     ? Center(
              //   child: Text(
              //     Strings.SOMETHING_WENT_WRONG,
              //     style: TextStyle(color: Colors.white),
              //   ),
              // )
                  : userProviders.productList.isEmpty
                  ? const Center(
                child: Text(
                  Strings.NO_CONTAINER_AVAILABLE,
                  style: TextStyle(color: Colors.white),
                ),
              )
              //     : Center(
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Text(
              //         Strings.NO_CONTAINER_AVAILABLE,
              //         style: TextStyle(color: Colors.white),
              //       ),
              //       SizedBox(height: Constant.LABEL_TEXT_SIZE_20),
              //       SubmitButton(
              //         onRightTap: () {
              //           searchController.clear();
              //           userProviders.filterInventoryByNameOrId('');
              //           setState(() {});
              //         },
              //         rightText: " Clear Filter ",
              //       ),
              //     ],
              //   ),
              // )
                  : ListView.separated(
                padding: EdgeInsets.symmetric(
                  horizontal: Constant.CONTAINER_SIZE_16,
                  vertical: Constant.CONTAINER_SIZE_16,
                ),
                itemCount: userProviders.productList.length,
                itemBuilder: (context, index) {
                  final item = userProviders.productList[index];

                  return inventoryItemCard(
                    context,
                    image: item.productImageUrl ?? "",
                    title: item.productName ?? "-",
                    subTitle: item.productUniqueId ?? "-",
                    volume: item.containerQuantity?.toString() ?? "0",
                    qty: item.quantity ?? 0,
                    date: item.dueDate ?? "",
                  );
                },
                separatorBuilder: (context, index) =>
                    SizedBox(height: Constant.CONTAINER_SIZE_10),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget inventoryItemCard(BuildContext context, {
    required String image,
    required String title,
    required String subTitle,
    required String volume,
    required int qty,
    required String date,
  }) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_20),
      onTap: () {},
      child: GlassSummaryCard(
        child: Row(
          children: [

            Container(
              height: Constant.CONTAINER_SIZE_70,
              width: Constant.CONTAINER_SIZE_70,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(Constant.SIZE_08),
              ),
              padding: EdgeInsets.all(Constant.SIZE_06),
              child: image.isNotEmpty
                  ? Image.network(
                "${NetworkUrls.CONTAINER_IMAGE_BASE_URL}$image",
                fit: BoxFit.fill,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    "assets/images/white_container.png",
                  );
                },
              )
                  : Icon(
                Icons.inbox,
                size: Constant.CONTAINER_SIZE_30,
                color: Colors.white,
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
                      color: Colors.white,
                    ),
                  ),

                  SizedBox(height: Constant.SIZE_04),

                  Text(
                    subTitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white70,
                    ),
                  ),

                  SizedBox(height: Constant.SIZE_04),

                  Text(
                    "$volume ml",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),


            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      Strings.BOWL_IMG,
                      height: 14,
                      width: 14,
                    ),
                    SizedBox(width: 4),
                    Text(
                      qty.toString(),
                      style: TextStyle(
                        color: Constant.gold,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 4),

                Text(
                  "Due on: $date ",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  void _showSortBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Consumer(
          builder: (context, ref, _) {
            final orderState = ref.watch(orderProvider);
            bool tempAscending = orderState.isQtyAscending;

            return SafeArea(
              top: false,
              child: StatefulBuilder(
                builder: (context, setModalState) {
                  return Container(
                    padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
                    decoration: BoxDecoration(
                      color: Theme
                          .of(context)
                          .primaryColor,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(Constant.CONTAINER_SIZE_20),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              Strings.SORT_BY,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: Constant.CONTAINER_SIZE_18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Icon(
                                Icons.cancel_rounded,
                                color: Constant.gold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: Constant.CONTAINER_SIZE_16),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            "Quantity : Low to High",
                            style: TextStyle(color: Colors.white),
                          ),
                          trailing: Radio<bool>(
                            value: true,
                            groupValue: tempAscending,
                            activeColor: Constant.gold,
                            fillColor: MaterialStateProperty.all(Constant.gold),
                            onChanged: (value) {
                              setModalState(() {
                                tempAscending = value!;
                              });
                            },
                          ),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            "Quantity : High to Low",
                            style: TextStyle(color: Colors.white),
                          ),
                          trailing: Radio<bool>(
                            value: false,
                            groupValue: tempAscending,
                            activeColor: Constant.gold,
                            fillColor: MaterialStateProperty.all(Constant.gold),
                            onChanged: (value) {
                              setModalState(() {
                                tempAscending = value!;
                              });
                            },
                          ),
                        ),
                        SizedBox(height: Constant.CONTAINER_SIZE_20),
                        SubmitClearButton(
                          onLeftTap: () {
                            ref.read(orderProvider).resetSort();
                            Navigator.pop(context);
                          },
                          leftText: Strings.CLEAR,
                          onRightTap: () {
                            ref
                                .read(orderProvider)
                                .sortByQuantity(tempAscending);
                            Navigator.pop(context);
                          },
                          rightText: Strings.APPLY,
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  _getUsersActiveNetworkCall() async {
    try {
      await ref.read(networkProvider.notifier).isNetworkAvailable().then((
          isNetworkAvailable,) {
        Utils.printLog("isNetworkAvailable::$isNetworkAvailable");
        final userProviders = ref.read(userProvider);
        if (isNetworkAvailable) {
          userProviders.setIsLoading(true);
          final url = '${NetworkUrls.PRODUCT_DATA}${widget
              .userId}';
          ref.read(userActiveProvider(url));
        } else {
          userProviders.setIsLoading(false);
          Utils.showToast(Strings.NO_INTERNET_CONNECTION);
        }
      });
    } catch (e) {
      Utils.printLog('Error in visitor button onPressed: $e');
    }
  }
}