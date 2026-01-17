import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  const InventoryScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends ConsumerState<InventoryScreen> {
  TextEditingController searchController = TextEditingController();

  bool _isQtyAscending = true;

  final List<InventoryItem> inventoryList = [
    InventoryItem(
      title: 'Dip Cup',
      subTitle: 'ST-DC-50',
      volume: '20 L',
      qty: 132,
    ),
    InventoryItem(
      title: 'Dip Cup',
      subTitle: 'ST-DC-50',
      volume: '10 L',
      qty: 1900,
    ),
  ];

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

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
            child: CustomTheme.searchField(
              searchController,
              "Search Containers",
              onFilterTap: () => _showSortBottomSheet(context),
            ),
          ),
          SizedBox(height: Constant.CONTAINER_SIZE_10),
          Expanded(
            child: orderState.isLoading
                ? Center(child: CircularProgressIndicator())
                : orderState.getContainerData!.containersDetails!.isEmpty
                ? Center(
              child: Text("No containers found", style: TextStyle(color: Colors.white),),
            )
                : ListView.builder(
              padding: EdgeInsets.symmetric(horizontal:  Constant.CONTAINER_SIZE_16),
              itemCount: orderState.getContainerData!.containersDetails!.length,
              itemBuilder: (context, index) {
                final item = orderState.getContainerData!.containersDetails![index];
                return inventoryItemCard(
                  context,
                  title: item.containerName!,
                  subTitle: item.containerUniqueId!,
                  volume: item.capacity.toString(),
                  qty: item.quantityAvailable!,
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
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        bool tempAscending = _isQtyAscending;

        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
              decoration: BoxDecoration(
                color: Color(0xFF0F2E22),
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
                      onChanged: (value) {
                        setModalState(() {
                          tempAscending = value!;
                        });
                      },
                    ),
                  ),

                  SizedBox(height: Constant.CONTAINER_SIZE_20),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Constant.gold),
                            foregroundColor: Constant.gold,
                            padding: EdgeInsets.symmetric(
                              vertical: Constant.CONTAINER_SIZE_14,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              _isQtyAscending = true;
                              inventoryList.sort(
                                (a, b) => a.qty.compareTo(b.qty),
                              );
                            });
                            Navigator.pop(context);
                          },
                          child: Text(Strings.CLEAR),
                        ),
                      ),

                      SizedBox(width: Constant.CONTAINER_SIZE_12),

                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Constant.gold,
                            foregroundColor: Colors.black,
                            padding: EdgeInsets.symmetric(
                              vertical: Constant.CONTAINER_SIZE_14,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              _isQtyAscending = tempAscending;
                              inventoryList.sort(
                                (a, b) => _isQtyAscending
                                    ? a.qty.compareTo(b.qty)
                                    : b.qty.compareTo(a.qty),
                              );
                            });
                            Navigator.pop(context);
                          },
                          child: Text(Strings.APPLY),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
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
