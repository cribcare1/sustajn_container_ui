import 'package:flutter/material.dart';
import 'package:sustajn_restaurant/common_widgets/submit_clear_button.dart';

import '../constants/number_constants.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  int selectedYear = DateTime.now().year;
  String? selectedMonth;

  bool showMonthView = true;

  final months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];

  final List<Map<String, String>> containerList = [
    {"name": "Dip Cups", "id": "ST-DC-50"},
    {"name": "Dip Cups", "id": "ST-DC-70"},
    {"name": "Dip Cups", "id": "ST-DC-85"},
    {"name": "Round Bowl", "id": "ST-RB-450"},
    {"name": "Round Bowl", "id": "ST-RB-900"},
    {"name": "Rectangular Container", "id": "ST-RC-600"},
    {"name": "Rectangular Container", "id": "ST-RC-1000"},
    {"name": "Rectangular Container", "id": "ST-RC-1200"},
    {"name": "Rectangular Container", "id": "ST-RC-1800"},
  ];

  Map<String, bool> selectedContainers = {};

  @override
  void initState() {
    super.initState();
    for (var c in containerList) {
      selectedContainers[c["id"]!] = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final years = List.generate(6, (i) => DateTime.now().year - i);
    return SafeArea(
      top: false,
      bottom: true,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.all(4),
                  margin: const EdgeInsets.all(8),
                  child: InkWell(
                    child: const Icon(Icons.close, size: 20),
                    onTap: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),

            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Containers",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildContainerView(),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:  EdgeInsets.all(Constant.CONTAINER_SIZE_16),
                      child: SubmitClearButton(
                        onLeftTap: () {
                          setState(() {
                            selectedMonth = null;
                            selectedContainers.updateAll((key, value) => false);
                          });
                          Navigator.pop(context);
                        },
                        onRightTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthView(List<int> years) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _dropdownContainer(
          child: DropdownButton<int>(
            value: selectedYear,
            isExpanded: true,
            underline: const SizedBox(),
            items: years
                .map((y) => DropdownMenuItem(value: y, child: Text("$y")))
                .toList(),
            onChanged: (value) => setState(() => selectedYear = value!),
          ),
        ),
        const SizedBox(height: 10),
        _dropdownContainer(
          child: DropdownButton<String>(
            value: selectedMonth,
            hint: const Text("Select Month"),
            isExpanded: true,
            underline: const SizedBox(),
            items: months
                .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                .toList(),
            onChanged: (value) => setState(() => selectedMonth = value),
          ),
        ),
      ],
    );
  }

  Widget _dropdownContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: child,
    );
  }

  Widget _buildContainerView() {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: Constant.CONTAINER_SIZE_16),
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.05,
            child:  TextField(
              style: Theme.of(context).textTheme.titleSmall,
              decoration: InputDecoration(
                hintText: "Search name or ID",
                hintStyle: Theme.of(context).textTheme.titleSmall,
                border: InputBorder.none,
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: containerList.length,
              itemBuilder: (context, index) {
                final item = containerList[index];
                final name = item["name"]!;
                final id = item["id"]!;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name, style: Theme.of(context).textTheme.titleSmall),
                        const SizedBox(height: 3),
                        Text(
                          id,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    Checkbox(
                      activeColor: Theme.of(context).primaryColor,
                      checkColor: Colors.white,
                      value: selectedContainers[id],
                      onChanged: (value) {
                        setState(() {
                          selectedContainers[id] = value!;
                        });
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

  Widget _selectorTab({
    required String label,
    required bool isSelected,
    required Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: isSelected ? Colors.black : Colors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          const SizedBox(height: 4),
          if (isSelected) Container(width: 80, height: 2, color: Colors.green),
        ],
      ),
    );
  }
}