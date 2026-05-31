import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sustajn_restaurant/common_widgets/card_widget.dart';
import 'package:sustajn_restaurant/utils/date_month_utils.dart';

import '../../../common_widgets/filter_Screen.dart';
import '../../../constants/network_urls.dart';
import '../../../constants/number_constants.dart';
import '../../../constants/string_utils.dart';
import '../../../models/damaged_container_data.dart';
import '../../../models/login_model.dart';
import '../../../network_provider/network_provider.dart';
import '../../../provider/order_provider.dart';
import '../../../utils/theme_utils.dart';
import '../../../utils/utility.dart';
import 'damaged_dialogue.dart';

class DamagedScreen extends ConsumerStatefulWidget {
  const DamagedScreen({super.key});

  @override
  ConsumerState<DamagedScreen> createState() => _DamagedScreenState();
}

class _DamagedScreenState extends ConsumerState<DamagedScreen> {
  final searchController = TextEditingController();

  String? selectedMonthYear;

  LoginData? loginResponse;

  @override
  void initState() {
    super.initState();
    _loadProfile();
    _getDamagedNetworkCall();
  }

  Future<void> _loadProfile() async {
    await Utils.getProfile();
    setState(() {
      loginResponse = Utils.loginData?.data;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final containerState = ref.watch(orderProvider);

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
                onChanged: (value){
                  containerState.setDamageContainerFilterData(value);
                }
                //TODO:- required in future
                // onFilterTap: () => _showSortBottomSheet(context),
              ),
            ),
            SizedBox(height: Constant.CONTAINER_SIZE_10),
            Expanded(
              child: containerState.isLoading
                  ? const Center(
                child: CircularProgressIndicator(),
              )
                  : containerState.damageContainerListFiltered.isEmpty
                  ? const Center(
                child: Text(
                  Strings.NO_CONTAINER_AVAILABLE,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              )
                  : ListView.builder(
                itemCount:
                containerState.damageContainerListFiltered.length,
                itemBuilder: (context, index) {

                  final monthData =
                  containerState
                      .damageContainerListFiltered[index];

                  final damageContainers =
                      monthData.damageContainers ?? [];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Container(
                        margin:  EdgeInsets.only(bottom: Constant.CONTAINER_SIZE_14),
                        padding:  EdgeInsets.symmetric(
                          horizontal: Constant.CONTAINER_SIZE_16,
                          vertical: Constant.CONTAINER_SIZE_12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                monthData.monthYear ?? "",
                                style: theme.textTheme.titleMedium
                                    ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Image.asset(
                              Strings.BOWL_IMG,
                              height: Constant.CONTAINER_SIZE_16,
                              width: Constant.CONTAINER_SIZE_16,
                            ),
                            SizedBox(width: Constant.SIZE_06),
                            Text(
                              "${monthData.monthWiseTotalDamageContainers ?? 0}",
                              style: theme.textTheme.titleMedium
                                  ?.copyWith(
                                color: const Color(0xffD4A62A),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),

                      ListView.separated(
                        shrinkWrap: true,
                        physics:
                        const NeverScrollableScrollPhysics(),
                        padding:  EdgeInsets.symmetric(
                          horizontal: Constant.CONTAINER_SIZE_16,
                        ),
                        itemCount: damageContainers.length,
                        separatorBuilder: (_, __) =>
                         SizedBox(height: Constant.CONTAINER_SIZE_12),
                        itemBuilder: (context, damageIndex) {

                          final damageItem =
                          damageContainers[damageIndex];

                          final product =
                          damageItem.products?.isNotEmpty == true
                              ? damageItem.products!.first
                              : null;

                          return _damageCard(
                            context,
                            theme,
                            product?.productName ?? "",
                            product?.damageRemark ?? "",
                            product?.capacity ?? 0,
                            damageItem.localDateTime ?? "",
                            damageItem,
                          );
                        },
                      ),
                       SizedBox(height: Constant.CONTAINER_SIZE_20),
                    ],
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
      DamageContainers damageItem,
      ) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          useSafeArea: true,
          builder: (_) {
            return Align(
              alignment: Alignment.bottomCenter,
              child: DamagedDialog(
                damageItem: damageItem,
              ),
            );
          },
        );
      },
      child: GlassSummaryCard(
        child: Row(
          children: [

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    productName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium
                        ?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 8),
                  Text(
                    date,
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            Row(
              children: [
                Text(
                  "${damageItem.dateWiseTotalDamageContainers ?? 0}",
                  style: theme.textTheme.titleMedium
                      ?.copyWith(
                    color: const Color(0xffD4A62A),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                 SizedBox(width: Constant.CONTAINER_SIZE_12),
                 Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: Constant.CONTAINER_SIZE_18,
                  color: Colors.white70,
                ),
              ],
            ),
          ],
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

  _getDamagedNetworkCall() async {
    try {
      await ref.read(networkProvider.notifier).isNetworkAvailable().then((
        isNetworkAvailable,
      ) {
        Utils.printLog("isNetworkAvailable::$isNetworkAvailable");
        final orderState = ref.read(orderProvider);
        if (isNetworkAvailable) {
          orderState.setIsLoading(true);
          final userId = Utils.userId;
          final url = '${NetworkUrls.GET_DAMAGED_CONTAINER}$userId';
          ref.read(getDamagedContainerProvider(url));
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
