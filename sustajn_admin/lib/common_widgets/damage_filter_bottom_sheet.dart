import 'package:container_tracking/common_widgets/submit_clear_button.dart';
import 'package:flutter/material.dart';
import '../constants/number_constants.dart';
import '../constants/string_utils.dart';
import '../utils/date_month_utils.dart';

class DamageFilterResult {
  final RangeValues ageRange;
  final List<String> months;

  DamageFilterResult({required this.ageRange, required this.months});
}

class DamageFilterBottomSheet extends StatefulWidget {
  final Function(DamageFilterResult) onApply;

  const DamageFilterBottomSheet({super.key, required this.onApply});

  @override
  State<DamageFilterBottomSheet> createState() =>
      _DamageFilterBottomSheetState();
}

class _DamageFilterBottomSheetState extends State<DamageFilterBottomSheet> {
  int selectedMenu = 0;

  RangeValues ageRange = const RangeValues(20, 60);

  final List<String> monthList = DateMonthUtils.getCurrentYearMonths();

  final List<String> selectedMonths = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DraggableScrollableSheet(
        initialChildSize: .85,
        minChildSize: .60,
        maxChildSize: .95,
        builder: (context, controller) {
          return Container(
            decoration: BoxDecoration(
              color: Constant.PrimaryColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(Constant.CONTAINER_SIZE_24)),
            ),
            child: Column(
              children: [
                const SizedBox(height: 10),

                Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_20),
                  ),
                ),

                _header(),

                Expanded(
                  child: Row(
                    children: [
                      _leftMenu(),

                      const VerticalDivider(width: 1, color: Colors.white24),

                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: _rightView(),
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

                        selectedMonths.clear();
                      });
                    },
                    onRightTap: () {
                      widget.onApply(
                        DamageFilterResult(
                          ageRange: ageRange,
                          months: selectedMonths,
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

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Text(
            "Filters",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _leftMenu() {
    return SizedBox(
      width: 110,
      child: Column(children: [_menuTile("Age", 0), _menuTile("Month", 1)]),
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
        padding: const EdgeInsets.symmetric(vertical: 18),

        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: selected ? Colors.amber : Colors.transparent,

              width: 2,
            ),
          ),
        ),

        child: Text(
          title,

          style: TextStyle(color: selected ? Colors.amber : Colors.white70),
        ),
      ),
    );
  }

  Widget _rightView() {
   switch (selectedMenu){
     case 0:
       return _ageView();
     case 1:
       return _monthView();
     default:
       return const SizedBox();
   }
  }

  Widget _ageView() {
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

        const SizedBox(height: 20),

        const Text(
          Strings.AGE_LIMIT,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: Constant.CONTAINER_SIZE_20),

        RangeSlider(
          values: ageRange,
          min: 20,
          max: 60,
          divisions: 40,
          labels: RangeLabels(
            ageRange.start.round().toString(),
            ageRange.end.round().toString(),
          ),
          activeColor: Colors.amber,
          inactiveColor: Colors.white30,
          onChanged: (value) {
            setState(() {
              ageRange = value;
            });
          },
        ),
      ],
    );
  }

  Widget _ageBox(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(color: Colors.white70, fontSize: Constant.CONTAINER_SIZE_16,)),

        const SizedBox(height: 6),
        Container(
          width: 170,
          height: 56,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.amber, width: 1.5),
          ),
          child: Text(value, style: const TextStyle(color: Colors.white, fontSize: 18)),
        ),
      ],
    );
  }

  Widget _monthView() {
    return ListView.builder(
      itemCount: monthList.length,
      itemBuilder: (context, index) {
        final month = monthList[index];

        return RadioListTile<String>(
          value: month,
          groupValue:
          selectedMonths.isEmpty ? null : selectedMonths.first,
          activeColor: Colors.amber,
          title: Text(
            month,
            style: const TextStyle(color: Colors.white),
          ),
          onChanged: (value) {
            setState(() {
              selectedMonths
                ..clear()
                ..add(value!);
            });
          },
        );
      },
    );
  }
}
