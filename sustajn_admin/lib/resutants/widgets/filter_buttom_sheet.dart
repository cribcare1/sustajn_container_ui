import 'package:flutter/material.dart';
import '../../common_widgets/custom_buttons.dart';

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
    "January","February","March","April","May","June",
    "July","August","September","October","November","December",
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
            // Close Button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                  padding: const EdgeInsets.all(4),
                  margin: const EdgeInsets.all(8),
                  child: InkWell(
                    child: const Icon(Icons.close, size: 20),
                    onTap: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),

            // Main Content
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Filters",
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // LEFT TABS
                          Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _selectorTab(
                                  label: "Month",
                                  isSelected: showMonthView,
                                  onTap: () => setState(() => showMonthView = true),
                                ),
                                const SizedBox(height: 25),
                                _selectorTab(
                                  label: "Containers",
                                  isSelected: !showMonthView,
                                  onTap: () => setState(() => showMonthView = false),
                                ),
                              ],
                            ),
                          ),
                          const VerticalDivider(color: Colors.black, thickness: 1, indent: 1),
                          // RIGHT CONTENT AREA
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: showMonthView
                                  ? _buildMonthView(years)
                                  : _buildContainerView(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: ActionButtons(
                        onClear: () {
                          if (showMonthView) {
                            setState(() => selectedMonth = null);
                          } else {
                            setState(() =>
                                selectedContainers.updateAll((key, value) => false));
                          }
                        },
                        onApply: () => Navigator.pop(context),
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
    return Column(
      children: [
        SizedBox(
          height: 50,
          child: TextField(
            decoration: const InputDecoration(
              hintText: "Search name or ID",
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
        const SizedBox(height: 10),
        // LIST
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
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name, style: const TextStyle(fontSize: 15)),
                        const SizedBox(height: 3),
                        Text(id,
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey.shade600)),
                      ],
                    ),
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
                  )
                ],
              );
            },
          ),
        ),
      ],
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
          if (isSelected)
            Container(
              width: 80,
              height: 2,
              color: Colors.green,
            ),
        ],
      ),
    );
  }
}
