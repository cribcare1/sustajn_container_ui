import 'package:flutter/material.dart';
import 'package:container_tracking/common_widgets/submit_clear_button.dart';
import '../../utils/date_month_utils.dart';
import '../constants/number_constants.dart';
import '../transactions/models/transaction_sold_data.dart';

class SoldFilterResult {
  RangeValues ageRange;
  List<String> soldBy;
  List<String> months;
  List<Containers> containers;

  SoldFilterResult({
    required this.ageRange,
    required this.soldBy,
    required this.months,
    required this.containers,
  });
}

class SoldFilterBottomSheet extends StatefulWidget {
  final Function(SoldFilterResult) onApply;

  const SoldFilterBottomSheet({super.key, required this.onApply});

  @override
  State<SoldFilterBottomSheet> createState() => _SoldFilterBottomSheetState();
}

class _SoldFilterBottomSheetState extends State<SoldFilterBottomSheet> {
  int selectedMenu = 0;

  RangeValues ageRange = const RangeValues(20, 60);

  final List<String> soldByList = ["Pravin", "Rahul", "Ramesh", "Suresh"];
  final List<String> monthList = DateMonthUtils.getCurrentYearMonths();

  final List<Containers> containerList = [];

  final List<String> selectedSoldBy = [];
  final List<String> selectedMonths = [];
  final List<Containers> selectedContainers = [];

  TextEditingController containerSearchController = TextEditingController();

  late List<Containers> filteredContainers = [];

  @override
  void initState() {
    super.initState();
    filteredContainers = List.from(containerList);
  }

  void _filterContainers(String value) {
    setState(() {
      filteredContainers = containerList.where((e) {
        return (e.containerName ?? "")
            .toLowerCase()
            .contains(value.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DraggableScrollableSheet(
        initialChildSize: .85,
        minChildSize: .60,
        maxChildSize: .95,
        builder: (context, controller) {
          return Container(
            decoration: const BoxDecoration(
              color: Constant.PrimaryColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                SizedBox(height: Constant.CONTAINER_SIZE_12),

                Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Text(
                        "Filters",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const Spacer(),

                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: Row(
                    children: [
                      // Left Menu
                      Container(
                        width: 110,
                        color: Constant.PrimaryColor,
                        child: ListView(
                          children: [
                            _menuTile("Age", 0),
                            _menuTile("Sold By", 1),
                            _menuTile("Month", 2),
                            _menuTile("Container", 3),
                          ],
                        ),
                      ),

                      // Vertical Divider
                      const VerticalDivider(
                        width: 1,
                        thickness: 1,
                        color: Colors.white24,
                      ),

                      // Right Content
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: _buildRightView(),
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SubmitClearButton(
                    onLeftTap: () {
                      setState(() {
                        ageRange = const RangeValues(20, 60);

                        selectedSoldBy.clear();

                        selectedMonths.clear();

                        selectedContainers.clear();
                      });
                    },
                    onRightTap: () {
                      widget.onApply(
                        SoldFilterResult(
                          ageRange: ageRange,
                          soldBy: selectedSoldBy,
                          months: selectedMonths,
                          containers: selectedContainers,
                        ),
                      );

                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _menuTile(String title, int index) {
    final selected = selectedMenu == index;

    return InkWell(
      onTap: () {
        setState(() {
          selectedMenu = index;
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 12,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: selected
                  ? const Color(0xFFE5C84B)
                  : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: selected
                ? const Color(0xFFE5C84B)
                : Colors.white70,
            fontSize: 15,
            fontWeight: selected
                ? FontWeight.w600
                : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildRightView() {
    switch (selectedMenu) {
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: _ageBox(
                    "Min",
                    ageRange.start.round().toString(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ageBox(
                    "Max",
                    ageRange.end.round().toString(),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            const Text("Age Limit", style: TextStyle(color:Colors.white, fontWeight: FontWeight.bold)),

            RangeSlider(
              values: ageRange,
              min: 20,
              max: 60,
              divisions: 82,
              labels: RangeLabels(
                ageRange.start.round().toString(),
                ageRange.end.round().toString(),
              ),
              onChanged: (value) {
                setState(() {
                  ageRange = value;
                });
              },
            ),
          ],
        );

      case 1:
        return _checkBoxList(soldByList, selectedSoldBy);

      case 2:
        return _buildMonthView();

      case 3:
        return _buildContainerView();

      default:
        return const SizedBox();
    }
  }

  Widget _ageBox(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xFFE5C84B),
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMonthView() {
    return ListView.builder(
      itemCount: monthList.length,
      itemBuilder: (context, index) {
        final month = monthList[index];

        return RadioListTile<String>(
          value: month,
          groupValue: selectedMonths.isEmpty ? null : selectedMonths.first,
          onChanged: (value) {
            setState(() {
              selectedMonths
                ..clear()
                ..add(value!);
            });
          },
          activeColor: const Color(0xFFE5C84B),
          tileColor: Colors.transparent,
          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
          title: Text(
            month,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
          controlAffinity: ListTileControlAffinity.trailing,
        );
      },
    );
  }

  Widget _buildContainerView() {
    return Column(
      children: [

        TextField(
          controller: containerSearchController,
          onChanged: _filterContainers,
          style: const TextStyle(
            color: Colors.white,
          ),
          cursorColor: Colors.white,
          decoration: InputDecoration(
            hintText: "Search name or ID",
            hintStyle: const TextStyle(
              color: Colors.white70,
            ),
            prefixIcon: const Icon(
              Icons.search,
              color: Colors.white70,
            ),
            filled: true,
            fillColor: const Color(0xFF0E3B2E), // Dark green
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFE5C84B),
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        Expanded(
          child: ListView.builder(
            itemCount: filteredContainers.length,
            itemBuilder: (context, index) {

              final item = filteredContainers[index];

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text(
                            item.containerName ?? "",
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            "ST-ID-${index + 100}",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                            ),
                          ),

                        ],
                      ),
                    ),

                    Checkbox(
                      value: selectedContainers.contains(item),
                      onChanged: (value) {
                        setState(() {
                          if (value == true) {
                            selectedContainers.add(item);
                          } else {
                            selectedContainers.remove(item);
                          }
                        });
                      },
                    ),

                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _checkBoxList(List<String> values, List<String> selected) {
    return ListView.builder(
      itemCount: values.length,
      itemBuilder: (context, index) {
        final value = values[index];

        return CheckboxListTile(
          value: selected.contains(value),

          title: Text(value),

          onChanged: (checked) {
            setState(() {
              if (checked == true) {
                selected.add(value);
              } else {
                selected.remove(value);
              }
            });
          },
        );
      },
    );
  }
}
