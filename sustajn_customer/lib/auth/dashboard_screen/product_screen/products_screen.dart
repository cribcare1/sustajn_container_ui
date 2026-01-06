import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sustajn_customer/common_widgets/custom_app_bar.dart';
import 'package:sustajn_customer/common_widgets/custom_back_button.dart';
import 'package:sustajn_customer/provider/product_provider/product_provider.dart';

import '../../../constants/network_urls.dart';
import '../../../constants/number_constants.dart';
import '../../../constants/string_utils.dart';
import '../../../models/product_data.dart';
import '../../../network_provider/network_provider.dart';
import '../../../utils/theme_utils.dart';
import '../../../utils/utils.dart';
import 'filter_dialog.dart';

class ProductScreen extends ConsumerStatefulWidget {
  final int userId;
  final VoidCallback onBack;

  const ProductScreen({Key? key, required this.onBack, required this.userId}) : super(key: key);

  @override
  ConsumerState<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends ConsumerState<ProductScreen> {

  @override
  void initState() {
    super.initState();
    Utils.getToken();
    _getNetworkData();
  }

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(productProvider);
    var theme = CustomTheme.getTheme(true);
    return WillPopScope(
      onWillPop: () async {
        widget.onBack();
        return false;
      },
      child: Scaffold(
        backgroundColor: theme!.scaffoldBackgroundColor,
        appBar: CustomAppBar(
          title: 'Products',
          action: [
            IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  builder: (_) => const SortFilterDialog(),
                );
              },
              icon: Icon(Icons.filter_list, color: Colors.white),
            ),
          ],
          leading: CustomBackButton(onTap: widget.onBack),
        ).getAppBar(context),
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: productState.productList.isEmpty && !productState.isLoading ?
                        Center(
                          child: Utils.getErrorText('No product details found'),
                        ):
                    ListView.builder(
                      padding: EdgeInsets.only(
                        bottom: Constant.CONTAINER_SIZE_24,
                        top: Constant.SIZE_04,
                      ),
                      itemCount: productState.productList.length,
                      itemBuilder: (context, index) {
                        final item = productState.productList[index];
                        return returnCard(data: item, context: context);
                      },
                    ),
                  ),
                ],
              ),
              if (productState.isLoading)
                Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      ),
    );
  }

  Widget returnCard({required BuildContext context, required Value data}) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Constant.CONTAINER_SIZE_16,
        vertical: Constant.SIZE_08,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Constant.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
          border: Border.all(color: Constant.grey.withOpacity(0.1)),
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
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(Constant.SIZE_08),
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/dip_cup.png',
                    height: Constant.CONTAINER_SIZE_70,
                    width: Constant.CONTAINER_SIZE_70,
                  ),
                ),
              ),

              SizedBox(width: Constant.CONTAINER_SIZE_12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.productName!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Constant.profileText,
                        fontSize: Constant.LABEL_TEXT_SIZE_16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: Constant.SIZE_04),
                    Text(
                      data.productUniqueId!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Constant.subtitleText,
                        fontSize: Constant.LABEL_TEXT_SIZE_14,
                      ),
                    ),
                    Text(
                      "50",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Constant.subtitleText,
                        fontSize: Constant.LABEL_TEXT_SIZE_14,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: Constant.CONTAINER_SIZE_12),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/img.png',
                        height: Constant.CONTAINER_SIZE_15,
                        width: Constant.CONTAINER_SIZE_15,
                      ),
                      SizedBox(width: Constant.SIZE_06),
                      Text(
                        data.quantity.toString(),
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Constant.profileText,
                          fontSize: Constant.LABEL_TEXT_SIZE_16,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Constant.SIZE_08),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: Constant.SIZE_08,
                      vertical: Constant.SIZE_06,
                    ),
                    decoration: BoxDecoration(
                      color: getDaysBadgeColor(data.daysLeft ?? 0),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      ' ${data.daysLeft} Days Left',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.black,
                        fontSize: Constant.CONTAINER_SIZE_12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color getDaysBadgeColor(int daysLeft) {
    if (daysLeft <= 0) {
      return Constant.lightPink;
    } else if (daysLeft == 1) {
      return Constant.lightBlue;
    } else if (daysLeft == 2) {
      return Constant.lightGreen;
    } else {
      return Constant.lightYellow;
    }
  }

  _getNetworkData() async {
    try {
      await ref.read(networkProvider.notifier).isNetworkAvailable().then((
        isNetworkAvailable,
      ) {
        Utils.printLog("isNetworkAvailable::$isNetworkAvailable");
        if (isNetworkAvailable) {
          ref.read(productProvider).clearProductList();
          ref.read(productProvider).setIsLoading(true);

          final url = '${NetworkUrls.PRODUCT_DATA}${widget.userId}';
          Utils.printLog("Fetching URL: $url");
          ref.read(borrowedProvider(url));
        } else {
          Utils.showToast(Strings.NO_INTERNET_CONNECTION);
        }
      });
    } catch (e) {
      ref.read(productProvider).setIsLoading(false);
      Utils.showToast(e.toString());
    }
    FocusScope.of(context).unfocus();
  }
}
