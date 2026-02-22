import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sustajn_restaurant/common_widgets/submit_clear_button.dart';

import '../../constants/network_urls.dart';
import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../../models/container_history_data.dart';
import '../../network_provider/network_provider.dart';
import '../../notifier/order_notifier.dart';
import '../../provider/order_provider.dart';
import '../../utils/theme_utils.dart';
import '../../utils/utility.dart';
import 'detail_dialo.dart';

class LeaseScreen extends ConsumerStatefulWidget {
  const LeaseScreen({super.key});

  @override
  ConsumerState<LeaseScreen> createState() => _LeaseScreenState();
}

class _LeaseScreenState extends ConsumerState<LeaseScreen> {
  final searchController = TextEditingController();

  bool _isQtyAscending = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final containerState = ref.read(orderProvider);
      searchController.text = containerState.searchQuery;
    });
    _getLeaseNetworkCall();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final containerState = ref.watch(orderProvider);
    final container =
        containerState.containerHistorydata?.data?.leasedResponses;

    return SafeArea(
      bottom: true,
      top: false,
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
              child: CustomTheme.searchField(
                onChanged: (value) {
                  containerState.setSearchQuery(value);
                },
                searchController,
                Strings.SEARCH_BY_CONTAINER_NAME,
                onFilterTap: () => _showFilterBottomSheet(context),
              ),
            ),
            SizedBox(height: Constant.CONTAINER_SIZE_10),
            Expanded(
              child: containerState.isLoading
                  ? Center(child: CircularProgressIndicator())
                  : container == null
                  ? const Center(
                child: Text(
                  Strings.NO_CONTAINER_AVAILABLE,
                  style: TextStyle(color: Colors.white),
                ),
              )
                  : (containerState.groupedOrders.isEmpty)
                  ? _buildEmptyState(containerState)
                  : ListView.builder(
                padding: EdgeInsets.symmetric(
                  horizontal: Constant.CONTAINER_SIZE_16,
                ),
                itemCount: containerState.groupedOrders.length,
                itemBuilder: (context, index) {
                  String monthYear = containerState.groupedOrders.keys
                      .elementAt(index);
                  List<LeasedResponses> orders =
                  containerState.groupedOrders[monthYear]!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(6)
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: Constant.CONTAINER_SIZE_10,
                            horizontal: Constant.CONTAINER_SIZE_10
                        ),
                        margin:EdgeInsets.only(bottom:Constant.SIZE_08),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              monthYear,
                              style: theme.textTheme.titleMedium
                                  ?.copyWith(
                                fontSize: Constant.LABEL_TEXT_SIZE_16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white70,
                              ),
                            ),
                            Row(
                              children: [
                                Image.asset(
                                  "assets/images/img.png",
                                  height: Constant.CONTAINER_SIZE_16,
                                  width: Constant.CONTAINER_SIZE_16,
                                ),

                                SizedBox(width: Constant.SIZE_06),
                                Text(
                                  '${containerState.getMonthTotal(orders)}',
                                  style: theme.textTheme.titleMedium
                                      ?.copyWith(
                                    color: Constant.gold,
                                    fontSize:
                                    Constant.LABEL_TEXT_SIZE_18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Order Cards for this month
                      ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: orders.length,
                        separatorBuilder: (_, __) =>
                            SizedBox(height: Constant.SIZE_08),
                        itemBuilder: (context, orderIndex) {
                          return _leaseCard(
                            context,
                            theme,
                            orders[orderIndex],
                            containerState,
                          );
                        },
                      ),
                      SizedBox(height: Constant.CONTAINER_SIZE_24),
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

  Widget _buildEmptyState(OrderState notifier) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 64,
            color: Color(0xFF047857).withOpacity(0.3),
          ),
          SizedBox(height: 16),
          Text(
            'No orders found',
            style: Theme.of(
              context,
            ).textTheme.titleMedium!.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _leaseCard(
      BuildContext context,
      ThemeData theme,
      LeasedResponses data,
      OrderState containerState,
      ) {
    return InkWell(
      borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_20),
      onTap: () => _openLeaseDialog(context, data),
      child: Container(
        margin: EdgeInsets.only(bottom: Constant.SIZE_08),
        decoration: BoxDecoration(
          color: Constant.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
          border: Border.all(color: Constant.grey, width: 0.3),
        ),
        child: Padding(
          padding: EdgeInsets.all(Constant.CONTAINER_SIZE_12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                containerState.formatProductIds(data.productOrderListResponses),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontSize: Constant.LABEL_TEXT_SIZE_16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white70,
                ),
              ),
              SizedBox(height: Constant.SIZE_06),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Order ID: #${data.orderId.toString().padLeft(8, '0')}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: Constant.LABEL_TEXT_SIZE_14,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                  SizedBox(width: Constant.SIZE_08),
                  Text(
                    data.leasedQuantity.toString(),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Constant.gold,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: Constant.SIZE_06),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: Constant.CONTAINER_SIZE_14,
                    color: Colors.white70,
                  ),
                ],
              ),
              SizedBox(height: Constant.SIZE_06),
              Text(
                containerState.formatDateTime(data.leasedStartDateTime ?? ""),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: Constant.LABEL_TEXT_SIZE_14,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openLeaseDialog(BuildContext context, LeasedResponses data) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return SafeArea(
            top: false,
            bottom: true,
            child: LeaseDetailsDialog(data: data),
          );
        },
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    final containerState = ref.read(orderProvider);
    final leasedResponses =
        containerState.containerHistorydata?.data?.leasedResponses;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return FilterBottomSheet1(
          leasedResponses: leasedResponses,
          onApply: (selectedMonths, selectedContainers) {
            _applyFilters(selectedMonths, selectedContainers);
          },
        );
      },
    );
  }

  void _applyFilters(
      List<String> selectedMonths,
      List<String> selectedContainers,
      ) {
    final containerState = ref.read(orderProvider);

    // Get all leased responses
    List<LeasedResponses>? allResponses =
        containerState.containerHistorydata?.data?.leasedResponses;

    if (allResponses == null) return;

    // If no filters selected, show all data
    if (selectedMonths.isEmpty && selectedContainers.isEmpty) {
      setState(() {
        containerState.clearFilters();
      });
      return;
    }

    // Filter by selected months and containers
    List<LeasedResponses> filteredResponses = allResponses.where((response) {
      bool matchesMonth = true;
      bool matchesContainer = true;

      // Filter by month if any month is selected
      if (selectedMonths.isNotEmpty) {
        String responseMonth = containerState.getMonthYear(
          response.leasedStartDateTime ?? '',
        );
        matchesMonth = selectedMonths.contains(responseMonth);
      }

      // Filter by container if any container is selected
      if (selectedContainers.isNotEmpty) {
        matchesContainer = false;
        if (response.productOrderListResponses != null) {
          for (var product in response.productOrderListResponses!) {
            if (selectedContainers.contains(product.productUniqueId)) {
              matchesContainer = true;
              break;
            }
          }
        }
      }

      return matchesMonth && matchesContainer;
    }).toList();

    // Update the grouped orders with filtered data
    setState(() {
      containerState.applyFilters(filteredResponses);
    });
  }

  _getLeaseNetworkCall() async {
    try {
      await ref.read(networkProvider.notifier).isNetworkAvailable().then((
          isNetworkAvailable,
          ) {
        Utils.printLog("isNetworkAvailable::$isNetworkAvailable");
        final orderState = ref.read(orderProvider);
        if (isNetworkAvailable) {
          orderState.setIsLoading(true);
          final userId = Utils.userId;
          final url = '${NetworkUrls.CONTAINER_HISTORY}$userId';
          ref.read(getContainerHistoryProvider(url));
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

class FilterBottomSheet1 extends ConsumerStatefulWidget {
  final List<LeasedResponses>? leasedResponses;
  final Function(List<String> selectedMonths, List<String> selectedContainers)
  onApply;

  const FilterBottomSheet1({
    super.key,
    required this.leasedResponses,
    required this.onApply,
  });

  @override
  ConsumerState<FilterBottomSheet1> createState() =>
      _FilterBottomSheetState();
}

class _FilterBottomSheetState extends ConsumerState<FilterBottomSheet1> {
  String _selectedTab = 'Month';
  final Set<String> _selectedMonths = {};
  final Set<String> _selectedContainers = {};
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<String> _getUniqueMonths() {
    if (widget.leasedResponses == null) return [];

    Set<String> months = {};
    for (var response in widget.leasedResponses!) {
      String monthYear =
      _getMonthYear(response.leasedStartDateTime ?? '');
      if (monthYear != 'Unknown') {
        months.add(monthYear);
      }
    }

    List<String> sortedMonths = months.toList();
    sortedMonths.sort((a, b) {
      DateTime dateA = _parseMonthYear(a);
      DateTime dateB = _parseMonthYear(b);
      return dateB.compareTo(dateA);
    });

    return sortedMonths;
  }

  List<Map<String, String>> _getUniqueContainers() {
    if (widget.leasedResponses == null) return [];

    Map<String, String> containersMap = {};
    for (var response in widget.leasedResponses!) {
      if (response.productOrderListResponses != null) {
        for (var product in response.productOrderListResponses!) {
          String name = product.productName ?? '';
          String uniqueId = product.productUniqueId ?? '';
          if (name.isNotEmpty && uniqueId.isNotEmpty) {
            containersMap[uniqueId] = name;
          }
        }
      }
    }

    List<Map<String, String>> containers = containersMap.entries
        .map((e) => {'name': e.value, 'uniqueId': e.key})
        .toList();

    containers.sort((a, b) => a['name']!.compareTo(b['name']!));
    return containers;
  }

  String _getMonthYear(String dateTimeStr) {
    try {
      List<String> parts = dateTimeStr.split('|');
      if (parts.isEmpty) return 'Unknown';

      List<String> dateParts = parts[0].split('/');
      if (dateParts.length < 3) return 'Unknown';

      int month = int.parse(dateParts[1]);
      String year = dateParts[2];

      const monthNames = [
        'January','February','March','April','May','June',
        'July','August','September','October','November','December'
      ];

      return '${monthNames[month - 1]}-$year';
    } catch (e) {
      return 'Unknown';
    }
  }

  DateTime _parseMonthYear(String monthYear) {
    try {
      List<String> parts = monthYear.split('-');
      const monthNames = [
        'January','February','March','April','May','June',
        'July','August','September','October','November','December'
      ];
      int month = monthNames.indexOf(parts[0]) + 1;
      int year = int.parse(parts[1]);
      return DateTime(year, month);
    } catch (e) {
      return DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;

    final bottomSheetHeight =
    _selectedTab == 'Containers'
        ? screenHeight * 0.7
        : screenHeight * 0.7;

    return SafeArea(
      top: true,
      bottom: true,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.all(Constant.CONTAINER_SIZE_12),
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: EdgeInsets.all(Constant.SIZE_08),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      color: Colors.black,
                      size: Constant.CONTAINER_SIZE_20,
                    ),
                  ),
                ),
              ),
            ),

            /// MAIN CONTAINER
            Container(
              constraints: BoxConstraints(
                maxHeight: bottomSheetHeight,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(Constant.CONTAINER_SIZE_30),
                ),
              ),
              child: Column(
                children: [
                  _buildHeader(theme),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLeftSideTabs(theme),
                        Container(
                          width: 1,
                          color: Colors.white.withOpacity(0.2),
                        ),
                        Expanded(
                          child: _buildRightSideContent(theme),
                        ),
                      ],
                    ),
                  ),
                  _buildButtons(theme, context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Padding(
      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_20),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "Filters",
          style: theme.textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildLeftSideTabs(ThemeData theme) {
    return SizedBox(
      width: 120,
      child: Column(
        children: [
          _buildTabItem('Month', theme),
          _buildTabItem('Containers', theme),
        ],
      ),
    );
  }

  Widget _buildTabItem(String label, ThemeData theme) {
    bool isSelected = _selectedTab == label;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedTab = label;
          _searchQuery = '';
          _searchController.clear();
        });
      },
      child: Container(
        padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white.withOpacity(0.1)
              : Colors.transparent,
          border: Border(
            left: BorderSide(
              color: isSelected
                  ? const Color(0xFFFBBF24)
                  : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white,
              fontWeight:
              isSelected ? FontWeight.w500 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRightSideContent(ThemeData theme) {
    return Column(
      children: [
        if (_selectedTab == 'Containers')
          Padding(
            padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
              style: const TextStyle(color: Colors.white),
              decoration:  InputDecoration(
                hintText: 'Container name or ID',
                hintStyle: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white),
                border: InputBorder.none,
                prefixIcon:
                Icon(Icons.search, color: Colors.white),
              ),
            ),
          ),
        Expanded(
          child: _selectedTab == 'Month'
              ? _buildMonthList(theme)
              : _buildContainersList(theme),
        ),
      ],
    );
  }

  Widget _buildMonthList(ThemeData theme) {
    List<String> months = _getUniqueMonths();

    return ListView.builder(
      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
      itemCount: months.length,
      itemBuilder: (context, index) {
        String month = months[index];
        bool isSelected = _selectedMonths.contains(month);

        return ListTile(
          title: Text(
            month,
            style: const TextStyle(color: Colors.white),
          ),
          trailing: Checkbox(
            value: isSelected,
            activeColor: const Color(0xFFFBBF24),
            onChanged: (_) {
              setState(() {
                isSelected
                    ? _selectedMonths.remove(month)
                    : _selectedMonths.add(month);
              });
            },
          ),
        );
      },
    );
  }

  Widget _buildContainersList(ThemeData theme) {
    List<Map<String, String>> containers =
    _getUniqueContainers();

    if (_searchQuery.isNotEmpty) {
      containers = containers.where((c) {
        return c['name']!
            .toLowerCase()
            .contains(_searchQuery) ||
            c['uniqueId']!
                .toLowerCase()
                .contains(_searchQuery);
      }).toList();
    }

    return ListView.builder(
      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
      itemCount: containers.length,
      itemBuilder: (context, index) {
        final container = containers[index];
        final uniqueId = container['uniqueId']!;
        final isSelected =
        _selectedContainers.contains(uniqueId);

        return ListTile(
          title: Text(
            container['name']!,
            style: const TextStyle(color: Colors.white),
          ),
          subtitle: Text(
            uniqueId,
            style:
            const TextStyle(color: Colors.white70),
          ),
          trailing: Checkbox(
            value: isSelected,
            activeColor: const Color(0xFFFBBF24),
            onChanged: (_) {
              setState(() {
                isSelected
                    ? _selectedContainers.remove(uniqueId)
                    : _selectedContainers.add(uniqueId);
              });
            },
          ),
        );
      },
    );
  }

  Widget _buildButtons(
      ThemeData theme, BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(Constant.CONTAINER_SIZE_20),
        child:SubmitClearButton(onLeftTap: (){setState(() {
          _selectedMonths.clear();
          _selectedContainers.clear();
          _searchController.clear();
          _searchQuery = '';
        });},
            leftText: "Clear",rightText: "Apply",
            onRightTap: (){ widget.onApply(
              _selectedMonths.toList(),
              _selectedContainers.toList(),
            );
            Navigator.pop(context);})
    );
  }
}
