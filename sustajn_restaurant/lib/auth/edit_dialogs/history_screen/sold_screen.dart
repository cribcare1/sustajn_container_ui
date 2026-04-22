import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sustajn_restaurant/auth/edit_dialogs/history_screen/sold_dialogue.dart';
import 'package:sustajn_restaurant/models/sold_container_data.dart';
import 'package:sustajn_restaurant/utils/date_month_utils.dart';

import '../../../common_widgets/filter_Screen.dart';
import '../../../constants/network_urls.dart';
import '../../../constants/number_constants.dart';
import '../../../constants/string_utils.dart';
import '../../../models/login_model.dart';
import '../../../network_provider/network_provider.dart';
import '../../../provider/order_provider.dart';
import '../../../utils/theme_utils.dart';
import '../../../utils/utility.dart';

class SoldScreen extends ConsumerStatefulWidget {
  const SoldScreen({super.key});

  @override
  ConsumerState<SoldScreen> createState() => _SoldScreenState();
}

class _SoldScreenState extends ConsumerState<SoldScreen> {
  final searchController = TextEditingController();

  String? selectedMonthYear;

  LoginData? loginResponse;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
    _getSoldNetworkCall();
  }

  Future<void> _loadProfile() async {
    await Utils.getProfile();
    setState(() {
      loginResponse = Utils.loginData?.data;
      isLoading = false;
    });
  }

  Data? selectedMonthData;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final containerState = ref.watch(orderProvider);

    final List<Data> damagedDataList =
        containerState.soldContainerData?.data ?? [];
    if (damagedDataList.isNotEmpty) {
      selectedMonthData = damagedDataList.firstWhere(
            (e) => e.monthYear == selectedMonthYear,
        orElse: () => damagedDataList.first,
      );
    } else {
      selectedMonthData = null;
    }

    final damageContainers = selectedMonthData?.dateWiseSoldContainers! ?? [];

    return SafeArea(
      bottom: true,
      top: false,
      child: Scaffold(
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
              child: containerState.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : (damageContainers == null || damageContainers.isEmpty)
                  ? const Center(
                child: Text(
                  Strings.NO_CONTAINER_AVAILABLE,
                  style: TextStyle(color: Colors.white),
                ),
              )
                  : ListView.separated(
                padding: EdgeInsets.symmetric(
                  horizontal: Constant.CONTAINER_SIZE_16,
                ),
                itemCount: damageContainers.length,
                separatorBuilder: (_, __) =>
                    SizedBox(height: Constant.SIZE_08),
                itemBuilder: (context, index) {
                  final damageItem = damageContainers[index];
                  final products = damageItem.products![index];

                  return _damageCard(
                    context,
                    theme,
                    products.productName ?? "",
                    products.productDescription ?? "",
                    products.capacity ?? 0,
                    damageItem.localDateTime ?? "",
                    damageItem,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _damageCard(
      BuildContext context,
      ThemeData theme,
      String productName,
      String damageRemark,
      int capacity,
      String date,
      DateWiseSoldContainers soldItem,
      ) {
    return InkWell(
      borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_20),
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (_) =>
              SoldDialog(soldItem: soldItem),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Constant.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
          border: Border.all(color: Constant.grey, width: 0.3),
        ),
        child: Padding(
          padding: EdgeInsets.all(Constant.CONTAINER_SIZE_12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                productName,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: Constant.SIZE_06),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      damageRemark,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: Constant.LABEL_TEXT_SIZE_14,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                  SizedBox(height: Constant.SIZE_08),
                  Text(
                    capacity.toString(),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Constant.gold,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: Constant.SIZE_06),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: Constant.CONTAINER_SIZE_16,
                    color: Colors.white70,
                  ),
                ],
              ),
              SizedBox(height: Constant.SIZE_06),
              Text(
                date,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white70,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSortBottomSheet(BuildContext context) {
    final months = DateMonthUtils.getCurrentYearMonths();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return ReusableFilterBottomSheet(
          title: Strings.FILTER,
          leftTabTitle: Strings.MONTH,
          options: months,
          selectedValue: selectedMonthYear,
          onApply: (value) {
            if (value == null) return;

            setState(() {
              selectedMonthYear = value;
            });
          },
        );
      },
    );
  }

  _getSoldNetworkCall() async {
    try {
      await ref.read(networkProvider.notifier).isNetworkAvailable().then((
          isNetworkAvailable,
          ) {
        Utils.printLog("isNetworkAvailable::$isNetworkAvailable");
        final orderState = ref.read(orderProvider);
        if (isNetworkAvailable) {
          orderState.setIsLoading(true);
          final userId = Utils.userId;
          final url = '${NetworkUrls.GET_SOLD_CONTAINER}$userId';
          ref.read(getSoldContainerProvider(url));
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
