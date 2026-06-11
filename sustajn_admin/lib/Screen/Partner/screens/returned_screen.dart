import 'package:container_tracking/common_widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common_provider/network_provider.dart';
import '../../../common_widgets/custom_back_button.dart';
import '../../../common_widgets/custom_search_bar.dart';
import '../../../constants/network_urls.dart';
import '../../../constants/number_constants.dart';
import '../../../constants/string_utils.dart';
import '../../../utils/utility.dart';
import '../model/container_history_data.dart';
import '../provider/provider/product_provider.dart';

class ReturnedScreen extends ConsumerStatefulWidget {
  final int restaurantId;

  const ReturnedScreen({super.key, required this.restaurantId});

  @override
  ConsumerState<ReturnedScreen> createState() => _ReturnedScreenState();
}

class _ReturnedScreenState extends ConsumerState<ReturnedScreen> {

  String getContainerImage(String type) {
    switch (type) {
      case "dip":
        return "assets/images/white_container.png";
      case "round":
        return "assets/images/round_container.png";
      case "rectangular":
        return "assets/images/rectangular_container.png";
      default:
        return "assets/images/cups.png";
    }
  }

  List<LeasedResponses> filteredItems = [];

  @override
  void initState() {
    super.initState();
    _getReturnedContainerCall();
  }

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(productProvider);
    final container =
        productState.containerHistorydata?.data?.leasedResponses ?? [];
    if (filteredItems.isEmpty && container.isNotEmpty) {
      filteredItems = container;
    }
    return Scaffold(
      backgroundColor: Color(0xFF0E3B2E),
      appBar: CustomAppBar(
        title: "Returned",
        leading: CustomBackButton(),
      ).getAppBar(context),
      body: SafeArea(
        child: Column(
          children: [
            CustomSearchBar(
              hintText: Strings.SEARCH_CONTAINER_NAME,
              onChanged: (value) {
                setState(() {
                  if (value.isEmpty) {
                    filteredItems = container;
                  } else {
                    filteredItems = container.where((item) {
                      return item.productsName!.toLowerCase().contains(
                        value.toLowerCase(),
                      );
                    }).toList();
                  }
                });
              },
            ),
            SizedBox(height: Constant.CONTAINER_SIZE_16),
            Expanded(
              child: productState.isLoading
                  ? Center(child: CircularProgressIndicator())
                  : productState.containerHistorydata?.data == null
                  ? Center(child: Text("No returned products found"))
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: Constant.CONTAINER_SIZE_16,
                      ),
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        return _cardItem(item);
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: _filterButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _cardItem(LeasedResponses item) {
    final product = item.productOrderListResponses?.isNotEmpty == true
        ? item.productOrderListResponses!.first
        : null;
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.only(bottom: Constant.CONTAINER_SIZE_12),
      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1F5A46), Color(0xFF0E3B2E)],
        ),
        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_14),
        border: Border.all(color: Colors.white70),
      ),
      child: Row(
        children: [
          Container(
            height: Constant.CONTAINER_SIZE_50,
            width: Constant.CONTAINER_SIZE_50,
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_10),
            ),
            child: Image.asset(
              getContainerImage(product?.productImageUrl ?? ''),
            ),
          ),
          SizedBox(width: Constant.CONTAINER_SIZE_12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productsName!,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: Constant.SIZE_04),
                Text(
                  product?.productId?.toString() ?? '',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: Constant.CONTAINER_SIZE_12,
                  ),
                ),
                Text(
                  product?.capacity?.toString() ?? '',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: Constant.CONTAINER_SIZE_11,
                  ),
                ),
              ],
            ),
          ),

          Row(
            children: [
              Text(
                product?.containerCount?.toString() ?? '',
                style: TextStyle(
                  color: theme.secondaryHeaderColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: Constant.SIZE_06),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.white54,
                size: Constant.CONTAINER_SIZE_14,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _filterButton() {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Constant.CONTAINER_SIZE_18,
        vertical: Constant.CONTAINER_SIZE_12,
      ),
      decoration: BoxDecoration(
        color: theme.secondaryHeaderColor,
        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () {},
            child: Row(
              children: [
                Icon(
                  Icons.sort,
                  color: Colors.black,
                  size: Constant.CONTAINER_SIZE_20,
                ),
                SizedBox(width: Constant.SIZE_06),
                Text(
                  Strings.SORT,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: Constant.CONTAINER_SIZE_12,
            ),
            height: Constant.CONTAINER_SIZE_18,
            width: Constant.SIZE_02,
            color: Colors.black26,
          ),

          InkWell(
            onTap: () {},
            child: Row(
              children: [
                Icon(
                  Icons.filter_list,
                  color: Colors.black,
                  size: Constant.CONTAINER_SIZE_20,
                ),
                SizedBox(width: Constant.SIZE_06),
                Text(
                  Strings.FILTER,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _getReturnedContainerCall() async {
    try {
      await ref.read(networkProvider.notifier).isNetworkAvailable().then((
        isNetworkAvailable,
      ) {
        Utils.printLog("isNetworkAvailable::$isNetworkAvailable");
        final orderState = ref.read(productProvider);
        if (isNetworkAvailable) {
          orderState.setIsLoading(true);
          final url = '${NetworkUrls.RETURN_PRODUCTS}${widget.restaurantId}';
          ref.read(returnedContainerProvider(url));
        } else {
          orderState.setIsLoading(false);
          Utils.showToast(Strings.NO_INTERNET_CONNECTION);
        }
      });
    } catch (e) {
      Utils.printLog('Error on network call: $e');
    }
  }
}
