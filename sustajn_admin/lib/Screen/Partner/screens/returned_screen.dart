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
      case Strings.DIP:
        return Strings.WHITE_CONTAINER;
      case Strings.ROUND:
        return Strings.ROUND_CONTAINER;
      case Strings.RECTANGULAR:
        return Strings.RECTANGULAR_CONTAINER;
      default:
        return Strings.CUP_IMG;
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
      backgroundColor: Constant.PrimaryColor,
      appBar: CustomAppBar(
        title: Strings.RETURNED,
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
                  ? Center(child: Text(Strings.NO_RETURNED_CONTAINERS))
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
          colors: [Constant.green7, Constant.green8],
        ),
        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_14),
        border: Border.all(color: Constant.white3),
      ),
      child: Row(
        children: [
          Container(
            height: Constant.CONTAINER_SIZE_50,
            width: Constant.CONTAINER_SIZE_50,
            decoration: BoxDecoration(
              color: Constant.white1,
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
                    color: Constant.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: Constant.SIZE_04),
                Text(
                  product?.productId?.toString() ?? '',
                  style: TextStyle(
                    color: Constant.white3,
                    fontSize: Constant.CONTAINER_SIZE_12,
                  ),
                ),
                Text(
                  product?.capacity?.toString() ?? '',
                  style: TextStyle(
                    color: Constant.white4,
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
                color: Constant.white4,
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
                  color: Constant.black,
                  size: Constant.CONTAINER_SIZE_20,
                ),
                SizedBox(width: Constant.SIZE_06),
                Text(
                  Strings.SORT,
                  style: TextStyle(
                    color: Constant.black,
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
            color: Constant.black,
          ),

          InkWell(
            onTap: () {},
            child: Row(
              children: [
                Icon(
                  Icons.filter_list,
                  color: Constant.black,
                  size: Constant.CONTAINER_SIZE_20,
                ),
                SizedBox(width: Constant.SIZE_06),
                Text(
                  Strings.FILTER,
                  style: TextStyle(
                    color: Constant.black,
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
