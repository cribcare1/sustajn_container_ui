import 'package:flutter/material.dart';
import 'package:container_tracking/common_widgets/submit_clear_button.dart';
import '../utils/date_month_utils.dart';

class DamagePartnerFilterResult {
  final List<String> months;

  DamagePartnerFilterResult({
    required this.months,
  });
}

class DamagePartnerFilterBottomSheet extends StatefulWidget {
  final Function(DamagePartnerFilterResult) onApply;

  const DamagePartnerFilterBottomSheet({
    super.key,
    required this.onApply,
  });

  @override
  State<DamagePartnerFilterBottomSheet> createState() =>
      _DamagePartnerFilterBottomSheetState();
}

class _DamagePartnerFilterBottomSheetState
    extends State<DamagePartnerFilterBottomSheet> {

  final List<String> monthList =
  DateMonthUtils.getCurrentYearMonths();

  final List<String> selectedMonths = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DraggableScrollableSheet(
        initialChildSize: .75,
        minChildSize: .50,
        maxChildSize: .90,
        builder: (context, controller) {
          return Container(
            decoration: const BoxDecoration(
              color: Color(0xFF0E3B2E),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [

                const SizedBox(height: 10),

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
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const Spacer(),

                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.close,color: Colors.white),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    controller: controller,
                    itemCount: monthList.length,
                    itemBuilder: (context,index){

                      final month = monthList[index];

                      return RadioListTile<String>(
                        value: month,
                        groupValue: selectedMonths.isEmpty
                            ? null
                            : selectedMonths.first,
                        activeColor: Colors.amber,
                        title: Text(
                          month,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onChanged: (value){
                          setState(() {
                            selectedMonths
                              ..clear()
                              ..add(value!);
                          });
                        },
                      );
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SubmitClearButton(
                    onLeftTap: (){
                      setState(() {
                        selectedMonths.clear();
                      });
                    },
                    onRightTap: (){
                      widget.onApply(
                        DamagePartnerFilterResult(
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
}