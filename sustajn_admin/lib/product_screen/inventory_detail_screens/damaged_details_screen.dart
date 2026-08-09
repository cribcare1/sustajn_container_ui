import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common_provider/network_provider.dart';
import '../../../constants/network_urls.dart';
import '../../../constants/number_constants.dart';
import '../../../constants/string_utils.dart';
import '../../../utils/utility.dart';
import '../../common_widgets/custom_app_bar.dart';
import '../../common_widgets/custom_back_button.dart';
import '../../provider/order_provider.dart';
import '../models/damage_data.dart';

class InventoryDamageDetailsScreen extends ConsumerStatefulWidget {
  const InventoryDamageDetailsScreen({super.key});

  @override
  ConsumerState<InventoryDamageDetailsScreen> createState() =>
      _InventoryDamageDetailsScreenState();
}

class _InventoryDamageDetailsScreenState
    extends ConsumerState<InventoryDamageDetailsScreen> {
  bool isUserSelected = true;
  String? selectedMonthYear;

  @override
  void initState() {
    super.initState();
    _getDamageDetailNetworkCall();
  }

  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(orderProvider);
    final damageList = orderState.getDamagedList;

    return Scaffold(
      backgroundColor: Constant.PrimaryColor,
      appBar: CustomAppBar(
        title: Strings.DAMAGED,
        leading: const CustomBackButton(),
      ).getAppBar(context),
      body: Column(
        children: [
          SizedBox(height: Constant.CONTAINER_SIZE_12),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Constant.CONTAINER_SIZE_12,
            ),
            child: Container(
              height: Constant.CONTAINER_SIZE_42,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_30),
                border: Border.all(color: Colors.white38),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isUserSelected = true;
                        });

                        _getDamageDetailNetworkCall();
                      },
                      child: Container(
                        margin: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: isUserSelected
                              ? Colors.white30
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(
                            Constant.CONTAINER_SIZE_30,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          Strings.USER,
                          style: TextStyle(
                            color: isUserSelected
                                ? Constant.gold
                                : Colors.white70,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isUserSelected = false;
                        });

                        _getPartnerDamageDetailNetworkCall();
                      },
                      child: Container(
                        margin: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: !isUserSelected
                              ? Colors.white30
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(
                            Constant.CONTAINER_SIZE_30,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          Strings.PARTNER,
                          style: TextStyle(
                            color: !isUserSelected
                                ? Constant.gold
                                : Colors.white70,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Constant.CONTAINER_SIZE_12,
            ),
            child: Container(
              height: Constant.CONTAINER_SIZE_45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_15),
                border: Border.all(color: Colors.white38),
              ),
              child: Row(
                children: [
                  SizedBox(width: Constant.CONTAINER_SIZE_10),
                  const Icon(Icons.search, color: Colors.white70),
                  SizedBox(width: Constant.SIZE_08),
                  Expanded(
                    child: TextField(
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        hintText: isUserSelected
                            ? Strings.SEARCH_BY_USER_ID
                            : Strings.SEARCH_BY_PARTNER_NAME,
                        hintStyle: TextStyle(color: Colors.white54),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  Container(
                    width: Constant.SIZE_01,
                    height: Constant.CONTAINER_SIZE_20,
                    color: Colors.white30,
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.tune, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: Constant.CONTAINER_SIZE_10),

          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: damageList.length,
              itemBuilder: (context, index) {
                final month = damageList[index];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _monthHeader(
                      month.monthYear ?? "",
                      (month.monthWiseTotalDamageContainers ?? 0).toDouble(),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: month.damageContainers?.length ?? 0,
                      itemBuilder: (context, i) {
                        return isUserSelected
                            ? _damageCard(month.damageContainers![i])
                            : _partnerDamageCard(month.damageContainers![i]);
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

//user damaged card
  Widget _damageCard(DamagedContainers item) {
    final customerId = item.products?.isNotEmpty == true
        ? item.products!.first.customerId ?? ""
        : "";

    return InkWell(
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: Constant.CONTAINER_SIZE_12,
          vertical: Constant.SIZE_06,
        ),
        padding: EdgeInsets.all(Constant.CONTAINER_SIZE_14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
          border: Border.all(color: Colors.white38),
          color: Constant.Green4,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    customerId,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: Constant.CONTAINER_SIZE_16,
                    ),
                  ),
                  SizedBox(height: Constant.SIZE_04),
                  Text(
                    item.localDateTime ?? "",
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: Constant.CONTAINER_SIZE_12,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              "${item.dateWiseTotalDamageContainers ?? 0}",
              style: TextStyle(
                color: Constant.gold,
                fontSize: Constant.CONTAINER_SIZE_18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: Constant.CONTAINER_SIZE_10),
            const Icon(Icons.chevron_right, color: Colors.white70),
          ],
        ),
      ),
    );
  }

  //partner damagecard
  Widget _partnerDamageCard(DamagedContainers item) {
    final partnerName = item.products?.isNotEmpty == true
        ? item.products!.first.restaurantName ?? ""
        : "";

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: Constant.CONTAINER_SIZE_12,
        vertical: Constant.SIZE_06,
      ),
      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
        border: Border.all(color: Colors.white38),
        color: Constant.Green4,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  partnerName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Constant.CONTAINER_SIZE_16,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                SizedBox(height: Constant.SIZE_04),

                Text(
                  item.localDateTime ?? "",
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: Constant.CONTAINER_SIZE_12,
                  ),
                ),
              ],
            ),
          ),

          Text(
            "${item.dateWiseTotalDamageContainers ?? 0}",
            style: TextStyle(
              color: Constant.gold,
              fontSize: Constant.CONTAINER_SIZE_18,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(width: Constant.CONTAINER_SIZE_10),

          Icon(Icons.chevron_right, color: Colors.white70),
        ],
      ),
    );
  }

  Widget _monthHeader(String title, double amount) {
    return Container(
      color: Constant.green4,
      padding: EdgeInsets.symmetric(
        horizontal: Constant.CONTAINER_SIZE_12,
        vertical: Constant.CONTAINER_SIZE_10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white70,
              fontSize: Constant.CONTAINER_SIZE_16,
            ),
          ),
          Row(
            children: [
              Image.asset(Strings.BOWL_IMG, height: Constant.CONTAINER_SIZE_16),
              SizedBox(width: Constant.SIZE_04),
              Text(
                amount.toStringAsFixed(0),
                style: const TextStyle(
                  color: Constant.gold,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _getDamageDetailNetworkCall() async {
    try {
      await ref.read(networkProvider.notifier).isNetworkAvailable().then((
        isNetworkAvailable,
      ) {
        Utils.printLog("isNetworkAvailable::$isNetworkAvailable");
        final orderState = ref.read(orderProvider);
        if (isNetworkAvailable) {
          orderState.setIsLoading(true);

          final url = '${NetworkUrls.DAMAGE_USER}';
          ref.read(getDamagedOrderProvider(url));
        } else {
          orderState.setIsLoading(false);
          Utils.showToast(Strings.NO_INTERNET_CONNECTION);
        }
      });
    } catch (e) {
      Utils.printLog('Error in visitor button onPressed: $e');
    }
  }

  _getPartnerDamageDetailNetworkCall() async {
    try {
      await ref.read(networkProvider.notifier).isNetworkAvailable().then((
        isNetworkAvailable,
      ) {
        Utils.printLog("isNetworkAvailable::$isNetworkAvailable");
        final orderState = ref.read(orderProvider);
        if (isNetworkAvailable) {
          orderState.setIsLoading(true);

          final url = '${NetworkUrls.DAMAGE_RESTAURANT}';
          ref.read(getDamagedOrderProvider(url));
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
