import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common_provider/network_provider.dart';
import '../../common_widgets/damage_filter_bottom_sheet.dart';
import '../../common_widgets/damage_filter_bottom_sheet_2.dart';
import '../../constants/network_urls.dart';
import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../../utils/utility.dart';
import '../models/damage_partner_data.dart';
import '../provider_service/damage_provider.dart';
import 'damage_partner_popup.dart';


class DamagePartnerScreen extends ConsumerStatefulWidget {
  final int userId;

  const DamagePartnerScreen({super.key, required this.userId});

  @override
  ConsumerState<DamagePartnerScreen> createState() => _DamagePartnerScreenState();
}

class _DamagePartnerScreenState extends ConsumerState<DamagePartnerScreen> {
  final TextEditingController searchController = TextEditingController();

  String searchText = "";
  String? selectedMonth;

  List<DamagePartnerDataList> filteredList = [];

  @override
  void initState() {
    super.initState();
    _getDamagePartnerNetworkCall();
  }

  @override
  Widget build(BuildContext context) {
    final damageState = ref.watch(DamageUserProvider);
    if (filteredList.isEmpty &&
        damageState.getDamagePartnerDataList.isNotEmpty) {
      applySearchAndFilter();
    }

    return Scaffold(
      backgroundColor: Color(0xFF0E3B2E),
      body: Column(
        children: [
          _searchBar(),

          Expanded(child: filteredList.isEmpty && !damageState.isLoading
              ? Center(
            child: Utils.getErrorText(Strings.NO_PARTNERDAMAGE),
          )
              :
            ListView.builder(
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                final month = filteredList[index];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _monthHeader(month),

                    ...(month.damageContainers ?? []).expand((damageContainer) {
                      return (damageContainer.products ?? []).map((product) {
                        return _damageCard(damageContainer, product);
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
          hintText: Strings.SEARCH_BY_PARTNER_NAME,
          hintStyle: const TextStyle(color: Colors.white70),
          prefixIcon: const Icon(Icons.search, color: Colors.white70),
          suffixIcon: IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => DamagePartnerFilterBottomSheet(
                  onApply: (result) {
                    setState(() {
                      selectedMonth =
                      result.months.isNotEmpty ? result.months.first : null;
                      applySearchAndFilter();
                    });
                  },
                ),
              );
            },
          ),
          filled: true,
          fillColor: Constant.PrimaryColor,
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

    filteredList = List.from(damageState.getDamagePartnerDataList);

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

  Widget _monthHeader(DamagePartnerDataList month) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: Constant.CONTAINER_SIZE_16, vertical: Constant.CONTAINER_SIZE_10),
      color: Colors.white.withOpacity(0.15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            month.monthYear ?? "",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          Row(
            children: [
              Image.asset(
                Strings.DIRHAM_IMG,
                width: 18,
                height: 18,
                color: Constant.white,
              ),

              const SizedBox(width: 6),

              Text(
                "${month.monthWiseTotalDamageContainers ?? 0}",
                style: const TextStyle(
                  color: Color(0xFFFFC107),
                  fontSize: 18,
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
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Constant.PrimaryColor,
          builder: (_) => DamagePartnerPopup(
            damageContainer: damageContainer,
            product: product,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFF1D5A45),
              Color(0xFF164434),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(.15),
          ),
        ),
        child: Row(
          children: [

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    product.productName ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 5),


                  Text(
                    product.restaurantName ?? "-",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 5),


                  Text(
                    damageContainer.localDateTime ?? "",
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),


            Row(
              children: [
                Text(
                  "${damageContainer.dateWiseTotalDamageContainers ?? 0}",
                  style: const TextStyle(
                    color: Color(0xFFFFC107),
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),

                const SizedBox(width: 12),

                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white70,
                  size: 16,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _getDamagePartnerNetworkCall() async {
    try {
      await ref.read(networkProvider.notifier).isNetworkAvailable().then((
          isNetworkAvailable,
          ) {
        Utils.printLog("isNetworkAvailable::$isNetworkAvailable");
        final damageState = ref.read(DamageUserProvider);
        if (isNetworkAvailable) {
          damageState.setIsLoading(true);

          final url = '${NetworkUrls.DAMAGE_RESTAURANT}';
          ref.read(getDamagePartnerDataProvider(url));
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
