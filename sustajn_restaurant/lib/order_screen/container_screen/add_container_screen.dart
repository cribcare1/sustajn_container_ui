import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sustajn_restaurant/order_screen/container_screen/review_order_screen.dart';

import '../../common_widgets/card_widget.dart';
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
import 'add_container_dialog.dart';

class AddContainerScreen extends ConsumerStatefulWidget {
  const AddContainerScreen({super.key});

  @override
  ConsumerState<AddContainerScreen> createState() => _AddContainerScreenState();
}

class _AddContainerScreenState extends ConsumerState<AddContainerScreen> {
  final searchController = TextEditingController();

  List<GetContainerData> containerData = [];
  LoginData? loginResponse;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      ref.read(orderProvider).setContext(context);
    });
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

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
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
        body: Stack(
          children: [
            orderState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : (orderState.allContainers.isEmpty)
                ? const Center(
                    child: Text(
                      Strings.NO_CONTAINER_AVAILABLE,
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
                    child: Column(
                      children: [
                        CustomTheme.searchField(
                          searchController,
                          Strings.SEARCH_BY_CONTAINER_NAME,
                          onChanged: (value) {
                            orderState.searchContainers(value);
                          },
                        ),
                        SizedBox(height: Constant.CONTAINER_SIZE_10),
                        Expanded(
                          child: (orderState.filteredContainers.isEmpty)
                              ? const Center(
                                  child: Text(
                                    Strings.NO_CONTAINER_AVAILABLE,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              : ListView.separated(
                                  itemCount:
                                      orderState.filteredContainers.length,
                                  separatorBuilder: (_, __) => SizedBox(
                                    height: Constant.CONTAINER_SIZE_12,
                                  ),
                                  itemBuilder: (context, index) {
                                    final item =
                                        orderState.filteredContainers[index];
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
                child: _itemAddedBar(context, orderState),
              ),
          ],
        ),
      ),
    );
  }

  Widget _itemAddedBar(BuildContext context, OrderState orderState) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Constant.CONTAINER_SIZE_16,
        vertical: Constant.CONTAINER_SIZE_14,
      ),
      decoration: BoxDecoration(
        color: Constant.gold,
        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "${orderState.selectedContainers.length} Item added",
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ReviewOrderScreen()),
              );
            },
            child: Row(
              children: [
                Text(
                  "View",
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: Constant.CONTAINER_SIZE_14,
                  color: theme.primaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _containerCard(
    BuildContext context,
    ContainersDetails item,
    ThemeData theme,
  ) {
    return GlassSummaryCard(
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
                "In-Stock",
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
                onTap: () {
                  _openAddDialog(context, item);
                },
                child: Container(
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
                    "Add",
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
    FocusScope.of(context).unfocus();
    await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (_) => AnimatedPadding(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: AddContainerDialog(item: item),
      ),
    );
    FocusScope.of(context).unfocus();
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
