import 'package:container_tracking/common_widgets/submit_clear_button.dart';

import '../constants/imports.util.dart';
import '../utils/theme_utils.dart';
import 'card_widget.dart';

class ReusableFilter extends StatefulWidget {
  final String title;
  final String leftTabTitle;
  final String leftTabTitles;
  final List<String> options;
  final String? selectedValue;
  final List<String> planType;
  final String? selectedPlanType;
  final Function(String?, String?) onApply;

  const ReusableFilter({
    super.key,
    required this.title,
    required this.leftTabTitle,
    required this.options,
    required this.onApply,
    this.selectedValue,
    required this.planType,
    this.selectedPlanType,
    required this.leftTabTitles,
  });

  @override
  State<ReusableFilter> createState() =>
      _ReusableFilterBottomSheetState();
}

class _ReusableFilterBottomSheetState
    extends State<ReusableFilter> {
  String? selectedOption;
  String? selectedPlanType;
  int selectedTab = 0;
  @override
  void initState() {
    super.initState();
    selectedOption = widget.selectedValue;
    selectedPlanType = widget.selectedPlanType;
  }

  @override
  Widget build(BuildContext context) {
    final themeData = CustomTheme.getTheme(true);
    final height = MediaQuery.of(context).size.height * 0.92;
    final width = MediaQuery.of(context).size.width;

    return GlassSummaryCard(
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: themeData!.textTheme.titleLarge!.copyWith(
                    fontSize: Constant.LABEL_TEXT_SIZE_20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: EdgeInsets.all(Constant.SIZE_02),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: themeData.secondaryHeaderColor,
                    ),
                    child: Icon(
                      Icons.close,
                      size: Constant.SIZE_HEIGHT_20,
                      color: themeData.colorScheme.onSurface,
                    ),
                  ),
                )
              ],
            ),

            SizedBox(height: Constant.CONTAINER_SIZE_20),


            SizedBox(
              height: height*0.6,
              child: Row(
                children: [
                  Container(
                    width: width * 0.25,
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: themeData.dividerColor.withOpacity(0.4),
                          width: Constant.SIZE_01,
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              selectedTab = 0;
                            });
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: selectedTab == 0
                                      ? themeData.secondaryHeaderColor
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                            ),
                            child: Text(
                              widget.leftTabTitles, // Plan Type
                              style: TextStyle(
                                color: selectedTab == 0
                                    ? themeData.secondaryHeaderColor
                                    : Colors.white,
                              ),
                            ),
                          ),
                        ),

                        InkWell(
                          onTap: () {
                            setState(() {
                              selectedTab = 1;
                            });
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: selectedTab == 1
                                      ? themeData.secondaryHeaderColor
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                            ),
                            child: Text(
                              widget.leftTabTitle, // Month
                              style: TextStyle(
                                color: selectedTab == 1
                                    ? themeData.secondaryHeaderColor
                                    : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: List.generate(
                          selectedTab == 0
                              ? widget.planType.length
                              : widget.options.length,
                              (index) {
                            final value = selectedTab == 0
                                ? widget.planType[index]
                                : widget.options[index];

                            return RadioListTile<String>(
                              value: value,
                              groupValue:
                              selectedTab == 0 ? selectedPlanType : selectedOption,
                              activeColor: themeData.secondaryHeaderColor,
                              onChanged: (val) {
                                setState(() {
                                  if (selectedTab == 0) {
                                    selectedPlanType = val;
                                  } else {
                                    selectedOption = val;
                                  }
                                });
                              },
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                value,
                                style: themeData.textTheme.bodyMedium,
                              ),
                              controlAffinity: ListTileControlAffinity.leading,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: Constant.CONTAINER_SIZE_20),
            SubmitClearButton(onLeftTap: (){
              setState(() {
                selectedOption = null;
                selectedPlanType = null;
              });
            }, onRightTap: (){  widget.onApply(selectedOption,selectedPlanType);
            Navigator.pop(context);})

          ],
        ),
      ),
    );
  }
}
