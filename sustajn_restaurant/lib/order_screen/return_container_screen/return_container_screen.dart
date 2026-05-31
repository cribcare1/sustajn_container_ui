import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sustajn_restaurant/order_screen/return_container_screen/return_container_dialog.dart';

import '../../constants/network_urls.dart';
import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../../models/get_container_data.dart';
import '../../models/login_model.dart';
import '../../network_provider/network_provider.dart';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      ref.read(orderProvider).setContext(context);
    });
    _getOrderNetworkCall();
  }



  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final orderState = ref.watch(orderProvider);

    return SafeArea(
      bottom: true,
      top: false,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Padding(
          padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
          child: Column(
            children: [
              CustomTheme.searchField(
                searchController,
                Strings.SEARCH_BY_CONTAINER_NAME,
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
                    : orderState.getContainerData!.containersDetails == null || orderState.getContainerData!.containersDetails!.isEmpty
                    ? Center(
                        child: Text(
                          Strings.NO_CONTAINER_AVAILABLE,
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : ListView.separated(
                        itemCount: orderState
                            .getContainerData!
                            .containersDetails!
                            .length,
                        separatorBuilder: (_, __) =>
                            SizedBox(height: Constant.CONTAINER_SIZE_12),
                        itemBuilder: (context, index) {
                          final item = orderState
                              .getContainerData!
                              .containersDetails![index];
                          return _containerCard(context, item, theme);
                        },
                      ),
              ),
            ],
          ),
        ),
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
          (item.containerImageUrl != "")
              ? Container(
            height: Constant.CONTAINER_SIZE_50,
            width: Constant.CONTAINER_SIZE_50,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(6),
            child: Image.network(
              "${NetworkUrls.CONTAINER_IMAGE_BASE_URL}${item.containerImageUrl}",
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
     await showModalBottomSheet<int>(
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
          final url = '${NetworkUrls.GET_RETURN_CONTAINER}$userId&year=${DateTime.now().year}';
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
