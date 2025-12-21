import 'package:container_tracking/common_widgets/card_widget.dart';
import 'package:container_tracking/common_widgets/submit_clear_button.dart';
import 'package:flutter/material.dart';
import '../constants/number_constants.dart';
import '../utils/theme_utils.dart';

class ReusableFilterBottomSheet extends StatefulWidget {
  final String title;
  final String leftTabTitle;
  final List<String> options;
  final String? selectedValue;
  final Function(String?) onApply;

  const ReusableFilterBottomSheet({
    super.key,
    required this.title,
    required this.leftTabTitle,
    required this.options,
    required this.onApply,
    this.selectedValue,
  });

  @override
  State<ReusableFilterBottomSheet> createState() =>
      _ReusableFilterBottomSheetState();
}

class _ReusableFilterBottomSheetState
    extends State<ReusableFilterBottomSheet> {
  String? selectedOption;

  @override
  void initState() {
    super.initState();
    selectedOption = widget.selectedValue;
  }

  @override
  Widget build(BuildContext context) {
    final themeData = CustomTheme.getTheme(true);
    final height = MediaQuery.of(context).size.height * 0.92;
    final width = MediaQuery.of(context).size.width;

    return GlassSummaryCard(
      // height: height,
      // width: width,
      // padding: EdgeInsets.all(Constant.CONTAINER_SIZE_20),
      // decoration: BoxDecoration(
      //   color: themeData!.primaryColor,
      //   borderRadius: BorderRadius.only(
      //     topLeft: Radius.circular(Constant.CONTAINER_SIZE_20),
      //     topRight: Radius.circular(Constant.CONTAINER_SIZE_20),
      //   ),
      // ),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.leftTabTitle,
                          style: themeData.textTheme.titleMedium,
                        ),
                        SizedBox(height: Constant.CONTAINER_SIZE_20),
                      ],
                    ),
                  ),


                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: List.generate(
                          widget.options.length,
                              (index) => RadioListTile(
                            value: widget.options[index],
                            activeColor: themeData.secondaryHeaderColor,
                            groupValue: selectedOption,
                            onChanged: (val) {
                              setState(() {
                                selectedOption = val;
                              });
                            },
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              widget.options[index],
                              style: themeData.textTheme.bodyMedium?.copyWith(
                                fontSize: Constant.LABEL_TEXT_SIZE_16,
                                color: themeData.colorScheme.onSurface,
                              ),
                            ),
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: Constant.CONTAINER_SIZE_20),
            SubmitClearButton(onLeftTap: (){
              setState(() => selectedOption = null);
            }, onRightTap: (){  widget.onApply(selectedOption);
            Navigator.pop(context);})

          ],
        ),
      ),
    );
  }
}
