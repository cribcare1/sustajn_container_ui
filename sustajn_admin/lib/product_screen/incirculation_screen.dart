import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../common_provider/network_provider.dart';
import '../common_widgets/card_widget.dart';
import '../common_widgets/submit_button.dart';
import '../common_widgets/submit_clear_button.dart';
import '../constants/network_urls.dart';
import '../constants/number_constants.dart';
import '../constants/string_utils.dart';
import '../container_list/model/container_list_model.dart';
import '../provider/order_provider.dart';
import '../utils/nav_utils.dart';
import '../utils/theme_utils.dart';
import '../utils/utility.dart';
import 'models/incirculation_data.dart';

class InCirculationScreen extends ConsumerStatefulWidget {
  const InCirculationScreen({super.key, required int restaurantId});

  @override
  ConsumerState<InCirculationScreen> createState() => _InCirculationScreenState();
}

class _InCirculationScreenState extends ConsumerState<InCirculationScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getIncirculationNetworkCall();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final orderState = ref.watch(orderProvider);
    final InCirculationData? inCirculationData = orderState.getInCirculationData;


    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
              child: CustomTheme.searchField(
                searchController,
                Strings.SEARCH_BY_CONTAINER_NAME,
                onChanged: (value){
                  orderState.filterInventoryByNameOrId(value);
                },
                onFilterTap: () => _showSortBottomSheet(context),
              ),
            ),
            SizedBox(height: Constant.SIZE_04),
            Expanded(
              child: orderState.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : orderState.getInCirculationData == null
                  ? const Center(
                child: Text(
                  Strings.NO_INCIRCULATION_AVAILABLE,
                  style: TextStyle(color: Colors.white),
                ),
              )
                  : orderState.getInCirculationData!.data == null ||
                  orderState.getInCirculationData!.data!.isEmpty
                  ? const Center(
                child: Text(
                  Strings.NO_CONTAINER_AVAILABLE,
                  style: TextStyle(color: Colors.white),
                ),
              )
                  : (orderState.filterInventory.isEmpty && searchController.text.isNotEmpty)
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      Strings.NO_CONTAINER_AVAILABLE,
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: Constant.LABEL_TEXT_SIZE_20),
                    SubmitButton(
                      onRightTap: () {
                        searchController.clear();
                        orderState.filterInventoryByNameOrId('');
                        setState(() {});
                      },
                      rightText: " Clear Filter ",
                    ),
                  ],
                ),
              )
                  : ListView.separated(
                padding: EdgeInsets.symmetric(
                    horizontal: Constant.CONTAINER_SIZE_16,
                    vertical: Constant.CONTAINER_SIZE_16
                ),
                itemCount: orderState.getInCirculationList.length,
                itemBuilder: (context, index) {
                  final item = orderState.getInCirculationList[index];

                  return inventoryItemCard(
                    context,
                    imageUrl: item.imageUrl ?? "",
                    name: item.name ?? "",
                    productId: item.productId ?? "-",
                    capacity: item.capacity?.toString() ?? "0",
                    inCirculationCount: item.inCirculationCount ?? 0,
                    containerTypeId : item.containerTypeId ?? 0,
                    // data: item,
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

  Widget inventoryItemCard(
      BuildContext context, {
        required String imageUrl,
        required String name,
        required String productId,
        required String capacity,
        required int inCirculationCount,
        required int containerTypeId,
        // required InventoryData data,
      }) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_20),
      onTap: () {
        // NavUtil.navigateToPushScreen(context, ContainersDetailsScreen(details: data,));
      },
      child: GlassSummaryCard(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            (imageUrl != "")
                ? Container(
              height: Constant.CONTAINER_SIZE_70,
              width: Constant.CONTAINER_SIZE_70,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(6),
              child: Image.network(
                "${NetworkUrls.CONTAINER_IMAGE_BASE_URL}$imageUrl",
                errorBuilder: (context, obj, stack) {
                  return Image.asset(
                    "assets/images/no_image_container.png",
                  );
                },
                fit: BoxFit.fill,
              ),
            )
                : Container(
              width: Constant.CONTAINER_SIZE_70,
              height: Constant.CONTAINER_SIZE_70,
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
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontSize: Constant.LABEL_TEXT_SIZE_16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white70,
                    ),
                  ),
                  // SizedBox(height: Constant.SIZE_04),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          productId,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: Constant.LABEL_TEXT_SIZE_14,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                      // SizedBox(width: Constant.CONTAINER_SIZE_100),
                      Text(
                        inCirculationCount.toString(),
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Constant.gold,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: Constant.SIZE_08),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: Constant.CONTAINER_SIZE_14,
                        color: Colors.white70,
                      ),
                    ],
                  ),
                  Text(
                    "$capacity ml",
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
    );
  }

  void _showSortBottomSheet(BuildContext context) {
    final orderState = ref.watch(orderProvider);

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
                      color: Theme.of(context).primaryColor,
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
                              child: Icon(Icons.cancel_rounded, color: Constant.gold),
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



  _getIncirculationNetworkCall() async {
    try {
      await ref.read(networkProvider.notifier).isNetworkAvailable().then((
          isNetworkAvailable,
          ) {
        Utils.printLog("isNetworkAvailable::$isNetworkAvailable");
        final orderState = ref.read(orderProvider);
        if (isNetworkAvailable) {
          orderState.setIsLoading(true);
          // final userId = Utils.userId;
          final url = '${NetworkUrls.PRODUCT_INCIRCULATION}';
              // '$userId';
          ref.read(getInCirculationProvider(url));
        } else {
          orderState.setIsLoading(false);
          Utils.showToast(Strings.NO_INTERNET_CONNECTION);
        }
      });
    } catch (e) {
      Utils.printLog('Error in visitor button onPressed: $e');
    }
  }
}
