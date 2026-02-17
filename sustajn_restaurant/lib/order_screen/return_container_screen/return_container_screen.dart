import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sustajn_restaurant/order_screen/return_container_screen/return_container_dialog.dart';
import 'package:sustajn_restaurant/order_screen/return_container_screen/review_return_screen.dart';

import '../../constants/network_urls.dart';
import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../../models/get_container_data.dart';
import '../../models/login_model.dart';
import '../../network_provider/network_provider.dart';
import '../../notifier/order_notifier.dart';
import '../../provider/order_provider.dart';
import '../../utils/theme_utils.dart';
import '../../utils/utility.dart';
import '../models/add_container_model.dart';

class ReturnContainerScreen extends ConsumerStatefulWidget {
  const ReturnContainerScreen({super.key});

  @override
  ConsumerState<ReturnContainerScreen> createState() =>
      _ReturnContainerScreenState();
}

class _ReturnContainerScreenState extends ConsumerState<ReturnContainerScreen> {
  final searchController = TextEditingController();

  List<GetContainerData> containerData = [];
  List<ContainersDetails> _filteredContainers = [];

  LoginData? loginResponse;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
    _getOrderNetworkCall();
  }

  Future<void> _loadProfile() async {
    await Utils.getProfile();
    setState(() {
      loginResponse = Utils.loginData?.data;
      isLoading = false;
    });
  }

  void _filterContainers(
      String query,
      List<ContainersDetails> containers,
      ) {
    final lowerQuery = query.toLowerCase();

    setState(() {
      if (query.isEmpty) {
        _filteredContainers = List.from(containers);
        return;
      }

      _filteredContainers = containers.where((item) {
        final name = item.containerName?.toLowerCase() ?? "";
        final id = item.containerUniqueId?.toString().toLowerCase() ?? "";

        return name.contains(lowerQuery) || id.contains(lowerQuery);
      }).toList();
    });
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final orderState = ref.watch(orderProvider);
    final containers =
        orderState.getContainerData?.containersDetails ?? [];

    if (_filteredContainers.isEmpty &&
        searchController.text.isEmpty &&
        containers.isNotEmpty) {
      _filteredContainers = List.from(containers);
    }


    return SafeArea(
      bottom: true,
      top: false,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
              child: Column(
                children: [
                  CustomTheme.searchField(
                    searchController,
                    Strings.SEARCH_BY_CONTAINER_NAME,
                    onChanged: (value) {
                      _filterContainers(value, containers);
                    },
                  ),
                  SizedBox(height: Constant.CONTAINER_SIZE_10),

                  Expanded(
                    child: orderState.isLoading
                        ? Center(child: CircularProgressIndicator())
                        : (orderState.getContainerData == null)?
                        Center(child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Return container list is not available",
                              style: theme.textTheme.titleMedium!.copyWith(color: Colors.white),
                            ),
                          ],
                        ),)
                        :orderState.getContainerData!.containersDetails!.isEmpty
                        ? Center(
                            child: Text(
                              Strings.NO_CONTAINER_AVAILABLE,
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        : ListView.separated(
                            itemCount: _filteredContainers.length,
                            separatorBuilder: (_, __) =>
                                SizedBox(height: Constant.CONTAINER_SIZE_12),
                            itemBuilder: (context, index) {
                              final item = _filteredContainers[index];
                              return _containerCard(context, item, theme);
                            },
                          ),
                  ),
                ],
              ),
            ),
            if (orderState.selectedContainers.isNotEmpty)
              Positioned(
                left: Constant.CONTAINER_SIZE_16,
                right: Constant.CONTAINER_SIZE_16,
                bottom: Constant.CONTAINER_SIZE_16,
                child: _bottomBar(context, orderState),
              ),
          ],
        ),
      ),
    );
  }

  Widget _bottomBar(BuildContext context, OrderState orderState) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Constant.CONTAINER_SIZE_16,
        vertical: Constant.CONTAINER_SIZE_12,
      ),
      decoration: BoxDecoration(
        color: Constant.gold,
        borderRadius:
        BorderRadius.circular(Constant.CONTAINER_SIZE_16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "${orderState.selectedContainers.length} Item Added",
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.primaryColor,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                  const ReviewReturnScreen(),
                ),
              );
            },
            child: Row(
              children: [
                Text("View",
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.primaryColor,
                    )),
                Icon(Icons.arrow_forward_ios,
                    size: Constant.CONTAINER_SIZE_14,
                    color: theme.primaryColor),
              ],
            ),
          )
        ],
      ),
    );
  }


  Widget _containerCard(
    BuildContext context,
    ContainersDetails item,
    ThemeData theme,
  ) {
    return Container(
      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_12),
      decoration: BoxDecoration(
        color: Constant.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
        border: Border.all(color: Constant.grey.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: Constant.CONTAINER_SIZE_50,
            height: Constant.CONTAINER_SIZE_50,
            decoration: BoxDecoration(
              color: Constant.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
            ),
            child: Image.asset("assets/images/cups.png", fit: BoxFit.contain),
          ),

          SizedBox(width: Constant.CONTAINER_SIZE_12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.containerName!,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: Constant.SIZE_04),
                Text(
                  item.containerUniqueId.toString(),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: Constant.SIZE_04),
                Text(
                  "${item.capacity.toString()} ml",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "Available Qty",
                style: theme.textTheme.bodySmall?.copyWith(color: Colors.white),
              ),
              Text(
                item.quantityAvailable.toString(),
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                ),
              ),

              SizedBox(height: Constant.SIZE_06),

              GestureDetector(
                onTap: () => _openAddDialog(context, item),
                child:
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: Constant.CONTAINER_SIZE_20,
                        vertical: Constant.SIZE_04,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          Constant.CONTAINER_SIZE_20,
                        ),
                        border: Border.all(color: Constant.gold),
                      ),
                      child: Text(
                        "Return",
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Constant.gold,
                        ),
                      ),
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _openAddDialog(BuildContext context, ContainersDetails item) async {
    final result = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: ReturnContainerDialog(item: item),
      ),
    );

    //todo needed later

    // if (result != null && result > 0) {
    //   setState(() {
    //     item.selectedQty = result;
    //     item.isAdded = true;
    //   });
    // }
  }

  _getOrderNetworkCall() async {
    try {
      await ref.read(networkProvider.notifier).isNetworkAvailable().then((
        isNetworkAvailable,
      ) {
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
