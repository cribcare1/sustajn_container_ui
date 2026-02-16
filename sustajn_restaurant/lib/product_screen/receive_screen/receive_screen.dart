import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sustajn_restaurant/common_widgets/submit_clear_button.dart';
import 'package:sustajn_restaurant/product_screen/receive_screen/receive_details.dart';

import '../../constants/network_urls.dart';
import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../../models/container_history_data.dart';
import '../../models/login_model.dart';
import '../../network_provider/network_provider.dart';
import '../../notifier/order_notifier.dart';
import '../../provider/order_provider.dart';
import '../../utils/theme_utils.dart';
import '../../utils/utility.dart';

class ReceiveScreen extends ConsumerStatefulWidget {
  const ReceiveScreen({super.key});

  @override
  ConsumerState<ReceiveScreen> createState() => _ReceiveScreenState();
}

class _ReceiveScreenState extends ConsumerState<ReceiveScreen> {
  final searchController = TextEditingController();

  LoginData? loginResponse;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final containerState = ref.read(orderProvider);
      searchController.text = containerState.searchQueryReceive;
    });
    _loadProfile();
    _getReceiveNetworkCall();
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
    final containerState = ref.watch(orderProvider);
    final container =
        containerState.containerHistorydata?.data?.receivedResponses;

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
                  containerState.setSearchQueryReceive(value);
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
                  : (containerState.groupedReceiveOrders.isEmpty)
                  ? _buildEmptyState(containerState)
                  : ListView.builder(
                padding: EdgeInsets.symmetric(
                  horizontal: Constant.CONTAINER_SIZE_16,
                ),
                itemCount:
                containerState.groupedReceiveOrders.length,
                itemBuilder: (context, index) {
                  String monthYear = containerState
                      .groupedReceiveOrders.keys
                      .elementAt(index);
                  List<ReceivedResponses> orders =
                  containerState
                      .groupedReceiveOrders[monthYear]!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: Constant.CONTAINER_SIZE_10,
                          horizontal: Constant.CONTAINER_SIZE_10,
                        ),
                        margin: EdgeInsets.only(
                            bottom: Constant.SIZE_08),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              monthYear,
                              style: theme.textTheme.titleMedium
                                  ?.copyWith(
                                fontSize:
                                Constant.LABEL_TEXT_SIZE_16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white70,
                              ),
                            ),
                            Row(
                              children: [
                                Image.asset(
                                  "assets/images/img.png",
                                  height:
                                  Constant.CONTAINER_SIZE_16,
                                  width:
                                  Constant.CONTAINER_SIZE_16,
                                ),
                                SizedBox(width: Constant.SIZE_06),
                                Text(
                                  '${containerState.getMonthTotalReceive(orders)}',
                                  style: theme
                                      .textTheme.titleMedium
                                      ?.copyWith(
                                    color: Constant.gold,
                                    fontSize: Constant
                                        .LABEL_TEXT_SIZE_18,
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
                          return _receiveCard(
                            context,
                            theme,
                            orders[orderIndex],
                            containerState,
                          );
                        },
                      ),
                      SizedBox(
                          height: Constant.CONTAINER_SIZE_24),
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
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _receiveCard(
      BuildContext context,
      ThemeData theme,
      ReceivedResponses data,
      OrderState containerState,
      ) {
    return InkWell(
      borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_20),
      onTap: () => _openReceiveDialog(context, data),
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
                containerState
                    .formatProductIds(data.productOrderListResponses),
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
                    data.returnedQuantity.toString(),
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
                containerState.formatDateTime(data.returnDateTime ?? ""),
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

  void _openReceiveDialog(BuildContext context, ReceivedResponses data) {
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
            child: ReceiveDetailsDialog(data: data),
          );
        },
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    final containerState = ref.read(orderProvider);
    final receivedResponses =
        containerState.containerHistorydata?.data?.receivedResponses;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return ReceiveFilterBottomSheet(
          receivedResponses: receivedResponses,
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

    List<ReceivedResponses>? allResponses =
        containerState.containerHistorydata?.data?.receivedResponses;

    if (allResponses == null) return;

    if (selectedMonths.isEmpty && selectedContainers.isEmpty) {
      containerState.clearFiltersReceive();
      return;
    }

    List<ReceivedResponses> filteredResponses =
    allResponses.where((response) {
      bool matchesMonth = true;
      bool matchesContainer = true;

      if (selectedMonths.isNotEmpty) {
        String responseMonth =
        containerState.getMonthYearReceive(response.returnDateTime ?? '');
        matchesMonth = selectedMonths.contains(responseMonth);
      }

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

    containerState.applyFiltersReceive(filteredResponses);
  }

  _getReceiveNetworkCall() async {
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

// Receive Filter Bottom Sheet
class ReceiveFilterBottomSheet extends ConsumerStatefulWidget {
  final List<ReceivedResponses>? receivedResponses;
  final Function(List<String> selectedMonths, List<String> selectedContainers)
  onApply;

  const ReceiveFilterBottomSheet({
    super.key,
    required this.receivedResponses,
    required this.onApply,
  });

  @override
  ConsumerState<ReceiveFilterBottomSheet> createState() =>
      _ReceiveFilterBottomSheetState();
}

class _ReceiveFilterBottomSheetState
    extends ConsumerState<ReceiveFilterBottomSheet> {
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
    if (widget.receivedResponses == null) return [];

    Set<String> months = {};
    for (var response in widget.receivedResponses!) {
      String monthYear = _getMonthYear(response.returnDateTime ?? '');
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
    if (widget.receivedResponses == null) return [];

    Map<String, String> containersMap = {};
    for (var response in widget.receivedResponses!) {
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

      List<String> monthNames = [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December',
      ];

      return '${monthNames[month - 1]}-$year';
    } catch (e) {
      return 'Unknown';
    }
  }

  DateTime _parseMonthYear(String monthYear) {
    try {
      List<String> parts = monthYear.split('-');
      List<String> monthNames = [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December',
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

    return SafeArea(
      top: false,
      bottom: true,
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
                  decoration: BoxDecoration(
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
          Flexible(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(Constant.CONTAINER_SIZE_30),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildHeader(theme),
                  _buildTabs(theme),
                  Divider(
                    color: Colors.white.withOpacity(0.2),
                    thickness: 1,
                    height: 1,
                  ),
                  if (_selectedTab == 'Containers') _buildSearchBar(theme),
                  Flexible(child: _buildContent(theme)),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      Constant.CONTAINER_SIZE_16,
                      0,
                      Constant.CONTAINER_SIZE_16,
                      Constant.CONTAINER_SIZE_16,
                    ),
                    child: _buildButtons(theme, context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        Constant.CONTAINER_SIZE_24,
        Constant.CONTAINER_SIZE_20,
        Constant.CONTAINER_SIZE_24,
        Constant.CONTAINER_SIZE_16,
      ),
      child: Column(
        children: [
          Container(
            width: Constant.CONTAINER_SIZE_60,
            height: Constant.SIZE_05,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Constant.SIZE_05),
              color: Colors.white30,
            ),
          ),
          SizedBox(height: Constant.CONTAINER_SIZE_20),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Filters",
              style: theme.textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontSize: Constant.LABEL_TEXT_SIZE_20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs(ThemeData theme) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Constant.CONTAINER_SIZE_24,
        vertical: Constant.CONTAINER_SIZE_12,
      ),
      child: Row(
        children: [
          _buildTab('Month', theme),
          SizedBox(width: Constant.CONTAINER_SIZE_24),
          _buildTab('Containers', theme),
        ],
      ),
    );
  }

  Widget _buildTab(String label, ThemeData theme) {
    bool isSelected = _selectedTab == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = label;
          _searchQuery = '';
          _searchController.clear();
        });
      },
      child: Container(
        padding: EdgeInsets.only(bottom: Constant.SIZE_08),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? Color(0xFFFBBF24) : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isSelected ? Colors.white : Colors.white60,
            fontSize: Constant.LABEL_TEXT_SIZE_15,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(ThemeData theme) {
    return Padding(
      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_24),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _searchQuery = value.toLowerCase();
          });
        },
        style: TextStyle(
          color: Colors.white,
          fontSize: Constant.LABEL_TEXT_SIZE_14,
        ),
        decoration: InputDecoration(
          hintText: 'Container name or ID',
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.4),
            fontSize: Constant.LABEL_TEXT_SIZE_14,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.white.withOpacity(0.5),
            size: Constant.CONTAINER_SIZE_20,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: Constant.CONTAINER_SIZE_16,
            vertical: Constant.CONTAINER_SIZE_12,
          ),
        ),
      ),
    );
  }

  Widget _buildContent(ThemeData theme) {
    if (_selectedTab == 'Month') {
      return _buildMonthList(theme);
    } else {
      return _buildContainersList(theme);
    }
  }

  Widget _buildMonthList(ThemeData theme) {
    List<String> months = _getUniqueMonths();

    if (months.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(Constant.CONTAINER_SIZE_40),
          child: Text(
            'No months available',
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white54),
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(
        horizontal: Constant.CONTAINER_SIZE_24,
        vertical: Constant.CONTAINER_SIZE_16,
      ),
      itemCount: months.length,
      separatorBuilder: (_, __) => SizedBox(height: Constant.SIZE_08),
      itemBuilder: (context, index) {
        String month = months[index];
        bool isSelected = _selectedMonths.contains(month);

        return InkWell(
          onTap: () {
            setState(() {
              if (isSelected) {
                _selectedMonths.remove(month);
              } else {
                _selectedMonths.add(month);
              }
            });
          },
          borderRadius: BorderRadius.circular(Constant.SIZE_08),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Constant.CONTAINER_SIZE_12,
              vertical: Constant.CONTAINER_SIZE_14,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  month,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontSize: Constant.LABEL_TEXT_SIZE_15,
                  ),
                ),
                Container(
                  width: Constant.CONTAINER_SIZE_20,
                  height: Constant.CONTAINER_SIZE_20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? Color(0xFFFBBF24) : Colors.white54,
                      width: 1.5,
                    ),
                    color: isSelected ? Color(0xFFFBBF24) : Colors.transparent,
                  ),
                  child: isSelected
                      ? Icon(
                    Icons.check,
                    color: Theme.of(context).primaryColor,
                    size: Constant.CONTAINER_SIZE_12,
                  )
                      : null,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContainersList(ThemeData theme) {
    List<Map<String, String>> containers = _getUniqueContainers();

    if (_searchQuery.isNotEmpty) {
      containers = containers.where((container) {
        String name = container['name']!.toLowerCase();
        String uniqueId = container['uniqueId']!.toLowerCase();
        return name.contains(_searchQuery) || uniqueId.contains(_searchQuery);
      }).toList();
    }

    if (containers.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(Constant.CONTAINER_SIZE_40),
          child: Text(
            'No containers found',
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white54),
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(
        horizontal: Constant.CONTAINER_SIZE_24,
        vertical: Constant.CONTAINER_SIZE_16,
      ),
      itemCount: containers.length,
      separatorBuilder: (_, __) => SizedBox(height: Constant.SIZE_08),
      itemBuilder: (context, index) {
        Map<String, String> container = containers[index];
        String uniqueId = container['uniqueId']!;
        bool isSelected = _selectedContainers.contains(uniqueId);

        return InkWell(
          onTap: () {
            setState(() {
              if (isSelected) {
                _selectedContainers.remove(uniqueId);
              } else {
                _selectedContainers.add(uniqueId);
              }
            });
          },
          borderRadius: BorderRadius.circular(Constant.SIZE_08),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Constant.CONTAINER_SIZE_12,
              vertical: Constant.CONTAINER_SIZE_12,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        container['name']!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontSize: Constant.LABEL_TEXT_SIZE_15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: Constant.SIZE_04),
                      Text(
                        uniqueId,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white60,
                          fontSize: Constant.LABEL_TEXT_SIZE_14,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: Constant.CONTAINER_SIZE_20,
                  height: Constant.CONTAINER_SIZE_20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? Color(0xFFFBBF24) : Colors.white54,
                      width: 1.5,
                    ),
                    color: isSelected ? Color(0xFFFBBF24) : Colors.transparent,
                  ),
                  child: isSelected
                      ? Icon(
                    Icons.check,
                    color: Theme.of(context).primaryColor,
                    size: Constant.CONTAINER_SIZE_12,
                  )
                      : null,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildButtons(ThemeData theme, BuildContext context) {
    return SubmitClearButton(
      onLeftTap: () {
        setState(() {
          _selectedMonths.clear();
          _selectedContainers.clear();
          _searchQuery = '';
          _searchController.clear();
          ref.read(orderProvider).clearFiltersReceive();
        });
      },
      leftText: "Clear",
      rightText: "Apply",
      onRightTap: () {
        widget.onApply(_selectedMonths.toList(), _selectedContainers.toList());
        Navigator.pop(context);
      },
    );
  }
}