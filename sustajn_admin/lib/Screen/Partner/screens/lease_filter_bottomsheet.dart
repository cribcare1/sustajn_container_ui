import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common_widgets/submit_clear_button.dart';
import '../../../constants/imports.util.dart';
import '../../../constants/string_utils.dart';
import '../model/container_history_data.dart';

class FilterItem {
  final String dateTime;
  final List<ProductOrderListResponses>? products;

  FilterItem({required this.dateTime, required this.products});
}

class CommonFilterBottomSheet extends ConsumerStatefulWidget {
  final List<FilterItem> items;
  final Function(List<String>, List<String>) onApply;

  const CommonFilterBottomSheet({
    super.key,
    required this.items,
    required this.onApply,
  });

  @override
  ConsumerState<CommonFilterBottomSheet> createState() =>
      _CommonFilterBottomSheetState();
}

class _CommonFilterBottomSheetState
    extends ConsumerState<CommonFilterBottomSheet> {
  String _selectedTab = Strings.MONTH;
  final Set<String> _selectedMonths = {};
  final Set<String> _selectedContainers = {};
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ================= MONTH =================
  List<String> _getUniqueMonths() {
    Set<String> months = {};

    for (var item in widget.items) {
      String monthYear = _getMonthYear(item.dateTime);
      if (monthYear != Strings.UNKNOWN) {
        months.add(monthYear);
      }
    }

    List<String> sorted = months.toList();
    sorted.sort((a, b) => _parseMonthYear(b).compareTo(_parseMonthYear(a)));

    return sorted;
  }

  // ================= CONTAINERS =================
  List<Map<String, String>> _getUniqueContainers() {
    Map<String, String> containersMap = {};

    for (var item in widget.items) {
      if (item.products != null) {
        for (var product in item.products!) {
          String name = product.productName ?? '';
          String id = product.productUniqueId ?? '';

          if (name.isNotEmpty && id.isNotEmpty) {
            containersMap[id] = name;
          }
        }
      }
    }

    List<Map<String, String>> list = containersMap.entries
        .map((e) => {Strings.NAME: e.value, Strings.UNIQUEID: e.key})
        .toList();

    list.sort((a, b) => a[Strings.NAME]!.compareTo(b[Strings.NAME]!));

    return list;
  }

  // ================= DATE FORMAT =================
  String _getMonthYear(String dateTimeStr) {
    try {
      List<String> parts = dateTimeStr.split('|');
      List<String> dateParts = parts[0].split('/');

      int month = int.parse(dateParts[1]);
      String year = dateParts[2];

      const months = [
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

      return '${months[month - 1]}-$year';
    } catch (e) {
      return Strings.UNKNOWN;
    }
  }

  DateTime _parseMonthYear(String monthYear) {
    try {
      List<String> parts = monthYear.split('-');

      const months = [
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

      int month = months.indexOf(parts[0]) + 1;
      int year = int.parse(parts[1]);

      return DateTime(year, month);
    } catch (e) {
      return DateTime.now();
    }
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final height = MediaQuery.of(context).size.height * 0.7;

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.all(Constant.CONTAINER_SIZE_12),
              child: InkWell(
                onTap: () => Navigator.pop(context),
                child: CircleAvatar(
                  backgroundColor: Constant.white,
                  child: Icon(Icons.close, color: Constant.black),
                ),
              ),
            ),
          ),

          Container(
            height: height,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(Constant.CONTAINER_SIZE_30),
              ),
            ),
            child: Column(
              children: [
                _header(theme),

                Expanded(
                  child: Row(
                    children: [
                      _leftTabs(theme),
                      Container(
                        width: Constant.SIZE_01,
                        color: Constant.white2,
                      ),
                      Expanded(child: _rightContent()),
                    ],
                  ),
                ),

                _buttons(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _header(ThemeData theme) {
    return Padding(
      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_20),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          Strings.FILTERS,
          style: theme.textTheme.titleLarge?.copyWith(
            color: Constant.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _leftTabs(ThemeData theme) {
    return SizedBox(
      width: Constant.CONTAINER_SIZE_120,
      child: Column(
        children: [
          _tabItem(Strings.MONTH, theme),
          _tabItem(Strings.CONTAINERS_TITLE, theme),
        ],
      ),
    );
  }

  Widget _tabItem(String label, ThemeData theme) {
    final selected = _selectedTab == label;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedTab = label;
          _searchController.clear();
          _searchQuery = '';
        });
      },
      child: Container(
        padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: selected
                  ? Constant.PrimaryAssentColor
                  : Colors.transparent,
              width: Constant.SIZE_03,
            ),
          ),
          color: selected ? Constant.white1 : null,
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(label, style: TextStyle(color: Constant.white)),
        ),
      ),
    );
  }

  Widget _rightContent() {
    return Column(
      children: [
        if (_selectedTab == Strings.CONTAINERS_TITLE)
          Padding(
            padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
            child: TextField(
              controller: _searchController,
              onChanged: (v) {
                setState(() => _searchQuery = v.toLowerCase());
              },
              style: TextStyle(color: Constant.white),
              decoration: InputDecoration(
                hintText: Strings.SEARCH_CONTAINER,
                hintStyle: TextStyle(color: Constant.white2),
                prefixIcon: Icon(Icons.search, color: Constant.white),
                border: InputBorder.none,
              ),
            ),
          ),

        Expanded(
          child: _selectedTab == Strings.MONTH
              ? _monthList()
              : _containerList(),
        ),
      ],
    );
  }

  Widget _monthList() {
    final months = _getUniqueMonths();

    return ListView.builder(
      itemCount: months.length,
      itemBuilder: (_, i) {
        final m = months[i];
        final selected = _selectedMonths.contains(m);

        return ListTile(
          title: Text(m, style: TextStyle(color: Constant.white)),
          trailing: Checkbox(
            value: selected,
            onChanged: (_) {
              setState(() {
                selected ? _selectedMonths.remove(m) : _selectedMonths.add(m);
              });
            },
          ),
        );
      },
    );
  }

  Widget _containerList() {
    var list = _getUniqueContainers();

    if (_searchQuery.isNotEmpty) {
      list = list.where((c) {
        return c[Strings.NAME]!.toLowerCase().contains(_searchQuery) ||
            c[Strings.UNIQUEID]!.toLowerCase().contains(_searchQuery);
      }).toList();
    }

    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (_, i) {
        final item = list[i];
        final id = item[Strings.UNIQUEID]!;
        final selected = _selectedContainers.contains(id);

        return ListTile(
          title: Text(
            item[Strings.NAME]!,
            style: TextStyle(color: Constant.white),
          ),
          subtitle: Text(id, style: TextStyle(color: Constant.white3)),
          trailing: Checkbox(
            value: selected,
            onChanged: (_) {
              setState(() {
                selected
                    ? _selectedContainers.remove(id)
                    : _selectedContainers.add(id);
              });
            },
          ),
        );
      },
    );
  }

  Widget _buttons() {
    return Padding(
      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_20),
      child: SubmitClearButton(
        leftText: Strings.CLEAR,
        rightText: Strings.APPLY,
        onLeftTap: () {
          setState(() {
            _selectedMonths.clear();
            _selectedContainers.clear();
            _searchController.clear();
            _searchQuery = '';
          });
        },
        onRightTap: () {
          widget.onApply(
            _selectedMonths.toList(),
            _selectedContainers.toList(),
          );
          Navigator.pop(context);
        },
      ),
    );
  }
}
