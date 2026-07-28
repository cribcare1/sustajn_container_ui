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
      backgroundColor: Color(0xFF0E3B2E),
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
      padding: const EdgeInsets.all(16),
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
          hintStyle: const TextStyle(color: Colors.white70),
          prefixIcon: const Icon(Icons.search, color: Colors.white70),
          suffixIcon: IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Color(0xFF0E3B2E),
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
          fillColor: const Color(0xFF184D3B),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
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
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
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
                "assets/images/diarhm.png",
                width: 18,
                height: 18,
                color: const Color(0xFFF5EBDF),
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF215842),
            Color(0xFF174836),
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
                  product.productName ?? product.productName ?? "",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  product.productUniqueId ?? "",
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 6),

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
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
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
