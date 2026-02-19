import 'package:flutter/material.dart';
import '../../constants/number_constants.dart';

class ProductFilter extends StatefulWidget {
  const ProductFilter({super.key, required String title, required String leftTabTitle, required List<String> options, String? selectedValue, required Null Function(value) onApply});

  @override
  State<ProductFilter> createState() =>
      _OrderFilterBottomSheetState();
}

class value {
}

class _OrderFilterBottomSheetState extends State<ProductFilter> {

  final List<String> sections = [
    "Month",
    "Containers",
  ];

  int selectedSection = 0;

  String? selectedMonth;

  final Set<String> selectedContainers = {};

  final months = [
    "January–2026",
    "December–2025",
    "November–2025",
    "October–2025",
    "September–2025",
    "August–2025",
  ];

  final containers = [
    "Dip Cups",
    "Round Bowl",
    "Rectangular Container",
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      margin: EdgeInsets.all(Constant.CONTAINER_SIZE_10),
      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_12),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
      ),
      child: Column(
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Filters",
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              InkWell(
                onTap: () => Navigator.pop(context),
                borderRadius: BorderRadius.circular(
                  Constant.CONTAINER_SIZE_20,
                ),
                child: Container(
                  padding: EdgeInsets.all(Constant.SIZE_06),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: Constant.CONTAINER_SIZE_18,
                  ),
                ),
              ),
            ],
          ),


          SizedBox(height: Constant.CONTAINER_SIZE_12),

          Expanded(
            child: Row(
              children: [

                Flexible(
                  flex: 3,
                  child: Column(
                    children: List.generate(
                      sections.length,
                          (index) => _leftMenuItem(
                        context,
                        title: sections[index],
                        isSelected: selectedSection == index,
                        onTap: () {
                          setState(() {
                            selectedSection = index;
                          });
                        },
                      ),
                    ),
                  ),
                ),

                Container(
                  width: 1,
                  margin: EdgeInsets.symmetric(
                    horizontal: Constant.SIZE_10,
                  ),
                  color: Colors.white24,
                ),

                Expanded(
                  flex: 7,
                  child: _buildRightContent(context),
                ),
              ],
            ),
          ),

          SizedBox(height: Constant.CONTAINER_SIZE_10),

          Row(
            children: [
              Expanded(
                child: _actionButton(
                  context,
                  title: "Clear",
                  filled: false,
                  onTap: () {
                    setState(() {
                      selectedMonth = null;
                      selectedContainers.clear();
                    });
                  },
                ),
              ),
              SizedBox(width: Constant.CONTAINER_SIZE_10),
              Expanded(
                child: _actionButton(
                  context,
                  title: "Apply",
                  filled: true,
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _leftMenuItem(
      BuildContext context, {
        required String title,
        required bool isSelected,
        required VoidCallback onTap,
      }) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: Constant.CONTAINER_SIZE_12,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ?Constant.gold : Colors.transparent,
              width: 1,
            ),
          ),
        ),
        child: Text(
          title,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isSelected ? Constant.gold : Colors.white70,
          ),
        ),
      ),
    );
  }

  Widget _buildRightContent(BuildContext context) {
    switch (selectedSection) {
      case 0:
        return _radioList(
          months,
          selectedMonth,
              (v) => setState(() => selectedMonth = v),
        );

      case 1:
        return _containerList(context);
      default:
        return const SizedBox();
    }
  }

  Widget _radioList(
      List<String> items,
      String? groupValue,
      ValueChanged<String> onChanged,
      ) {
    final theme = Theme.of(context);

    return Theme(
      data: Theme.of(context).copyWith(
        unselectedWidgetColor: Colors.white,
        radioTheme: RadioThemeData(
          fillColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (states.contains(MaterialState.selected)) {
              return Constant.gold;
            }
            return Colors.white;
          }),
        ),
      ),
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (_, index) {
          final item = items[index];

          return RadioListTile<String>(
            value: item,
            groupValue: groupValue,
            contentPadding: EdgeInsets.zero,
            title: Text(
              item,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: Colors.white,
              ),
            ),
            onChanged: (v) => onChanged(v!),
          );
        },
      ),
    );
  }


  Widget _containerList(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            hintText: "Search name or ID",
            hintStyle: TextStyle(color: Colors.white70),
            prefixIcon: Icon(Icons.search, color: Colors.white54),
            filled: true,
            fillColor: Colors.white.withOpacity(0.05),
            border: OutlineInputBorder(
              borderRadius:
              BorderRadius.circular(Constant.CONTAINER_SIZE_10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        SizedBox(height: Constant.CONTAINER_SIZE_10),

        Expanded(
          child: ListView.builder(
            itemCount: containers.length,
            itemBuilder: (_, index) {
              final item = containers[index];
              final selected = selectedContainers.contains(item);

              return   Theme(
                data: Theme.of(context).copyWith(
                  unselectedWidgetColor: Constant.gold,
                  checkboxTheme: CheckboxThemeData(
                    fillColor: MaterialStateProperty.resolveWith<Color>((states) {
                      if (states.contains(MaterialState.selected)) {
                        return Constant.gold;
                      }
                      return Colors.transparent;
                    }),
                    side: BorderSide(
                      color:Constant.gold,
                      width: 1.5,
                    ),
                    checkColor: MaterialStateProperty.all(Colors.black),
                  ),
                ),
                child: CheckboxListTile(
                  value: selected,
                  controlAffinity: ListTileControlAffinity.trailing,
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    item,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  onChanged: (_) {
                    setState(() {
                      if (selected) {
                        selectedContainers.remove(item);
                      } else {
                        selectedContainers.add(item);
                      }
                    });
                  },
                ),
              );


            },
          ),
        ),
      ],
    );
  }

  Widget _actionButton(
      BuildContext context, {
        required String title,
        required bool filled,
        required VoidCallback onTap,
      }) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: Constant.CONTAINER_SIZE_12,
        ),
        decoration: BoxDecoration(
          color: filled ? Constant.gold : Colors.transparent,
          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
          border: Border.all(color: Constant.gold),
        ),
        child: Center(
          child: Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              color: filled ? Colors.black : Constant.gold,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}