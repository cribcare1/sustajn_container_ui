import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common_provider/network_provider.dart';
import '../../common_widgets/damage_filter_bottom_sheet.dart';
import '../../constants/network_urls.dart';
import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../../utils/utility.dart';
import '../models/damage_user_data.dart';
import '../provider_service/damage_provider.dart';
import 'damage_user_screen_popup.dart';

class DamageUserScreen extends ConsumerStatefulWidget {
  final int userId;

  const DamageUserScreen({super.key, required this.userId});

  @override
  ConsumerState<DamageUserScreen> createState() => _DamageUserScreenState();
}

class _DamageUserScreenState extends ConsumerState<DamageUserScreen> {
  final TextEditingController searchController = TextEditingController();

  String searchText = "";
  String? selectedMonth;

  List<DamageUserDataList> filteredList = [];

  @override
  void initState() {
    super.initState();
    _getDamageUserNetworkCall();
  }

  @override
  Widget build(BuildContext context) {
    final damageState = ref.watch(DamageUserProvider);
    print("API List Length = ${damageState.getDamageUserDataList.length}");
    print("Filtered List Length = ${filteredList.length}");

    if (filteredList.isEmpty &&
        damageState.getDamageUserDataList.isNotEmpty) {
      applySearchAndFilter();
    }

    return Scaffold(
      backgroundColor: Constant.PrimaryColor,
      body: Column(
        children: [
          _searchBar(),

          Expanded(
            child: filteredList.isEmpty && !damageState.isLoading
                ? Center(
              child: Utils.getErrorText(Strings.NO_USERDAMAGE),
            )
            :ListView.builder(
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                final month = filteredList[index];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _monthHeader(month),

                    ...(month.damageContainers ?? []).expand((damageContainer) {
                      return (damageContainer.products ?? []).map((product) {
                        return InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (_) => DamageDetailsPopup(
                                damageContainer: damageContainer,
                                product: product,
                              ),
                            );
                          },
                          child: _damageCard(
                            damageContainer,
                            product,
                          ),
                        );
                      });
                    }),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchBar() {
    return Padding(
      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
      child: TextField(
        controller: searchController,
        onChanged: (value) {
          setState(() {
            searchText = value;
            applySearchAndFilter();
          });
        },
        decoration: InputDecoration(
          hintText: Strings.SEARCH_BY_USER_ID,
          hintStyle: TextStyle(color: Constant.BeigeColor),
          prefixIcon: Icon(Icons.search, color: Colors.white70),
          suffixIcon: IconButton(
            icon: Icon(Icons.filter_list, color: Constant.BeigeColor),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Constant.PrimaryColor,
                builder: (_) => DamageFilterBottomSheet(
                  onApply: (result) {
                    setState(() {
                      selectedMonth = result.months.isNotEmpty ? result.months.first : null;
                      applySearchAndFilter();
                    });
                  },
                ),
              );
            },
          ),
          filled: true,
          fillColor: Constant.green9,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  void applySearchAndFilter() {
    final damageState = ref.read(DamageUserProvider);

    filteredList = List.from(damageState.getDamageUserDataList);

    if (searchText.isNotEmpty) {
      filteredList = filteredList.where((month) {
        return month.damageContainers?.any((damage) {
              return damage.products?.any((product) {
                    return (product.productName ?? "").toLowerCase().contains(
                          searchText.toLowerCase(),
                        ) ||
                        (product.productUniqueId ?? "").toLowerCase().contains(
                          searchText.toLowerCase(),
                        );
                  }) ??
                  false;
            }) ??
            false;
      }).toList();
    }

    if (selectedMonth != null) {
      filteredList = filteredList.where((month) {
        return month.monthYear == selectedMonth;
      }).toList();
    }
  }

  Widget _monthHeader(DamageUserDataList month) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: Constant.CONTAINER_SIZE_16,
        vertical: Constant.CONTAINER_SIZE_12,
      ),
      color: Constant.white.withOpacity(0.15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            month.monthYear ?? "",
            style: TextStyle(
              color: Constant.BeigeColor,
              fontSize: Constant.CONTAINER_SIZE_16,
              fontWeight: FontWeight.bold,
            ),
          ),

          Row(
            children: [
              Image.asset(
                Strings.BOWL_IMG,
                width: Constant.CONTAINER_SIZE_18,
                height: Constant.CONTAINER_SIZE_18,
                color: Constant.PrimaryAssentColor,
              ),

              SizedBox(width: Constant.SIZE_06),

              Text(
                "${month.monthWiseTotalDamageContainers ?? 0}",
                style: TextStyle(
                  color: Constant.PrimaryAssentColor,
                  fontSize: Constant.CONTAINER_SIZE_18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _damageCard(DamageContainers damageContainer, Products product) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: Constant.CONTAINER_SIZE_16, vertical: Constant.SIZE_08),
      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF215842),
            Constant.PrimaryColor,
          ],
        ),
        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
        border: Border.all(
          color: Constant.white.withOpacity(.15),
        ),
      ),
      child: Row(
        children: [

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  "${damageContainer.productIds ?? 0 }",
                  style: TextStyle(
                    color: Constant.BeigeColor,
                    fontWeight: FontWeight.w600,
                    fontSize: Constant.CONTAINER_SIZE_16,
                  ),
                ),

                SizedBox(height: Constant.SIZE_06),

                Text(
                  product.customerId ?? "",
                  style:  TextStyle(
                    color: Constant.BeigeColor,
                    fontSize: Constant.CONTAINER_SIZE_13,
                  ),
                ),

                SizedBox(height: Constant.SIZE_06),

                Text(
                  damageContainer.localDateTime ?? "",
                  style: TextStyle(
                    color: Constant.BeigeColor,
                    fontSize: Constant.CONTAINER_SIZE_12,
                  ),
                ),
              ],
            ),
          ),

          Row(
            children: [

              Text(
                "${damageContainer.dateWiseTotalDamageContainers ?? 0}",
                style: TextStyle(
                  color: Constant.PrimaryAssentColor,
                  fontSize: Constant.CONTAINER_SIZE_22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(width: Constant.CONTAINER_SIZE_12),

              Icon(
                Icons.arrow_forward_ios,
                color: Constant.BeigeColor,
                size: Constant.SIZE_15,
              ),
            ],
          ),
        ],
      ),
    );
  }

  _getDamageUserNetworkCall() async {
    try {
      await ref.read(networkProvider.notifier).isNetworkAvailable().then((
          isNetworkAvailable,
          ) {
        Utils.printLog("isNetworkAvailable::$isNetworkAvailable");
        final damageState = ref.read(DamageUserProvider);
        if (isNetworkAvailable) {
          damageState.setIsLoading(true);

          final url = '${NetworkUrls.DAMAGE_USER}';
          ref.read(getDamageUserDataProvider(url));
        } else {
          damageState.setIsLoading(false);
          Utils.showToast(Strings.NO_INTERNET_CONNECTION);
        }
      });
    } catch (e) {
      Utils.printLog('Error in visitor button onPressed: $e');
    }
  }
}
