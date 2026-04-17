import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common_widgets/submit_clear_button.dart';
import '../../../constants/imports.util.dart';
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

  // ================= MONTH =================
  List<String> _getUniqueMonths() {
    Set<String> months = {};

    for (var item in widget.items) {
      String monthYear = _getMonthYear(item.dateTime);
      if (monthYear != 'Unknown') {
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
        .map((e) => {'name': e.value, 'uniqueId': e.key})
        .toList();

    list.sort((a, b) => a['name']!.compareTo(b['name']!));

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
      return 'Unknown';
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
          /// Close button
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.all(Constant.CONTAINER_SIZE_12),
              child: InkWell(
                onTap: () => Navigator.pop(context),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.close, color: Colors.black),
                ),
              ),
            ),
          ),

          /// Main Container
          Container(
            height: height,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(Constant.CONTAINER_SIZE_30)),
            ),
            child: Column(
              children: [
                _header(theme),

                Expanded(
                  child: Row(
                    children: [
                      _leftTabs(theme),
                      Container(width: 1, color: Colors.white24),
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
          "Filter",
          style: theme.textTheme.titleLarge?.copyWith(
            color: Colors.white,
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
        children: [_tabItem('Month', theme), _tabItem('Containers', theme)],
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
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: selected ? Colors.amber : Colors.transparent,
              width: 3,
            ),
          ),
          color: selected ? Colors.white10 : null,
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(label, style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  Widget _rightContent() {
    return Column(
      children: [
        if (_selectedTab == 'Containers')
          Padding(
            padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
            child: TextField(
              controller: _searchController,
              onChanged: (v) {
                setState(() => _searchQuery = v.toLowerCase());
              },
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Search Container",
                hintStyle: TextStyle(color: Colors.white54),
                prefixIcon: Icon(Icons.search, color: Colors.white),
                border: InputBorder.none,
              ),
            ),
          ),

        Expanded(
          child: _selectedTab == 'Month' ? _monthList() : _containerList(),
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
          title: Text(m, style: TextStyle(color: Colors.white)),
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
        return c['name']!.toLowerCase().contains(_searchQuery) ||
            c['uniqueId']!.toLowerCase().contains(_searchQuery);
      }).toList();
    }

    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (_, i) {
        final item = list[i];
        final id = item['uniqueId']!;
        final selected = _selectedContainers.contains(id);

        return ListTile(
          title: Text(item['name']!, style: TextStyle(color: Colors.white)),
          subtitle: Text(id, style: TextStyle(color: Colors.white70)),
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
        leftText: "Clear",
        rightText: "Apply",
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
