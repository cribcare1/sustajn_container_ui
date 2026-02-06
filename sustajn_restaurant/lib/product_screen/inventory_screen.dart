import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sustajn_restaurant/common_widgets/submit_clear_button.dart';

import '../constants/network_urls.dart';
import '../constants/number_constants.dart';
import '../constants/string_utils.dart';
import '../containers/container_details.dart';
import '../models/get_container_data.dart';
import '../models/login_model.dart';
import '../network_provider/network_provider.dart';
import '../provider/order_provider.dart';
import '../utils/theme_utils.dart';
import '../utils/utility.dart';
import 'models/inventory_list.dart';

class InventoryScreen extends ConsumerStatefulWidget {
  const InventoryScreen({super.key});

  @override
  ConsumerState<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends ConsumerState<InventoryScreen> {
  TextEditingController searchController = TextEditingController();

  bool _isQtyAscending = true;

  List<GetContainerData> containerData = [];
  LoginData? loginResponse;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
    _getInventoryNetworkCall();
  }

  Future<void> _loadProfile() async {
    await Utils.getProfile();
    setState(() {
      loginResponse = Utils.loginData?.data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final orderState = ref.watch(orderProvider);

    return SafeArea(
      top: false,bottom: true,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
              child: CustomTheme.searchField(
                searchController,
                Strings.SEARCH_BY_CONTAINER_NAME,
                onFilterTap: () => _showSortBottomSheet(context),
              ),
            ),
            SizedBox(height: Constant.CONTAINER_SIZE_10),
            Expanded(
              child: orderState.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : orderState.getContainerData == null
                  ? const Center(
                child: Text( Strings.SOMETHING_WENT_WRONG,
                  style: TextStyle(color: Colors.white),
                ),
              )
                  : orderState.getContainerData!.containersDetails == null ||
                  orderState.getContainerData!.containersDetails!.isEmpty
                  ? const Center(
                child: Text(
                  Strings.NO_CONTAINER_AVAILABLE,
                  style: TextStyle(color: Colors.white),
                ),
              )
                  : ListView.builder(
                padding: EdgeInsets.symmetric(
                    horizontal: Constant.CONTAINER_SIZE_16),
                itemCount: orderState
                    .getContainerData!.containersDetails!.length,
                itemBuilder: (context, index) {
                  final item = orderState
                      .getContainerData!.containersDetails![index];

                  return inventoryItemCard(
                    context,
                    title: item.containerName ?? "-",
                    subTitle: item.containerUniqueId ?? "-",
                    volume: item.capacity?.toString() ?? "0",
                    qty: item.quantityAvailable ?? 0,
                  );
                },
              ),
            )
          ],
        ),
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
      borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_20),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ContainersDetailsScreen()),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: Constant.SIZE_08),
        decoration: BoxDecoration(
          color: Constant.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
          border: Border.all(color: Constant.grey, width: 0.3),
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
                        Expanded(
                          child: Text(
                            subTitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: Constant.LABEL_TEXT_SIZE_14,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                        SizedBox(width: Constant.CONTAINER_SIZE_100),
                        Text(
                          qty.toString(),
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
                      "$volume ml",
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

  void _showSortBottomSheet(BuildContext context) {
    final orderState = ref.watch(orderProvider);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        bool tempAscending = _isQtyAscending;

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
                          onTap: () {
                            Navigator.pop(context);
                          },
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
                        fillColor: MaterialStateProperty.resolveWith<Color>(
                              (states) {
                            if (states.contains(MaterialState.selected)) {
                              return Constant.gold; // selected
                            }
                            return Colors.white; // unselected
                          },
                        ),
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
                        activeColor: Constant.gold, // selected color
                        fillColor: MaterialStateProperty.resolveWith<Color>(
                              (states) {
                            if (states.contains(MaterialState.selected)) {
                              return Constant.gold; // selected
                            }
                            return Colors.white; // unselected
                          },
                        ),
                        onChanged: (value) {
                          setModalState(() {
                            tempAscending = value!;
                          });
                        },
                      ),
                    ),

                    SizedBox(height: Constant.CONTAINER_SIZE_20),
                    SubmitClearButton(onLeftTap: (){setState(() {
                      _isQtyAscending = true;
                      orderState.getContainerData!.containersDetails!.sort(
                            (a, b) => a.quantityAvailable!.compareTo(b.quantityAvailable!),
                      );
                    });
                    Navigator.pop(context);},
                        leftText: Strings.CLEAR,
                        onRightTap: (){
                          setState(() {
                            _isQtyAscending = tempAscending;
                            orderState.getContainerData!.containersDetails!.sort(
                                  (a, b) => _isQtyAscending
                                  ? a.quantityAvailable!.compareTo(b.quantityAvailable!)
                                  : b.quantityAvailable!.compareTo(a.quantityAvailable!),
                            );
                          });
                          Navigator.pop(context);
                        },rightText: Strings.APPLY,)
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

_getInventoryNetworkCall() async {
    try {
      await ref.read(networkProvider.notifier).isNetworkAvailable().then(
              (isNetworkAvailable) {
            Utils.printLog("isNetworkAvailable::$isNetworkAvailable");
            final orderState = ref.read(orderProvider);
            if (isNetworkAvailable) {
              orderState.setIsLoading(true);
              final userId = Utils.userId;
              final url = '${NetworkUrls.GET_CONTAINER}$userId';
              ref.read(getOrderProvider(url));
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
